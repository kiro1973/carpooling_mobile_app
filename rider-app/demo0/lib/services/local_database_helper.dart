import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class mydatabaseclass {
  Database? mydb;

  Future<Database?> mydbcheck() async {
    if (mydb == null) {
      mydb = await initiatedatabase();
      return mydb;
    } else {
      return mydb;
    }
  }

  int Version = 3;
  initiatedatabase() async {
    String databasedestination = await getDatabasesPath();
    String databasepath = join(databasedestination, 'mydatabase22.db');
    Database mydatabase1 = await openDatabase(
      databasepath,
      version: Version,
      onCreate: (db, version) {
        db.execute('''CREATE TABLE IF NOT EXISTS 'userProfile'(
      'ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      'username' TEXT NOT NULL,
      'email' TEXT NOT NULL,
      'phoneNumber' TEXT NOT NULL)
       ''');
        print("Database has been created");
      },
    );
    return mydatabase1;
  }

  checking() async {
    String databasedestination = await getDatabasesPath();
    String databasepath = join(databasedestination, 'mydatabase22.db');
    await databaseExists(databasepath) ? print("it exists") : print("hardluck");
  }

  reseting() async {
    String databasedestination = await getDatabasesPath();
    String databasepath = join(databasedestination, 'mydatabase22.db');
    await deleteDatabase(databasepath);
  }

  reading(sql) async {
    Database? somevariable = await mydbcheck();
    var response = somevariable!.rawQuery(sql);
    return response;
  }

  writing(sql) async {
  Database? somevariable = await mydbcheck();

    // Delete all entries in the table before inserting
    await somevariable!.delete('userProfile');

    // Perform rawInsert
    var response = await somevariable.rawInsert(sql);
    return response;
  }

  deleting(sql) async {
    Database? somevariable = await mydbcheck();
    var response = somevariable!.rawDelete(sql);
    return response;
  }

  updating(sql) async {
    Database? somevariable = await mydbcheck();
    var response = somevariable!.rawUpdate(sql);
    return response;
  }


Future<Map<String, dynamic>?> getUserProfile() async {
    Database? somevariable = await mydbcheck();

    // Fetch the single entry from the table
    List<Map<String, dynamic>> result = await somevariable!.query('userProfile');

    // If there's no entry, return null
    if (result.isEmpty) {
      return null;
    }

    // Return the first (and only) entry
    return result.first;
  }



}



/*import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabaseHelper {
  static const String dbName = 'local_database.db';
  static const String emailTableName = 'user_data';

  static Future<Database> initializeDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, dbName);

    return openDatabase(
      databasePath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE $emailTableName(id INTEGER PRIMARY KEY, email TEXT)',
        );
      },
    );
  }

  static Future<void> saveEmail(String email) async {
    final Database db = await initializeDatabase();
    await db.insert(emailTableName, {'email': email}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<String?> getEmail() async {
    final Database db = await initializeDatabase();
    final List<Map<String, dynamic>> maps = await db.query(emailTableName);

    if (maps.isNotEmpty) {
      return maps.first['email'];
    }

    return null;
  }

  // ... other methods for storing and retrieving ride data




  
}
*/