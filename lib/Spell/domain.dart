
class SpellLetter {
  int index;
  String value;


  SpellLetter(this.index, this.value);

  SpellLetter.fromJson(Map<String, dynamic> json)
      : index = json['index'],
        value = json['value'];


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['index'] = index;
    data['value'] = value;
    return data;
  }
}


class SpellContext {
  List<List<SpellLetter>> keys;
  String answer;
  String guess;
  List<SpellLetter> attempt;
  int aciertos;
  String message;
  int currentIndex;
  DateTime? lastPlayed;

  SpellContext(this.keys, this.answer, this.guess, this.attempt,
      this.aciertos, this.message, this.currentIndex, this.lastPlayed);

  factory SpellContext.fromJson(Map<String, dynamic> json) {

    var keys = <List<SpellLetter>>[];
    if (json['keys'] != null) {
      json['keys'].forEach((row) {
        var rowKeys = <SpellLetter>[];
        row.forEach((key) {
          rowKeys.add(SpellLetter.fromJson(key));
        });
        keys.add(rowKeys);
      });
    }
    String answer = json['answer'];
    String guess = json['guess'];
    var attempt = <SpellLetter>[];
    json['attempt'].forEach((letter) {
      attempt.add(SpellLetter.fromJson(letter));
    });
    int aciertos = json['aciertos'];
    String message = json['message'];
    int currentIndex = json['currentIndex'];
    DateTime? lastPlayed = json['lastPlayed'] != null ? DateTime.parse(json['lastPlayed']) : null;

    return SpellContext(keys, answer, guess, attempt, aciertos, message,
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
class SpellStats {
  int won;
  int lost;
  Streak streak;

  SpellStats(this.won, this.lost, this.streak);

  SpellStats.fromJson(Map<String, dynamic> json)
      : won = json['won'],
        lost = json['lost'],
        streak = json['streak'] = Streak.fromJson(json['streak']);


  int get played => won + lost;

  int get percentWon => played == 0 ? 0 : (won / played * 100).round();

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['won'] = won;
    data['lost'] = lost;
    data['streak'] = streak.toJson();
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
