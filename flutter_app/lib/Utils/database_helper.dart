import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../Models/phone.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String phoneTable = 'phone_table';
  String colId = 'id';
  String colPhone = 'phone';
  String colAccessory = 'accessory';

  DatabaseHelper._createInstance();

  factory DatabaseHelper(){
    if (_database == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'phones.db';

    var phonesDatabase = await openDatabase(
        path, version: 1, onCreate: _createDb);
    return phonesDatabase;
  }

  void _createDb(Database db, int newVersion) async {
    await db.execute(
        ('CREATE TABLE $phoneTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colPhone TEXT, '
            '$colAccessory TEXT)'));
  }

  Future<List<Map<String, dynamic>>> getPhoneMapList() async {
    Database db = await this.database;
    var result = await db.query(phoneTable, orderBy: '$colPhone ASC');

    return result;
  }

  Future<int> insertPhone(Phone ph) async {
    Database db = await this.database;
    var result = await db.insert(phoneTable, ph.toMap());
    return result;
  }

  Future<int> updatePhone(Phone ph) async {
    var db = await this.database;
    var result = await db.update(
        phoneTable, ph.toMap(), where: '$colId=?', whereArgs: [ph.id]);
  }

  Future<int> deletePhone(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $phoneTable WHERE $colId=$id');
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery(
        'SELECT COUNT (*) from $phoneTable');

    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Phone>> getPhoneList() async {
    var phoneMapList = await getPhoneMapList();
    int count = phoneMapList.length;

    List<Phone> phoneList = List<Phone>();

    for (int i = 0; i < count; i++) {
      phoneList.add(Phone.fromMapObject(phoneMapList[i]));
    }

    return phoneList;
  }
}