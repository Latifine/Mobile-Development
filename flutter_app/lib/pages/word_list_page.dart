import 'package:flutter/material.dart';
import 'package:app/apis/api_service.dart';
import 'package:app/models/word.dart';
import 'package:app/pages/language_guess_page.dart';

// StatefulWidget
class WordListPage extends StatefulWidget {

  // Widget constructor
  const WordListPage({Key? key}) : super(key: key);

  // Override createState() for widget
  @override
  State<StatefulWidget> createState() => _WordListPage();

}

// State
class _WordListPage extends State<WordListPage> {

  // Attributes
  List<Word> collectedWords = [];

  // Widgets
  ListView wordListWidget = ListView();

  // Override initState() for state to update collected words
  @override
  void initState() {
    super.initState();
    _fetchCollectedWords();
  }

  // Method - Updates collected words using the API
  void _fetchCollectedWords() {
    ApiService.fetchCollectedWords().then((result) {
      setState(() {
        collectedWords = result;
        wordListWidget = _wordListWidget();
      });
    });
  }

  // Widget - Updates wordListWidget
  ListView _wordListWidget() {
    return ListView.builder(
      itemCount: collectedWords.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2,
          child: Container(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(collectedWords[position].word),
                IconButton(
                  icon: const Icon(Icons.delete),
                  alignment: Alignment.centerRight,
                  onPressed: () {
                    // Delete word when pressed + reload page
                    ApiService.deleteWord(collectedWords[position]).then((result) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const WordListPage()),
                      );
                    });
                    // Update collected words
                    _fetchCollectedWords();
                  }
                )
              ]
            )
          ),
        );
      },
    );
  }

  // Widget - FloatingActionButton to navigate to LanguageGuessPage
  Widget? _floatingActionButton() {
    if (collectedWords.isEmpty) {
      return null;
    }
    return FloatingActionButton(
      onPressed: () {
        // Disable button if no words are collected
        if (collectedWords.isEmpty) {
          null;
        }
        // Navigate to LanguageGuessPage when pressed
        else {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LanguageGuessPage()),
          );
        }
      },
      child: const Text("Guess"),
    );
  }

  // Override build() for state
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Collected words'),
      ),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        child: wordListWidget
      ),
      floatingActionButton: _floatingActionButton()
    );
  }

}