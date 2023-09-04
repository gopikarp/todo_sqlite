import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  static final DBHelper dbHero = DBHelper._secretDBConstructor(); //----
  static Database? _database;

  DBHelper._secretDBConstructor(); //The _secretDBConstructor is a private named
   // constructor within the DBHelper class. Its main purpose is to ensure that 
   //only one instance of the DBHelper class is created


//use for 'get' access to the SQLite database
  Future<Database> get dataBase async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

//initializes the SQLite database
  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'my_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate:
          _createDatabase, //callback fun which is called when the database is created
    );
  }

  void _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE my_table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        description TEXT
      )
    ''');
  }

// Insert data into the database
  Future<int> insertDb(Map<String, dynamic> row) async {
    Database db = await dbHero.dataBase;
    return await db.insert('my_table', row);
  }

  Future<List<Map<String, dynamic>>> readDb() async {
    Database db = await dbHero.dataBase;
    return await db.query('my_table');
  }

  Future<int> updateDb(Map<String, dynamic> row) async {
    Database db = await dbHero.dataBase;
    int id = row['id'];
    return await db.update('my_table', row, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteDb(int id) async {
    Database db = await dbHero.dataBase;
    return await db.delete('my_table', where: 'id = ?', whereArgs: [id]);
  }
}
