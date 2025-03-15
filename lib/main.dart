import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vcard_app/pages/contact_details_page.dart';
import 'package:vcard_app/pages/fom_page.dart';
import 'package:vcard_app/pages/home_page.dart';
import 'package:vcard_app/pages/scan_page.dart';
import 'package:vcard_app/providers/contact_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => ContactProvider(),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: HomePage.routeName,
      routes: {
        HomePage.routeName : (context) => const HomePage(),
        ScanPage.routeName : (context) => const ScanPage(),
        FormPage.routeName : (context) => const FormPage(),
        ContactDetailsPage.routeName : (context) => const ContactDetailsPage(),
      },
    );
  }
}


