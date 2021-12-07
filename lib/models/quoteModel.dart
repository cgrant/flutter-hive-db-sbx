import 'package:hive/hive.dart';
//import 'package:uuid/uuid.dart';
part 'quoteModel.g.dart';

@HiveType(typeId: 0)
class Quote {
  @HiveField(0)
  late String? quoteid; //uuid.v1(),

  @HiveField(1)
  late String? text;

  @HiveField(2)
  late String? author;

  Quote({
    this.quoteid,
    this.author,
    this.text,
  }) {
    if (quoteid != null) {
      Quote quote = quotesDB().get(quoteid)!;
      this.author = quote.author;
      this.text = quote.text;
    }
  }

  static Box<Quote> quotesDB() => Hive.box<Quote>('quotesdb');

  save() {
    quotesDB().put(this.quoteid, this);
  }

  delete(String quoteId) {
    quotesDB().delete(quoteId);
  }
}
