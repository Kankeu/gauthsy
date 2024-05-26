library database;

import 'dart:io';


import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as Sqflite;
import 'package:gauthsy/kernel/container/container.dart';
import 'package:gauthsy/kernel/event_manager/event_manager.dart';

part 'migrations.dart';


class Database {
  static Future init() async {
    final em = Container().get<EventManager>("em");

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ntunsige.db");
    // onCreate method is call if the database doesn't exist
   // await Sqflite.deleteDatabase(path);
    final bool exists = await Sqflite.databaseExists(path);
    var pdo = await Sqflite.openDatabase(path, version: 3,
        onCreate: (Sqflite.Database pdo, _) async {
      Container().set("pdo", () => pdo);
      await Migrations.make(pdo);
      em.signal("authenticate");
    });
    Container().set("pdo", () => pdo);
    if (exists) em.signal("authenticate");
  }

  static Future reset() async {
    var pdo = Container().get<Sqflite.Database>("pdo");

    await pdo.execute("DELETE FROM users");
    print("Users table truncated");
    await pdo.execute("DELETE FROM tokens");
    print("Tokens table truncated");
  }
}
