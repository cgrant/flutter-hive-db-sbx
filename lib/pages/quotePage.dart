import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:quotes/boxes.dart';
import 'package:quotes/models/quoteModel.dart';
import 'package:quotes/widgets/quoteCard.dart';
import 'package:quotes/widgets/quoteDialog.dart';
import 'package:hive_flutter/hive_flutter.dart';

class QuotePage extends StatefulWidget {
  const QuotePage({Key? key}) : super(key: key);

  @override
  _QuotePageState createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  final box = Boxes();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quotes"),
      ),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => QuoteDialog(),
        ),
      ),
    );
  }

  Widget buildBody() {
    return ValueListenableBuilder<Box<Quote>>(
      valueListenable: Quote.quotesDB().listenable(),
      builder: (context, box, _) {
        final quotes = box.values.toList().cast<Quote>();

        return ListView.builder(
          itemCount: quotes.length,
          itemBuilder: (BuildContext context, int index) {
            return QuoteCard(quote: quotes[index]);
          },
        );
      },
    );
  }
}
