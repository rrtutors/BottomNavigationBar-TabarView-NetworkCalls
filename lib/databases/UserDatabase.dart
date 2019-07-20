import 'dart:io';
import 'package:flutter_firestroe/models/user.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class UserDatabase{
  static String path;
  static final _databaseName = "mydb.db";
  static final _databaseVersion = 1;

  static final _table_user = 'user';


  UserDatabase._privateConstructor();
  static final UserDatabase instance = UserDatabase._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;


  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {

   await db.execute(
      "CREATE TABLE user(name TEXT, email TEXT, mobile TEXT,password TEXT)",
    );
  }
   static Future<String> getFileData() async {
     return getDatabasesPath().then((s){
       return path=s;
     });
   }

   Future<int> insertUser(User user) async{
     Database db = await instance.database;

   var users=await  db.rawQuery("select * from user where email = '"+user.email+"'");
     if(users.length>0)
       {
         return -1;
       }
       return  await db.insert("user",user.toUserMap(),conflictAlgorithm: ConflictAlgorithm.ignore
     );
   }

   Future<User> checkUserLogin(String email, String password) async
   {
     Database db = await instance.database;
     var res=await  db.rawQuery("select * from user where email = '$email' and password = '$password'");
     if(res.length>0)
       {
         List<dynamic> list =
         res.toList().map((c) => User.fromMap(c)).toList() ;

         print("Data "+list.toString());
         return list[0];
       }
       return null;
   }

   Future<int> getUser() async{
     Database db = await instance.database;
    var logins=await  db.rawQuery("select * from user");
    if(logins==null)
      return 0;
    return logins.length;

   }

  Future<User> getUserData() async{
    Database db = await instance.database;
    var res=await  db.rawQuery("select * from user");
    print("result user data $res");
    print("result user data "+res.toString());
    List<dynamic> list =
    res.toList().map((c) => User.fromMap(c)).toList() ;
    return list[0];

  }

  Future<int> deleteUser(String email) async{
    Database db = await instance.database;
   var logins= db.delete(_table_user, where: "email = ?", whereArgs: [email]);
      return logins;

  }
}