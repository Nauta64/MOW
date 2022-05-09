import 'dart:convert';
List<Word> userFromJson(String str) => List<Word>.from(json.decode(str).map((x) => Word.fromJson(x)));
String userToJson(List<Word> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
class Word {
  Word({
    required this.word
  });
  String word;
  factory Word.fromJson(Map<String, dynamic> json) => Word(
    word: json["word"]

  );
  Map<String, dynamic> toJson() => {
    "word": word
  };
}