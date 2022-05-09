import 'dart:convert';
List<Synonym> userFromJson(String str) => List<Synonym>.from(json.decode(str).map((x) => Synonym.fromJson(x)));
String userToJson(List<Synonym> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
class Synonym {
  Synonym({
    required this.word,
    required this.syn
  });
  String word;
  List<String> syn;
  factory Synonym.fromJson(Map<String, dynamic> json) => Synonym(
      word: json["word"],
      syn: json["syn"]

  );
  Map<String, dynamic> toJson() => {
    "word": word,
    "syn": syn
  };
}