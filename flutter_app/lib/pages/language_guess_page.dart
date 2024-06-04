import 'package:flutter/material.dart';
import 'package:app/apis/api_service.dart';
import 'package:app/models/language.dart';
import 'package:app/models/word.dart';
import 'package:app/pages/home.dart';

// StatefulWidget
class LanguageGuessPage extends StatefulWidget {

  // Widget constructor
  const LanguageGuessPage({Key? key}) : super(key: key);

  // Override createState() for widget
  @override
  State<StatefulWidget> createState() => _LanguageGuessPage();

}

// State
class _LanguageGuessPage extends State<LanguageGuessPage> {

  // Attributes
  List<Word> collectedWords = [];
  List<Language> languages = [];
  List<Word> correctWords = [];
  int points = 0;
  Language? selectedLanguage;

  // Override initState() for state to update languages, collected words, correct words and points
  @override
  void initState() {
    super.initState();
    _fetchCollectedWords();
    _fetchLanguages();
    _fetchCorrectWords();
    _fetchPoints();
  }

  // Method - Updates collected words using the API
  void _fetchCollectedWords() async {
    ApiService.fetchCollectedWords().then((result) {
      setState(() {
        collectedWords = result;
      });
    });
  }

  // Method - Updates languages using the API
  void _fetchLanguages() {
    ApiService.fetchLanguages().then((result) {
      setState(() {
        languages = result;
        selectedLanguage = languages[0];
      });
    });
  }

  // Method - Updates correct words using the API
  void _fetchCorrectWords() async {
    ApiService.fetchCorrectWords().then((result) {
      setState(() {
        correctWords = result;
      });
    });
  }

  // Method - Updates points using the API
  void _fetchPoints() async {
    await ApiService.fetchPoints().then((result) {
      setState(() {
        points = result;
      });
    });
  }

  // Method - Sets selected language
  void _onLanguageSelected(Language? language) {
    if (language == null) {
      return;
    }
    setState(() {
      selectedLanguage = language;
    });
  }

  // Method - Saves and deletes all collected words
  void _saveAndDeleteWords() async {
    for (Word word in collectedWords) {
      // Save word if it is not yet guessed
      {
        bool wordNotGuessed = true;
        for (Word correctWord in correctWords) {
          if (correctWord.word == word.word) {
            wordNotGuessed = false;
          }
        }
        if (wordNotGuessed) {
          await ApiService.saveCorrectWord(word);
        }
      }
      // Delete word if it is not yet deleted
      await ApiService.deleteWord(word);
    }
  }

  // Method - Checks if all words match the given language
  bool allWordsMatch(Language language) {

    // Check if any collected word is not of the same language
    for (Word word in collectedWords) {
      if (word.languageId != language.id) {
        return false;
      }
    }

    // Return true
    return true;

  }

  // Method - Guesses language and shows a pop-up with the result
  void _onLanguageGuessed(Language? language) {

    // Guard clause - Ensure language is chosen
    if (language == null) {
      return;
    }

    // Initiate pop-up text
    String popupTitleText = "No words collected!";
    String popupText = "You have not collected any words yet!";

    // Adjust pop-up text if the list of words is not empty
    if (collectedWords.isNotEmpty) {
      // Adjust pop-up title
      popupTitleText = "You guessed ${selectedLanguage?.name}!";
      // Adjust pop-up and add points if the list 
      if (allWordsMatch(language)) {
        // Initiate added points
        int addedPoints = 1;
        // Increased points for multiple words collected
        if (collectedWords.length > 1) {
          addedPoints = collectedWords.length * 2 - 1;
        }
        // Increased points for many words collected
        if (collectedWords.length > 3) {
          addedPoints += collectedWords.length;
        }
        popupText = "Correct! All words are of this language!\n+${addedPoints.toString()} points!";
        // Add points
        ApiService.setPoints(points + addedPoints);
      }
      else {
        popupText = "Not all words are ${selectedLanguage?.name}! Try again!";
      }
    }

    // Show pop-up on screen
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(popupTitleText),
          content: Text(popupText),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // Delete all words if they match
                if (allWordsMatch(language)) {
                  _saveAndDeleteWords();
                }
                // Navigate to homepage after guessing
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                  (route) => false
                );
              },
            ),
          ],
        );
      },
    );
  }

  // Override build() for state
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose a language'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Text("Guess"),
        onPressed: () {
          _onLanguageGuessed(selectedLanguage);
        },
      ),
      body: Container(
        padding: const EdgeInsets.all(5.0),
        child:
          DropdownButton<Language>(
            isExpanded: true,
            items: languages.map((Language language) {
              return DropdownMenuItem<Language>(
                value: language,
                child: Text(language.name)
              );
            }).toList(),
            value: selectedLanguage,
            onChanged: (value) {
              _onLanguageSelected(value);
            },
          )
      ),
    );
  }

}