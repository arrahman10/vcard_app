import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/contact_model.dart';
class DbHelper {
  final String _createTableContact = '''create table $tableContact(
  $tblContactColId integer primary key autoincrement,
  $tblContactColName text,
  $tblContactColMobile text,
  $tblContactColLandLine text,
  $tblContactColEmail text,
  $tblContactColAddress text,
  $tblContactColCompany text,
  $tblContactColDesignation text,
  $tblContactColWebsite text,
  $tblContactColImage text,
  $tblContactColFavorite integer)''';
  Future<Database> _open() async {
    final root = await getDatabasesPath();
    final dbPath = p.join(root, 'contact.db');
    return openDatabase(dbPath, version: 2, onCreate: (db, version) {
      db.execute(_createTableContact);
    },onUpgrade: (db, oldVersion, newVersion) {
      if(oldVersion == 1) {
        db.execute('alter table $tableContact add column $tblContactColLandLine text default ""');
      }

    });
  }

  Future<int> insertContact(ContactModel contactModel) async {
    final db = await _open();
    return db.insert(tableContact, contactModel.toMap());
  }

  Future<List<ContactModel>> getAllContacts() async {
    final db = await _open();
    final mapList = await db.query(tableContact);
    return List.generate(mapList.length, (index) => ContactModel.fromMap(mapList[index]));
  }

  Future<List<ContactModel>> getAllFavoriteContacts() async {
    final db = await _open();
    final mapList = await db.query(tableContact, where: '$tblContactColFavorite = ?', whereArgs: [1]);
    return List.generate(mapList.length, (index) => ContactModel.fromMap(mapList[index]));
  }

  Future<ContactModel> getContactById(int id) async {
    final db = await _open();
    final mapList = await db.query(tableContact, where: '$tblContactColId = ?', whereArgs: [id]);
    return ContactModel.fromMap(mapList.first);
  }

  Future<int> deleteContact(int id) async {
    final db = await _open();
    return db.delete(tableContact, where: '$tblContactColId = ?', whereArgs: [id]);
  }

  Future<int> updateContactField(int id, Map<String, dynamic> map) async {
    final db = await _open();
    return db.update(tableContact, map, where: '$tblContactColId = ?', whereArgs: [id]);
  }
}