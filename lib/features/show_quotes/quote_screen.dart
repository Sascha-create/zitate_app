import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:zitate_app/api_key.dart';



const quoteUri = "https://api.api-ninjas.com/v1/quotes";

Future<String> getDataFromApi(String uri) async {
  final response =
      await http.get(Uri.parse(uri), headers: {'X-Api-Key': myXApiKey});

  return response.body;
}

Future<String> getQuote() async {
  final jsonString = await getDataFromApi(quoteUri);

  final jsonObject = jsonDecode(jsonString);

  final String quote = jsonObject[0]["quote"];

  return quote;
}

class QuoteScreen extends StatefulWidget {
  const QuoteScreen({super.key});

  @override
  State<QuoteScreen> createState() => _QuoteScreenState();
}

class _QuoteScreenState extends State<QuoteScreen> {
  String quote = "Noch kein Zitat geladen";

  void getNewQuote() async {
    quote = await getQuote();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
                SizedBox(height: 240, child: Text(quote)),
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                    onPressed: () {
                      getNewQuote();
                    },
                    child: const Text("Nächstes Zitat"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
