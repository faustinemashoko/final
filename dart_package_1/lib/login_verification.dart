import 'package:dart_package_1/main.dart';
import 'package:mysql1/mysql1.dart';

Future<bool> loginUser(MySqlConnection conn, String username, String password) async {
  String hashedPassword = hashPassword(password);

  var results = await conn.query(
      'SELECT * FROM users WHERE username = ? AND password = ?',
      [username, hashedPassword]);

  return results.isNotEmpty;
}
