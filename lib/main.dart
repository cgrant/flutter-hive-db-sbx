import 'package:flutter/material.dart';

import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quotes/models/quoteModel.dart';
import 'package:quotes/pages/quotePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Prepare the QuoteDB
  Hive.registerAdapter(QuoteAdapter());
  await Hive.openBox<Quote>('quotesdb');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuotePage(),
    );
  }
}
