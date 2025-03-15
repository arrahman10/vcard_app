import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vcard_app/models/contact_model.dart';
import 'package:vcard_app/pages/contact_details_page.dart';
import 'package:vcard_app/pages/fom_page.dart';
import 'package:vcard_app/pages/scan_page.dart';
import 'package:vcard_app/providers/contact_provider.dart';
import 'package:vcard_app/utils/helpers.dart';

class HomePage extends StatefulWidget {
  static const String routeName = '/';
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selectedIndex = 0;
  bool isFirst = true;
  @override
  void didChangeDependencies() {
    if(isFirst) {
      Provider.of<ContactProvider>(context, listen: false).getAllContacts();
    }
    isFirst = false;
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact List'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, ScanPage.routeName);
        },
        shape: CircleBorder(),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.zero,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              selectedIndex = index;
            });
            _fetchData();
          },
          currentIndex: selectedIndex,
          backgroundColor: Colors.blue.shade100,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'All'
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite),
                label: 'Favorites'
            ),
          ],
        ),
      ),
      body: Consumer<ContactProvider>(
        builder: (context, provider, _) {
          if(provider.contactList.isEmpty) {
            return const Center(child: Text('Nothing to show'),);
          }
          return ListView.builder(
            itemCount: provider.contactList.length,
            itemBuilder: (context, index) {
              final contact = provider.contactList[index];
              return Dismissible(
                key: UniqueKey(),
                direction: DismissDirection.endToStart,
                background: Container(
                  padding: const EdgeInsets.only(right: 20),
                  alignment: FractionalOffset.centerRight,
                  color: Colors.red,
                  child: const Icon(Icons.delete, color: Colors.white,),
                ),
                confirmDismiss: _showConfirmationDialog,
                onDismissed: (direction) async {
                  await provider.deleteContact(contact.id);
                  showMsg(context, 'Deleted');
                },
                child: ListTile(
                  onTap: () => Navigator.pushNamed(context, ContactDetailsPage.routeName, arguments: contact.id),
                  title: Text(contact.name),
                  trailing: IconButton(
                    onPressed: () {
                      provider.updateContactField(contact, tblContactColFavorite);
                    },
                    icon: Icon(contact.favorite ? Icons.favorite : Icons.favorite_border),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<bool?> _showConfirmationDialog(DismissDirection direction) {
    return showDialog(context: context, builder: (context) => AlertDialog(
      title: const Text('Delete Contact'),
      content: const Text('Are you sure to delete this contact?'),
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: const Text('NO'),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: const Text('YES'),
        ),
      ],
    ));
  }

  void _fetchData() {
    switch(selectedIndex) {
      case 0:
        Provider.of<ContactProvider>(context, listen: false).getAllContacts();
        break;
      case 1:
        Provider.of<ContactProvider>(context, listen: false).getAllFavoriteContacts();
        break;
    }
  }
}
