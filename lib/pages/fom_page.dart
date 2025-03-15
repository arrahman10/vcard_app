import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vcard_app/models/contact_model.dart';
import 'package:vcard_app/pages/home_page.dart';
import 'package:vcard_app/providers/contact_provider.dart';
import 'package:vcard_app/utils/helpers.dart';

class FormPage extends StatefulWidget {
  static const String routeName = '/form';

  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final nameController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final designationController = TextEditingController();
  final companyController = TextEditingController();
  final addressController = TextEditingController();
  final websiteController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  late ContactModel contactModel;

  @override
  void didChangeDependencies() {
    contactModel = ModalRoute.of(context)!.settings.arguments as ContactModel;
    nameController.text = contactModel.name;
    emailController.text = contactModel.email;
    mobileController.text = contactModel.mobile;
    companyController.text = contactModel.company;
    designationController.text = contactModel.designation;
    addressController.text = contactModel.address;
    websiteController.text = contactModel.website;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Contact'),
        actions: [
          IconButton(
            onPressed: _saveContact,
            icon: const Icon(Icons.save),
          )
        ],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person),
                  labelText: 'Contact Name(required)',
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  if (value.length > 20) {
                    return 'Name should not be more than 30 chars long';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                keyboardType: TextInputType.phone,
                controller: mobileController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.call),
                  labelText: 'Mobile Number(required)',
                  filled: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field must not be empty';
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  labelText: 'Email Address',
                  filled: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                controller: companyController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.label),
                  labelText: 'Company Name',
                  filled: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                controller: designationController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.label),
                  labelText: 'Designation',
                  filled: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                controller: addressController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.location_city),
                  labelText: 'Street Address',
                  filled: true,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: TextFormField(
                keyboardType: TextInputType.url,
                controller: websiteController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.web),
                  labelText: 'Website',
                  filled: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveContact() async {
    if (formKey.currentState!.validate()) {
      contactModel.name = nameController.text;
      contactModel.mobile = mobileController.text;
      contactModel.email = emailController.text;
      contactModel.company = companyController.text;
      contactModel.designation = designationController.text;
      contactModel.address = addressController.text;
      contactModel.website = websiteController.text;

      Provider.of<ContactProvider>(context, listen: false)
          .insertContact(contactModel)
          .then((rowId) {
        if (rowId > 0) {
          showMsg(context, 'Saved');
          Navigator.popUntil(context, ModalRoute.withName(HomePage.routeName));
        }
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    designationController.dispose();
    companyController.dispose();
    addressController.dispose();
    websiteController.dispose();
    super.dispose();
  }
}
