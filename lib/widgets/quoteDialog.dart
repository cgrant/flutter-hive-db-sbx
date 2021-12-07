import 'package:flutter/material.dart';
import 'package:quotes/models/quoteModel.dart';
import 'package:uuid/uuid.dart';

class QuoteDialog extends StatefulWidget {
  const QuoteDialog({
    Key? key,
    this.quoteId,
  }) : super(key: key);

  final String? quoteId;

  @override
  _QuoteDialogState createState() => _QuoteDialogState();
}

class _QuoteDialogState extends State<QuoteDialog> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final authorController = TextEditingController();
  Quote quote = Quote();

  @override
  void initState() {
    if (widget.quoteId != null) {
      final quote = Quote(quoteid: widget.quoteId);

      nameController.text = quote.text!;
      authorController.text = quote.author!;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Hello"),

      // Content Here
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8),
              // Name
              buildName(),
              SizedBox(height: 8),
              buildAmount(),
              SizedBox(height: 8),
            ],
          ),
        ),
      ),

      actions: [
        buildDeleteButton(context),
        buildCancelButton(context),
        buildAddButton(context),
      ],
    );
  }

  Widget buildName() => TextFormField(
        controller: nameController,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Name',
        ),
        validator: (name) =>
            name != null && name.isEmpty ? 'Enter a name' : null,
      );

  Widget buildAmount() => TextFormField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: 'Enter Author',
        ),
        keyboardType: TextInputType.number,
        validator: (author) =>
            author != null && author.isEmpty ? 'Enter an author' : null,
        controller: authorController,
      );

  // Create the cancel button
  Widget buildCancelButton(BuildContext context) => TextButton(
        child: Text('Cancel'),
        onPressed: () => Navigator.of(context).pop(),
      );

  Widget buildAddButton(BuildContext context) {
    bool isEditing = widget.quoteId != null;

    final text = isEditing ? 'Save' : 'Add';

    return TextButton(
      child: Text(text),
      onPressed: () async {
        final isValid = formKey.currentState!.validate();

        if (isValid) {
          final text = nameController.text;
          final author = authorController.text;

          Quote quote = this.quote;

          if (!isEditing) {
            quote.quoteid = Uuid().v1();
          } else {
            quote.quoteid = widget.quoteId;
          }

          quote
            ..author = author
            ..text = text;

          quote.save();
        }

        Navigator.of(context).pop();
      },
    );
  }

  buildDeleteButton(BuildContext context) {
    return TextButton(
      child: Text("Delete"),
      onPressed: () async {
        if (widget.quoteId != null) {
          quote.delete(widget.quoteId!);

          Navigator.of(context).pop();
        }
      },
    );
  }
}
