import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zitate_app/api_key.dart';
import 'package:zitate_app/features/show_quotes/category.dart';
import 'package:zitate_app/features/show_quotes/quote.dart';
import 'package:zitate_app/shared/database_repository.dart';

const quoteUri = "https://api.api-ninjas.com/v1/quotes";

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key, required this.repository});

  final DatabaseRepository repository;

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  String quote = "";
  TextEditingController categoryController = TextEditingController();
  String actualUri = quoteUri;

  Future<String> getQuote(String uri) async {
    final response =
        await http.get(Uri.parse(uri), headers: {'X-Api-Key': myXApiKey});
    final jsonData = response.body;

    final jsonObject = jsonDecode(jsonData);

    final String quote = jsonObject[0]["quote"];

    return quote;
  }

  Future<String> getDataFromApi(String uri) async {
    final response =
        await http.get(Uri.parse(uri), headers: {'X-Api-Key': myXApiKey});
    return response.body;
  }

// [
//   {
//     "quote": "If we as a society are willing to have a preference for organic food, the farmer can pass on the savings.",
//     "author": "Robert Patterson",
//     "category": "food"
//   }
// ]

  Future<Quote> getQuoteObject() async {
    final jsonData = await getDataFromApi(quoteUri);
    final decodedJson = jsonDecode(jsonData);

    final quote = decodedJson[0]["quote"];
    final author = decodedJson[0]["author"];
    final category = decodedJson[0]["category"];

    final Quote quoteObject =
        Quote(quote: quote, author: author, category: category);

    return quoteObject;
  }

  @override
  void initState() {
    super.initState();
    getLastCategory();
    getLastQuote();
  }

  void getLastQuote() async {
    String savedQuote = await widget.repository.getSavedQuote();
    quote = savedQuote;
    setState(() {});
  }

  void getNewQuote() async {
    quote = await getQuote(actualUri);
    widget.repository.saveQuote(quote);
    setState(() {});
  }

  void getLastCategory() async {
    String savedCategory = await widget.repository.getSavedCategory();
    actualCategory = savedCategory;
    actualUri = savedCategory;
    setState(() {});
  }

  Quote actualQuoteObject =
      Quote(quote: 'quote', author: 'author', category: 'category');
  void getNewQuoteObject() async {
    Quote quoteObject = await getQuoteObject();
    actualQuoteObject = quoteObject;
  }

  String actualCategory = 'https://api.api-ninjas.com/v1/quotes';
  @override
  Widget build(BuildContext context) {
    Category allCategories = Category(
        name: 'Alle Kategorien', uri: 'https://api.api-ninjas.com/v1/quotes');
    Category anger = Category(
        name: 'Anger',
        uri: 'https://api.api-ninjas.com/v1/quotes?category=anger');
    Category beauty = Category(
        name: 'Beauty',
        uri: 'https://api.api-ninjas.com/v1/quotes?category=beauty');
    Category car = Category(
        name: 'Car', uri: 'https://api.api-ninjas.com/v1/quotes?category=car');
    Category computers = Category(
        name: 'Computers',
        uri: 'https://api.api-ninjas.com/v1/quotes?category=computers');
    Category food = Category(
        name: 'Food',
        uri: 'https://api.api-ninjas.com/v1/quotes?category=food');

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple.shade800,
          title: const Text("Zitate App"),
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownMenu(
                    initialSelection: actualCategory,
                    leadingIcon: IconButton(
                        onPressed: () {
                          actualUri = allCategories.uri;
                          categoryController.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.delete_forever)),
                    onSelected: (value) async {
                      actualCategory = value;
                      widget.repository.saveCategory(actualCategory);
                      setState(() {
                        actualUri = actualCategory;
                      });
                    },
                    controller: categoryController,
                    width: double.infinity,
                    label: const Text('Kategorie wählen'),
                    dropdownMenuEntries: <DropdownMenuEntry<dynamic>>[
                      DropdownMenuEntry(
                        value: allCategories.uri,
                        label: allCategories.name,
                      ),
                      DropdownMenuEntry(
                        value: anger.uri,
                        label: anger.name,
                      ),
                      DropdownMenuEntry(
                        value: beauty.uri,
                        label: beauty.name,
                      ),
                      DropdownMenuEntry(
                        value: car.uri,
                        label: car.name,
                      ),
                      DropdownMenuEntry(
                        value: computers.uri,
                        label: computers.name,
                      ),
                      DropdownMenuEntry(
                        value: food.uri,
                        label: food.name,
                      ),
                    ]),
                SizedBox(height: 240, child: Text(quote)),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                    onPressed: () {
                      getNewQuote();
                    },
                    child: const Text("Nächstes Zitat")),
                const SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                    onPressed: () {
                      widget.repository.deleteSavedQuote();
                      setState(() {
                        quote = 'Zitat gelöscht';
                      });
                    },
                    child: const Text("Zitat löschen")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
