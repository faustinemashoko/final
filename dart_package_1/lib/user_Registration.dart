import 'package:crypto/crypto.dart';
import 'dart:convert';

import 'package:mysql1/mysql1.dart';

String hashPassword(String password) {
  var bytes = utf8.encode(password);
  var digest = sha256.convert(bytes);
  return digest.toString();
}

Future<void> registerUser(MySqlConnection conn, String username, String email, String password) async {
  String hashedPassword = hashPassword(password);

  var result = await conn.query(
      'INSERT INTO users (username, email, password) VALUES (?, ?, ?)',
      [username, email, hashedPassword]);

  print('Inserted row id=${result.insertId}');
}
