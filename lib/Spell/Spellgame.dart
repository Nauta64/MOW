import 'package:MindOfWords/Spell/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:MindOfWords/Spell/services/keyboard_service.dart';
import 'package:MindOfWords/Spell/services/stats_service.dart';

import '../HttpService.dart';

class SpellGame {
  static const boardSize = 30;
  static const rowLength = 5;
  static const totalTries = 6;
  static const cellMargin = 8;

  SpellGame() {
    // reloadGame();
  }

  static StatsService _statsService = StatsService();

  final _baseDate = DateTime(2021, DateTime.june, 19);

  late SpellContext _context;

  late Stats _stats;
  late final List<GlobalKey<AnimatorWidgetState>> _shakeKeys = [];
  late final List<GlobalKey<AnimatorWidgetState>> _bounceKeys = [];

  bool isEvaluating = false;

  Stats get stats => _stats;

  int get _gameNumber => DateTime.now().difference(_baseDate).inDays;

  Future<String> getWords() async {
    final HttpService httpService = HttpService();
    String word = await httpService.getPosts();
    print(word);
    return word;
  }

  Future<bool> init() async {
    print("Init");
    await _initContext();
    _stats = await _statsService.loadStats();
    return true;
  }

  Future<bool> _initContext() async {
    String s = await getWords();
    _context = SpellContext(KeyboardService.init().keys, s, '', [], 0,
        'Good Luck!', 0, DateTime.now());
    print("InitContext");
    _context.answer = s;
    // print("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA${_context.answer}");

    return true;
  }

  Future<Stats> _updateStats(bool won, int remainingTries) async {
    return await _statsService.updateStats(
        _stats, won, (remainingTries - totalTries).abs(), _gameNumber);
  }

  evaluateTurn(String letter) {
    isEvaluating = true;
    if (KeyboardService.isEnter(letter)) {
      return true;
    } else if (KeyboardService.isBackspace(letter)) {
      _context.guess = _context.guess.substring(0, _context.guess.length - 1);
      return false;
    } else if (KeyboardService.isSpace(letter)) {
      _context.guess = _context.guess + " ";
      return false;
    } else {
      _context.guess = _context.guess + letter;
      // print(_context.guess);
      return false;
    }
  }

  SpellContext get context => _context;

  Future updateAfterSuccessfulGuess(String guess) async {
    var won = didWin(guess, _context.answer);

    _stats = await _updateStats(won, 0);

    _context.guess = '';
    _context.attempt = [];
  }

  bool didWin(String guess, String answer) {
    if (guess == answer) {
      return true;
    } else {
      return false;
    }
  }

  void reloadGame() {
    _statsService = StatsService();
    init();
  }
}
