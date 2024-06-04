class Word {

  // Attributes
  int id;
  String word;
  int languageId;
  String translation;

  // Constructor
  Word({
    required this.id,
    required this.word,
    required this.languageId,
    required this.translation
  });

  // JSON -> Word method
  factory Word.fromJSON(Map<String, dynamic> json) {
    return Word(
      id: json['id'],
      word: json['word'],
      languageId: json['language_id'],
      translation: json['translation']
    );
  }

  // Word -> JSON method
  Map<String, dynamic> toJson() => {
    'word': word,
    'language_id': languageId,
    'translation': translation
  };

}