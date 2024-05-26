import 'dart:io';

import 'package:gauthsy/config/config.dart';
import 'package:gauthsy/helpers/helpers.dart';
import 'package:gauthsy/kernel/container/container.dart';
import 'package:gauthsy/kernel/event_manager/event_manager.dart';
import 'package:gauthsy/views/boarding/boarding.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart' as UI;
import 'package:gauthsy/kernel/router/router.dart' as Kernel;

class FileManager {
  static Directory _extDir;

  static final List _directories = [
    "/${Config.appName}/tmp",
  ];

 static String get tmpDir {
   if(!initialized) _createDirectories();
   return       _extDir.parent.parent.parent.parent.path + _directories[0];
 }

  static EventManager get em => Container().get<EventManager>("em");
  static Kernel.Router get router => Container().get<Kernel.Router>("router");
 static bool initialized=false;
  static void init() async {
    em.attach("authenticated", (_) async {
      Container().set('fm', () => new FileManager());
      _createDirectories();
    });
  }

  static Future<bool> _createDirectories() async {
    try {
      if (!(await Permissions.canStorage())) return false;
      _extDir = await getExternalStorageDirectory();
      _directories.forEach((directoryName) async {
        final Directory directory = new Directory(
            _extDir.parent.parent.parent.parent.path + directoryName);
        final bool isThere = await directory.exists();
        if (!isThere)
          directory.create(recursive: true).then((Directory directory) {
            print('Directory ' + directory.path + ' Created');
          });
        initialized =true;
      });
      return true;
    } catch (_) {
      return false;
    }
  }

  File write(String data, String filename)  {
    print(data);
    try {
      final path = _extDir.parent.parent.parent.parent.path + "/documents";
      final file = File('$path/$filename');
      if (!file.existsSync()) file.createSync(recursive: true);
      file.writeAsStringSync(data);
      return file;
    } catch (e) {
      return null;
    }
  }
}
