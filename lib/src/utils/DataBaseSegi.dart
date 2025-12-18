import 'package:sqflite/sqflite.dart';
import 'package:segimutiplataform/src/models/User.dart';
import 'package:path/path.dart';



class DatabaseHelper{
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async{
    if(_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;

  }

  Future<Database> _initDatabase() async {
    String path = join (await getDatabasesPath(), 'segi_session.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version){
        return db.execute(
          "CREATE TABLE session(id TEXT PRIMARY KEY, name TEXT, lastname TEXT, email TEXT)",
        );
      }
    );
  }

  Future<void> saveSession(User user) async{
    final db = await database;
    await db.insert(
        'session',
      {
        'id': user.id,
        'name': user.name,
        'lastname': user.lastname,
        'email': user.email,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,

    );
  }

  Future<Map<String, dynamic>?> getSession()async {
    final db = await database;
    List<Map<String, dynamic>> maps = await db.query('session');
    if(maps.isNotEmpty) return maps.first;
    return null;
  }
  Future<void>  deleteSession()async{
    final db = await database;
    await db.delete('session');


  }

}