import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  late Database _database;
  bool _isDatabaseInitialized = false;

  Future<void> initializeDatabase() async {
    if (!_isDatabaseInitialized) {
      _database = await openDatabase(
        join(await getDatabasesPath(), 'fitness_data.db'),
        onCreate: (db, version) {
          _createTables(db);
        },
        version: 1,
      );
      _isDatabaseInitialized = true;
    }
  }

  void _createTables(Database db) {
    db.execute(
      'CREATE TABLE activities(id INTEGER PRIMARY KEY, activity TEXT, duration INTEGER)',
    );

    db.execute(
      'CREATE TABLE users(id INTEGER PRIMARY KEY, email TEXT, password TEXT)',
    );
  }

  Future<void> insertActivity(String activity, int duration) async {
    await initializeDatabase();
    final localDB= await _database;
    await localDB.insert(
      'activities',
      {'activity': activity, 'duration': duration},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> getActivities() async {
    await initializeDatabase();
    final localDB =await _database;
    return await localDB.query('activities');
  }

  Future<void> deleteActivity(int id) async {
    await initializeDatabase();
    final localDB= await _database;
    await localDB.delete(
      'activities',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> insertUsers(String email, String password) async {
    await initializeDatabase();
    final localDB = await _database;

    await localDB.insert(
      'users',
      {'email': email, 'password': password},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  

  Future<Map<String, dynamic>?> getUser(String email, String password) async {
  await initializeDatabase();
  final localDB = await _database;
  List<Map<String, dynamic>> users = await localDB.query(
    'users',
    where: 'email = ? And password =?',
    whereArgs: [email, password],
    limit: 1,
  );
  if (users.isNotEmpty) {
    return users.first;
  }
  return null;
}

}
  

