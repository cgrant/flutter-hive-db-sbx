# Hive DB

This example explores the use of [HiveDB](https://docs.hivedb.dev/) for local storage in dart & flutter


## Dependencies

HiveDB requires four entries in your `pubspec.yaml`. Two belong under the standard dependencies section and another 2 are required in the dev section. These last two are used to generate the adapters from the command line

```
dependencies:
  flutter:
    sdk: flutter
  
  # hive database
  hive: ^2.0.3
  hive_flutter: ^1.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter

  # hive database
  build_runner: ^1.12.2
  hive_generator: ^1.0.1
```

## Initialize HiveDB

In both flutter and Dart you need to initialize the database and register adapters. 

In the dart example the entry looks like the following

`example.dart`
```
void main() async {
  Hive.init('./'); 

  // Register the Adapter
  Hive.registerAdapter(UserAdapter());
  // Open the box (Database) 
  var box = await Hive.openBox<User>('userBox');
  
}
```

in the flutter example it looks like this

`main.dart`
```
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register the Adapter
  Hive.registerAdapter(QuoteAdapter());
  // Open the box (Database) 
  await Hive.openBox<Quote>('quotesdb');

  runApp(const MyApp());
}
```

## TypeAdapter Generation

Hive requires a TypeAdapter to serialize the objects into binary formats. A tool is provided that will generate this Adapter for you. You included it in the `pubspec.yaml` earlier. 

In order work correctly you need to annontate your object at the class and field levels. The system uses a simple numeric model to map the classes and fields so its critical that each class uses it's own id and each field is also unique. Furthermore do not reuse one id on another field later. Instead just provide a new id for the new field. 

Finnally the model should reference the generated TypeAdapter, in this case `quoteModel.g.dart`. This will produce an error until you actually generate the adapter and thats fine. 

```
import 'package:hive/hive.dart';
part 'quoteModel.g.dart';

@HiveType(typeId: 0)
class Quote {
  @HiveField(0)
  late String? quoteid; 

  @HiveField(1)
  late String? text;

  @HiveField(2)
  late String? author;
}

```

To generate the adapter run `flutter pub run build_runner build` from the command line in the root of the project. 

## Reading and writing objects

Hive stores data in a simple Key:Value model. If no key is provided hive will simply use an auto incrementing index id for the key. It's recomended that you provide your own key. 

A simple example

`example.dart
```
void main() async {
  Hive.init('./'); 
  Hive.registerAdapter(UserAdapter());

  var box = await Hive.openBox<User>('userBox');

  box.put('keydavid', User('David'));
  box.put('keysandy', User('Sandy'));

  print(box.keys);
}
```

## Refreshing Views

To automatically update views anytime data is changed in the DB use `ValueListenableBuilder` to wacth the data

`quotePage.dart`
```
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
```


## Design Pattern in this example

This example implements a design pattern where the app generates a key rather than the DB. This pattern follows one I've used frequently with Firebase Firestore and should allow for 
consistent mental models and simplify translation between persistence tiers. 
