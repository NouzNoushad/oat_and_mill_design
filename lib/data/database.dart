import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MyDb {
  Database? db;

  Future open() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'carts.db');
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE carts(
            id integer primary key autoIncrement,
            image varchar(255) not null,
            title varchar(255) not null,
            subTitle varchar(255) not null,
            price int not null
          );
        ''');
    });
  }
}
