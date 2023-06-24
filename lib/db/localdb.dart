
//not used _

// import 'dart:io';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// class localdb {
//   static late List themetable = [], logintable;
//   getpath() async {
//     var t, path;
//     t = Platform.isAndroid ? await getDatabasesPath() : './';
//     path = join(t, 'localmzdb.db');
//     return path;
//   }

//   CreateLoginTable() async {
//     Database db;
//     var path = await getpath();
//     if (Platform.isAndroid) {
//       db = await openDatabase(path);
//     } else {
//       sqfliteFfiInit();
//       var databaseFactory = databaseFactoryFfi;
//       db = await databaseFactory.openDatabase(path);
//     }
//     await db.execute(
//         'create table if not exists logintable(id INTEGER UNIQUE,name TEXT,password TEXT)');
//     var table = await db.query('logintable;');
//     await db.close();
//     return table;
//   }

//   CreateThemeTable() async {
//     Database db;
//     var path = await getpath();
//     if (Platform.isAndroid) {
//       db = await openDatabase(path);
//     } else {
//       sqfliteFfiInit();
//       var databaseFactory = databaseFactoryFfi;
//       db = await databaseFactory.openDatabase(path);
//     }
//     await db.execute(
//         'create table if not exists themetable(id INTEGER UNIQUE,mode TEXT)');
//     var table = await db.query('themetable;');
//     await db.close();
//     return table;
//   }

//   setThemeTable() async {
//     Database db;
//     var path = await getpath();
//     if (Platform.isAndroid) {
//       db = await openDatabase(path);
//     } else {
//       sqfliteFfiInit();
//       var databaseFactory = databaseFactoryFfi;
//       db = await databaseFactory.openDatabase(path);
//     }
//     try {
//       await db.insert('themetable', {'id': 0, 'mode': 'light'});
//     } catch (e) {}
//     var table = await db.query('themetable;');
//     await db.close();
//     return table;
//   }

//   updateThemeTable({mode}) async {
//     Database db;
//     var path = await getpath();
//     if (Platform.isAndroid) {
//       db = await openDatabase(path);
//     } else {
//       sqfliteFfiInit();
//       var databaseFactory = databaseFactoryFfi;
//       db = await databaseFactory.openDatabase(path);
//     }
//     try {
//       await db.update('themetable', {'id': 0, 'mode': mode}, where: 'id=0');
//     } catch (e) {}
//     var table = await db.query('themetable;');
//     await db.close();
//     return table;
//   }
// }
