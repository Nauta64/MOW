import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:MindOfWords/Synonyms/domain.dart';
import 'package:path_provider/path_provider.dart';

class SynStatsService {
  Future<String> _readAsset(String fileName) async {
    WidgetsFlutterBinding.ensureInitialized();
    return await rootBundle.loadString(fileName);
  }

  Future<SynStats> loadStats() async {
    final directory = await getApplicationDocumentsDirectory();
    final exists = await File("${directory.path}/stats.json").exists();
    final jsonString = exists
        ? await File("${directory.path}/stats.json").readAsString()
        : await _readAsset('assets/stats.json');

    final map = json.decode(jsonString);
    return SynStats.fromJson(map);
  }

  Future<SynStats> updateStats(
      SynStats stats, bool won, int index, int gameNumber) async {
    if (won) {
      stats.guessDistribution[index] += 1;
      stats.lastGuess = index + 1;
      stats.won += 1;
      stats.streak.current += 1;
      if (stats.streak.current > stats.streak.max) {
        stats.streak.max = stats.streak.current;
      }
    } else {
      stats.lost += 1;
      stats.streak.current = 0;
      stats.lastGuess = -1;
    }
    stats.gameNumber = gameNumber;

    await saveStats(stats);
    return stats;
  }

  Future<void> saveStats(SynStats stats) async {
    final directory = await getApplicationDocumentsDirectory();
    await File("${directory.path}/stats.json").writeAsString(json.encode(stats.toJson()));
  }
}
