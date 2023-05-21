import 'package:hive_flutter/hive_flutter.dart';

class HiveDB {

  //reference
  final bx = Hive.box('mybox');

  //profilPic path
  String imagepath = '';

  //Variables
  Map<dynamic, dynamic> usermap = {};

  //INIT DATA
  void InitUserMapData() {
    usermap = {};
  }

  //LOAD DATA
  void LoadUserMapData() {
    usermap = bx.get("usermap");
  }

  //UPDATE DATA
  void UpdateUserMapData() {
    bx.put("usermap", usermap);
  }

  //INIT DATA
  void InitPath() {
    imagepath = '';
  }

  //LOAD DATA
  void LoadPath() {
    imagepath = bx.get("path");
  }

  //UPDATE DATA
  void UpdatePath() {
    bx.put("path", imagepath);
  }
}