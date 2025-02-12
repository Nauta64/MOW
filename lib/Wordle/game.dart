import 'package:flutter/material.dart';
import 'package:flutter_animator/flutter_animator.dart';
import 'package:MindOfWords/Wordle/domain.dart';
import 'package:MindOfWords/Wordle/services/context_service.dart';
import 'package:MindOfWords/Wordle/services/keyboard_service.dart';
import 'package:MindOfWords/Wordle/services/matching_service.dart';
import 'package:MindOfWords/Wordle/services/stats_service.dart';
import 'package:MindOfWords/Wordle/services/word_service.dart';

class Wordle {
  static const boardSize = 30;
  static const rowLength = 5;
  static const totalTries = 6;
  static const cellMargin = 8;

  Wordle(){
    reloadGame();
  }
  static StatsService _statsService = StatsService();

  final _baseDate = DateTime(2021, DateTime.june, 19);

  late Context _context;
  late Stats _stats;
  late final List<GlobalKey<AnimatorWidgetState>> _shakeKeys = [];
  late final List<GlobalKey<AnimatorWidgetState>> _bounceKeys = [];

  var _wordService = WordService();

  bool isEvaluating = false;

  Stats get stats => _stats;
  int get _gameNumber => DateTime.now().difference(_baseDate).inDays;

  void updateBoard(List<Letter> attempt) {
    for (var i = 0; i < attempt.length; i++) {
      var offset = i + ((totalTries - _context.remainingTries) * rowLength);
      _context.board.tiles[offset] = attempt[i];
    }
  }

  List<List<Letter>> _updateKeys(List<List<Letter>> keys, List<Letter> guess) {
    for (var i = 0; i < guess.length; i++) {
      for (var x = 0; x < keys.length; x++) {
        for (var y = 0; y < keys[x].length; y++) {
          if (keys[x][y].value == guess[i].value && keys[x][y].color.index < guess[i].color.index) {
            keys[x][y] = guess[i];
          }
        }
      }
    }
    return keys;
  }

  bool _isToday(DateTime? dateTime) {
    if (dateTime == null) {
      return false;
    }
    var today = DateTime.now();
    return dateTime.year == today.year &&
        dateTime.month == today.month &&
        dateTime.day == today.day;
  }

  Future<bool> init() async {
    for (var i = 0; i < totalTries; i++) {
      _shakeKeys.add(GlobalKey<AnimatorWidgetState>());
    }
    for (var i = 0; i < boardSize; i++) {
      _bounceKeys.add(GlobalKey<AnimatorWidgetState>());
    }

    _stats = await _statsService.loadStats();
    await _initContext();
    await _wordService.init();


    return true;
  }

  Future<void> _initContext() async {
    var board = Board(List.filled(boardSize, Letter(0, '', GameColor.unset), growable: false));
    String s = await _wordService.getWordOfTheDay();
    _context = Context(board, KeyboardService.init().keys, s, '', [], TurnResult.unset, totalTries,
        'Good Luck!', 0);


  }

  bool didWin(List<Letter> attempt) =>
      attempt.isNotEmpty && attempt.every((l) => l.color == GameColor.exact);

  String _winningMessage(int remainingTries) {
    switch (remainingTries) {
      case 5:
        return 'Amazing!';
      case 4:
        return 'Fantastic!';
      case 3:
        return 'Great!';
      case 2:
        return 'Not bad';
      case 1:
        return 'Cutting it close!';
      default:
        return 'Phew!';
    }
  }

  String _getTileBlock(GameColor color) {
    switch (color) {
      case GameColor.unset:
      case GameColor.none:
        return '⬛️';
      case GameColor.partial:
        return '🟨';
      case GameColor.exact:
        return '🟩';
    }
  }

  String _getShareableBoard(int index) {
    String board = '';
    int endingIndex = ((totalTries - _context.remainingTries) * rowLength) + rowLength;
    for (int i = 0; i < endingIndex; i++) {
      if (i > 0 && i % rowLength == 0) {
        board += '\n';
      }
      board += _getTileBlock(_context.board.tiles[i].color);
    }
    return board;
  }

  Future<Stats> _updateStats(bool won, int remainingTries) async {
    return await _statsService.updateStats(
        _stats, won, (remainingTries - totalTries).abs(), _getShareableBoard, _gameNumber);
  }

  void evaluateTurn(String letter) {
    isEvaluating = true;
    _context.turnResult = TurnResult.partial;
    if (KeyboardService.isEnter(letter)) {
      if (!_wordService.isLongEnough(_context.guess)) {
        _context.message = 'Not enough letters';
        _context.turnResult = TurnResult.unsuccessful;
      } else if (_wordService.isValidGuess(_context.guess)) {
        _context.attempt =
            MatchingService.matches(_context.guess.toLowerCase(), _context.answer).toList();
        _context.turnResult = TurnResult.successful;
      } else {
        _context.message = 'Not in Word list';
        _context.turnResult = TurnResult.unsuccessful;
      }
    } else if (KeyboardService.isBackspace(letter)) {
      if (_context.guess.isNotEmpty) {
        var guess = _context.guess.substring(0, _context.guess.length - 1).padRight(rowLength);
        var buffer = guess.split('').map((l) => Letter(0, l, GameColor.unset));
        updateBoard(buffer.toList());
        _context.guess = guess.replaceAll(' ', '');
        _context.currentIndex -= 1;
      }
    } else {
      if (_context.guess.length < rowLength) {
        _context.guess = _context.guess + letter;
        _context.board.tiles[_context.currentIndex++] = Letter(0, letter, GameColor.unset);
      }
    }
  }

  Context get context => _context;
  List<GlobalKey<AnimatorWidgetState>> get shakeKeys => _shakeKeys;
  List<GlobalKey<AnimatorWidgetState>> get bounceKeys => _bounceKeys;

  Future updateAfterSuccessfulGuess() async {
    if (_context.turnResult == TurnResult.successful) {
      _context.keys = _updateKeys(_context.keys, _context.attempt);
      var won = didWin(_context.attempt);
      if (won || _context.remainingTries == 1) {
        _stats = await _updateStats(won, _context.remainingTries);
      }
      var remaining = _context.remainingTries - 1;
      _context.guess = '';
      _context.attempt = [];
      _context.remainingTries = won ? 0 : remaining;
      _context.message = won
          ? _winningMessage(remaining)
          : remaining == 0
          ? _context.answer
          : '';

    }
  }
  void reloadGame(){
    _statsService = StatsService();
    _wordService = WordService();
    init();
  }

}