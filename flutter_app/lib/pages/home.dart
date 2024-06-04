import 'package:flutter/material.dart';
import 'package:app/apis/api_service.dart';
import 'package:app/models/word.dart';
import 'package:app/pages/correct_words_page.dart';
import 'package:app/pages/language_guess_page.dart';
import 'package:app/pages/word_list_page.dart';

// StatefulWidget
class HomePage extends StatefulWidget {

  // Widget constructor
  const HomePage({Key? key}) : super(key: key);

  // Override createState() for widget
  @override
  State<StatefulWidget> createState() => _HomePage();

}

// State
class _HomePage extends State<HomePage> {

  // Attributes
  int points = 0;
  List<Word> collectedWords = [];

  // Override initState() for state to update points and collected words
  @override
  void initState() {
    super.initState();
    _fetchPoints();
    _fetchCollectedWords();
  }

  // Method - Updates points using the API
  void _fetchPoints() {
    ApiService.fetchPoints().then((result) {
      setState(() {
        points = result;
      });
    });
  }

  // Method - Updates collected words using the API
  Future<void> _fetchCollectedWords() async {
    ApiService.fetchCollectedWords().then((result) {
      setState(() {
        collectedWords = result;
      });
    });
  }

  // Override build() for state
  @override
  Widget build(BuildContext context) {

    // Method - Triggered when bottom navigation bar item is pressed
    void onBottomNavigationBarItemPressed(int index) async {

      // Method - Navigates to page based on the given widget
      Future<void> navigateToPage(Widget page) async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      }

      // Update collected words
      await _fetchCollectedWords().then((_) {
        // Navigate to page depending on index
        switch (index) {
          case 0:
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
              (route) => false
            );
            break;
          case 1:
            navigateToPage(const WordListPage());
            break;
          case 2:
            // Show popup if no words were collected
            if (collectedWords.isEmpty) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('No words collected!'),
                    content: const Text('You have not collected any words yet!'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  );
                }
              );
            }
            // Navigate to LanguageGuessPage if at least one word has been collected
            else {
              navigateToPage(const LanguageGuessPage());
            }
            break;
          case 3:
            navigateToPage(const CorrectWordListPage());
            break;
        }
      });

    }

    // Page layout
    return Scaffold(
      appBar: AppBar(
        title: const Text('The Language Game'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Welcome to The Language Game!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            Text(
              'Points: $points',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.orange[50],
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey[850],
        selectedItemColor: Colors.orange[800],
        currentIndex: 0,
        onTap: onBottomNavigationBarItemPressed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Collected words",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.language),
            label: "Guess language",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.check),
            label: "Correctly guessed words",
          ),
        ],
      ),
    );

  }

}
