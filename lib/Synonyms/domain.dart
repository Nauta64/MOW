import 'package:MindOfWords/Synonyms/Models/Synonym.dart';

class SynLetter {
  int index;
  String value;


  SynLetter(this.index, this.value);

  SynLetter.fromJson(Map<String, dynamic> json)
      : index = json['index'],
        value = json['value'];


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['index'] = index;
    data['value'] = value;
    return data;
  }
}


class SynContext {
  List<List<SynLetter>> keys;
  Synonym answer;
  String guess;
  List<SynLetter> attempt;
  int aciertos;
  String message;
  int currentIndex;
  DateTime? lastPlayed;

  SynContext(this.keys, this.answer, this.guess, this.attempt,
      this.aciertos, this.message, this.currentIndex, this.lastPlayed);

  factory SynContext.fromJson(Map<String, dynamic> json) {

    var keys = <List<SynLetter>>[];
    if (json['keys'] != null) {
      json['keys'].forEach((row) {
        var rowKeys = <SynLetter>[];
        row.forEach((key) {
          rowKeys.add(SynLetter.fromJson(key));
        });
        keys.add(rowKeys);
      });
    }
    Synonym answer = json['answer'];
    String guess = json['guess'];
    var attempt = <SynLetter>[];
    json['attempt'].forEach((letter) {
      attempt.add(SynLetter.fromJson(letter));
    });
    int aciertos = json['aciertos'];
    String message = json['message'];
    int currentIndex = json['currentIndex'];
    DateTime? lastPlayed = json['lastPlayed'] != null ? DateTime.parse(json['lastPlayed']) : null;

    return SynContext(keys, answer, guess, attempt, aciertos, message,
        currentIndex, lastPlayed);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['keys'] = keys;
    data['answer'] = answer;
    data['guess'] = guess;
    data['attempt'] = attempt;
    data['aciertos'] = aciertos;
    data['message'] = message;
    data['currentIndex'] = currentIndex;
    data['lastPlayed'] = (lastPlayed ?? DateTime.now()).toIso8601String();
    return data;
  }
}
class Stats {
  int won;
  int lost;
  Streak streak;
  List<int> guessDistribution;
  int lastGuess;
  String lastBoard;
  int gameNumber;

  Stats(this.won, this.lost, this.streak, this.guessDistribution, this.lastGuess, this.lastBoard,
      this.gameNumber);

  Stats.fromJson(Map<String, dynamic> json)
      : won = json['won'],
        lost = json['lost'],
        streak = json['streak'] = Streak.fromJson(json['streak']),
        guessDistribution = json['guessDistribution'].cast<int>(),
        lastGuess = json['lastGuess'],
        lastBoard = json['lastBoard'] ?? '',
        gameNumber = json['gameNumber'] ?? 0;

  int get played => guessDistribution.reduce((value, g) => value + g) + lost;

  int get percentWon => played == 0 ? 0 : (won / played * 100).round();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['won'] = won;
    data['lost'] = lost;
    data['streak'] = streak.toJson();
    data['guessDistribution'] = guessDistribution;
    data['lastGuess'] = lastGuess;
    data['lastBoard'] = lastBoard;
    data['gameNumber'] = gameNumber;
    return data;
  }
}

class Streak {
  int current;
  int max;

  Streak(this.current, this.max);

  Streak.fromJson(Map<String, dynamic> json)
      : current = json['current'],
        max = json['max'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['current'] = current;
    data['max'] = max;
    return data;
  }
}
