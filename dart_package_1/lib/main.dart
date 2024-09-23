import 'dart:io';  // For getting user input from the console
import 'package:crypto/crypto.dart';
import 'package:dart_package_1/db_connection.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:convert';

// Function to hash the password using SHA256
String hashPassword(String password) {
  var bytes = utf8.encode(password);
  var digest = sha256.convert(bytes);
  return digest.toString();
}

// Function to register a user
Future<void> registerUser(MySqlConnection conn, String username, String email, String password) async {
  String hashedPassword = hashPassword(password);
  var result = await conn.query(
      'INSERT INTO users (username, email, password) VALUES (?, ?, ?)',
      [username, email, hashedPassword]);

  print('User Registered: ID=${result.insertId}');
}

// Function to log in a user
Future<bool> loginUser(MySqlConnection conn, String username, String password) async {
  String hashedPassword = hashPassword(password);
  var results = await conn.query(
      'SELECT * FROM users WHERE username = ? AND password = ?',
      [username, hashedPassword]);

  return results.isNotEmpty;
}

// Function to prompt user input from the console
String prompt(String message) {
  stdout.write(message);
  return stdin.readLineSync() ?? "";
}

// Function to handle registration process
Future<void> handleRegistration(MySqlConnection conn) async {
  print("=== Register ===");
  String username = prompt("Enter username: ");
  String email = prompt("Enter email: ");
  String password = prompt("Enter password: ");
  await registerUser(conn, username, email, password);
}

// Function to handle login process
Future<void> handleLogin(MySqlConnection conn) async {
  print("=== Login ===");
  String username = prompt("Enter username: ");
  String password = prompt("Enter password: ");
  bool loginSuccess = await loginUser(conn, username, password);
  if (loginSuccess) {
    print("Login Successful!");
  } else {
    print("Login Failed. Invalid credentials.");
  }
}

void main() async {
  // Open a connection to the MySQL database
  var conn = await openConnection();

  bool exit = false;

  // Loop to allow user to Register, Login, or Exit
  while (!exit) {
    print("\n=== Welcome to the Secure Credentials Backup System ===");
    print("1. Register");
    print("2. Login");
    print("3. Exit");
    
    String choice = prompt("Choose an option (1/2/3): ");

    switch (choice) {
      case '1':
        await handleRegistration(conn);
        break;
      case '2':
        await handleLogin(conn);
        break;
      case '3':
        print("Exiting the system.");
        exit = true;
        break;
      default:
        print("Invalid choice, please try again.");
    }
  }

  // Close the database connection
  await conn.close();
}
