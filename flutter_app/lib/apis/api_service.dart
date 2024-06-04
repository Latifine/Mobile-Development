import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app/models/language.dart';
import 'package:app/models/word.dart';

class ApiService {

  // Server URL
  static String server = 'ef4d-178-51-160-245.ngrok-free.app';

  // GET - Retrieves the list of collected words
  static Future<List<Word>> fetchCollectedWords() async {

    // Retrieve URL
    var url = Uri.https(server, '/collected_words');

    // Retrieve response - GET
    final response = await http.get(
      url,
      headers: <String, String> {
        'ngrok-skip-browser-warning': 'true'
      }
    );

    // Return data if response successful
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((word) => Word.fromJSON(word)).toList();
    }
    // Return exception if response unsuccessful
    else {
      throw Exception('Failed to get collected words');
    }

  }

  // DELETE - Deletes a word from the list of collected words
  static Future<void> deleteWord(Word word) async {

    // Retrieve URL
    var url = Uri.https(server, '/collected_words/${word.id}');

    // Retrieve response - DELETE
    final http.Response response = await http.delete(
      url,
      headers: <String, String> {
        'ngrok-skip-browser-warning': 'true'
      },
    );

    // Return exception if response unsuccessful
    if (response.statusCode != 200) {
      throw Exception('Failed to reset word: ${word.word}');
    }

  }

  // GET - Retrieves the list of languages
  static Future<List<Language>> fetchLanguages() async {

    // Retrieve URL
    var url = Uri.https(server, '/languages');

    // Retrieve response - GET
    final response = await http.get(
      url,
      headers: <String, String> {
        'ngrok-skip-browser-warning': 'true'
      }
    );

    // Return data if response successful
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
        .map((language) => Language.fromJSON(language))
        .toList();
    }
    // Return exception if response unsuccessful
    else {
      throw Exception('Failed to get languages');
    }

  }

  // GET - Retrieves the list of collected words
  static Future<List<Word>> fetchCorrectWords() async {

    // Retrieve URL
    var url = Uri.https(server, '/correct_words');

    // Retrieve response - GET
    final response = await http.get(
      url,
      headers: <String, String> {
        'ngrok-skip-browser-warning': 'true'
      }
    );

    // Return data if response successful
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
        .map((word) => Word.fromJSON(word))
        .toList();
    }
    // Return exception if response unsuccessful
    else {
      throw Exception('Failed to get correct words');
    }

  }

  // POST - Saves a word to the list of correct words
  static Future<void> saveCorrectWord(Word word) async {

    // Retrieve URL
    var url = Uri.https(server, '/correct_words');

    // Retrieve response - POST
    final http.Response response = await http.post(
      url,
      headers: <String, String> {
        'Content-Type': 'application/json; charset=UTF-8',
        'ngrok-skip-browser-warning': 'true'
      },
      body: jsonEncode(word),
    );

    // Return exception if response unsuccessful
    if (response.statusCode != 201) {
      throw Exception('Failed to save correct word: ${word.word}');
    }

  }

  // Retrieves the current points
  static Future<int> fetchPoints() async {

    // Retrieve URL
    var url = Uri.https(server, '/points');

    // Retrieve response - GET
    final response = await http.get(
      url,
      headers: <String, String> {
        'ngrok-skip-browser-warning': 'true'
      }
    );

    // Return data if response successful
    if (response.statusCode == 200) {
      return json.decode(response.body)['points'];
    }
    // Return exception if response unsuccessful
    else {
      throw Exception('Failed to get points');
    }

  }

  // PUT - Sets the points
  static Future<void> setPoints(int points) async {

    // Retrieve URL
    var url = Uri.https(server, '/points');

    // Retrieve response - PUT
    final http.Response response = await http.put(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'ngrok-skip-browser-warning': 'true'
      },
      body: jsonEncode({'points': points}),
    );

    // Return exception if response unsuccessful
    if (response.statusCode != 200) {
      throw Exception('Failed to set points');
    }

  }

}
