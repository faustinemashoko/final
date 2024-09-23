import 'package:mysql1/mysql1.dart';

Future<MySqlConnection> openConnection() async {
  var settings = ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'root',  // replace with your MySQL username
    db: 'credentials_db',
    password: '12345',  // replace with your MySQL password
  );
  return await MySqlConnection.connect(settings);
}
