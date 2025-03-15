import 'package:flutter/foundation.dart';
import 'package:vcard_app/db/dbhelper.dart';

import '../models/contact_model.dart';

class ContactProvider extends ChangeNotifier {
  List<ContactModel> contactList = [];
  final db = DbHelper();

  Future<int> insertContact(ContactModel contactModel) async {
    final rowId = await db.insertContact(contactModel);
    contactModel.id = rowId;
    contactList.add(contactModel);
    notifyListeners();
    return rowId;
  }

  Future<void> getAllContacts() async {
    contactList = await db.getAllContacts();
    notifyListeners();
  }

  Future<void> getAllFavoriteContacts() async {
    contactList = await db.getAllFavoriteContacts();
    notifyListeners();
  }

  Future<ContactModel> getContactById(int id) => db.getContactById(id);

  Future<int> deleteContact(int id) {
    return db.deleteContact(id);
  }

  Future<void> updateContactField(ContactModel contactModel, String field) async {
    await db.updateContactField(contactModel.id, {field : contactModel.favorite ? 0 : 1});
    final index = contactList.indexOf(contactModel);
    contactList[index].favorite = !contactList[index].favorite;
    notifyListeners();
  }

}