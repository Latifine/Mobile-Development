class Language {

  // Attributes
  int id;
  String name;

  // Constructor
  Language({
    required this.id,
    required this.name
  });

  // JSON -> Language method
  factory Language.fromJSON(Map<String, dynamic> json) {
    return Language(
      id: json['id'],
      name: json['name']
    );
  }

  // Language -> JSON method
  Map<String, dynamic> toJson() => {
    'name': name
  };

}