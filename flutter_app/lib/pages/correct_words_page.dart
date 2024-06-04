import 'package:flutter/material.dart';
import 'package:app/apis/api_service.dart';
import 'package:app/models/language.dart';
import 'package:app/models/word.dart';

// StatefulWidget
class CorrectWordListPage extends StatefulWidget {
  
  // Widget constructor
  const CorrectWordListPage({Key? key}) : super(key: key);

  // Override createState() for widget
  @override
  State<StatefulWidget> createState() => _CorrectWordListPage();

}

// State
class _CorrectWordListPage extends State<CorrectWordListPage> {

  // Attributes
  List<Language> languages = [];
  List<Word> correctWords = [];

  // Override initState() for state to update languages and correct words
  @override
  void initState() {
    super.initState();
    _fetchLanguages();
    _fetchCorrectWords();
  }

  // Method - Updates correct words using the API
  void _fetchCorrectWords() {
    ApiService.fetchCorrectWords().then((result) {
      setState(() {
        correctWords = result;
      });
    });
  }

  // Method - Updates languages using the API
  void _fetchLanguages() {
    ApiService.fetchLanguages().then((result) {
      setState(() {
        languages = result;
      });
    });
  }

  // Widget - Returns the list of correctly guessed words
  Widget _correctWords() {
    // Return empty widget if no words are collected
    if (correctWords.isEmpty) {
      return const Text('');
    }
    // Return ListView widget if at least one word was collected
    return ListView.builder(
      itemCount: correctWords.length,
      itemBuilder: (BuildContext context, int position) {
        // Ensure languages is not empty
        if (languages.isEmpty) {
          return const Text('');
        }
        return Card(
          color: Colors.white,
          elevation: 2,
          child: Container(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(correctWords[position].word, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("Language: ${languages.firstWhere((element) => element.id == correctWords[position].languageId).name}", style: const TextStyle(fontSize: 14)),
                Text("Translation: ${correctWords[position].translation}", style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        );
      },
    );
  }

  // Override build() for state
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Correctly guessed words'),
      ),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        child: _correctWords()
      ),
    );
  }

}
