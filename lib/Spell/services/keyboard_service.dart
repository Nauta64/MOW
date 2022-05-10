import 'package:MindOfWords/Spell/domain.dart';

class KeyboardService {
  final List<List<SpellLetter>> _keys;

  List<List<SpellLetter>> get keys => _keys;

  KeyboardService._(this._keys);

  static SpellLetter _toLetter(String letter) {
    return SpellLetter(0, letter);
  }

  static KeyboardService init() {
    var keys = <List<SpellLetter>>[
      <String>['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'].map((l) => _toLetter(l)).toList(),
      <String>['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'].map((l) => _toLetter(l)).toList(),
      <String>['SPACE', 'Z', 'X', 'C', 'V', 'B', 'N', 'M', 'BACK'].map((l) => _toLetter(l)).toList(),
    ];
    return KeyboardService._(keys);
  }

  static bool isEnter(String letter) => letter == 'ENTER';
  static bool isBackspace(String letter) => letter == 'BACK';
  static bool isSpace(String letter) => letter == 'SPACE';
}