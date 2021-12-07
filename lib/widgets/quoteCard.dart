import 'package:flutter/material.dart';
import 'package:quotes/models/quoteModel.dart';
import 'package:quotes/widgets/quoteDialog.dart';

import '../boxes.dart';

class QuoteCard extends StatelessWidget {
  const QuoteCard({
    Key? key,
    required this.quote,
  }) : super(key: key);

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => showDialog(
          context: context,
          builder: (context) => QuoteDialog(
            quoteId: quote.quoteid,
          ),
        ),
        child: Container(
          width: 100.0,
          height: 100.0,
          child: Row(
            children: [
              Text(this.quote.text!),
              Text(this.quote.author!),
            ],
          ),
        ),
      ),
    );
  }
}
