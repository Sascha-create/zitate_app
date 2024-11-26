import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zitate_app/api_key.dart';
import 'package:zitate_app/features/show_quotes/category.dart';
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

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    Category anger = Category(
        name: 'Anger',
        uri: 'https://api.api-ninjas.com/v1/quotes?category=anger');
    Category beauty = Category(
        name: 'Beauty',
        uri: 'https://api.api-ninjas.com/v1/quotes?category=beauty');
    Category car = Category(
        name: 'Beauty',
        uri: 'https://api.api-ninjas.com/v1/quotes?category=car');
    Category computers = Category(
        name: 'Beauty',
        uri: 'https://api.api-ninjas.com/v1/quotes?category=computers');
    Category food = Category(
        name: 'Beauty',
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
                    onSelected: (value) {
                      setState(() {
                        actualUri = value;
                      });
                    },
                    controller: categoryController,
                    width: double.infinity,
                    label: const Text('Kategorien'),
                    dropdownMenuEntries: <DropdownMenuEntry<dynamic>>[
                      DropdownMenuEntry(
                        value: anger.uri,
                        label: 'Anger',
                      ),
                      DropdownMenuEntry(
                        value: beauty.uri,
                        label: 'Beauty',
                      ),
                      DropdownMenuEntry(
                        value: car.uri,
                        label: 'Car',
                      ),
                      DropdownMenuEntry(
                        value: computers.uri,
                        label: 'Computers',
                      ),
                      DropdownMenuEntry(
                        value: food.uri,
                        label: 'Food',
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
