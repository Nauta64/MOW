import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:MindOfWords/Wordle/domain.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatsService {
  Future<String> _readAsset(String fileName) async {
    WidgetsFlutterBinding.ensureInitialized();
    return await rootBundle.loadString(fileName);
  }

  Future<Stats> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    String? usr = prefs.getString('userName');
    if(usr == null){
      usr = "null";
    }
    final jsonString = json.encode({"userName": usr});
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http
        .post(Uri.parse("https://mowapi.herokuapp.com/getStatsWordle"),
            headers: headers, body: jsonString)
        .timeout(const Duration(seconds: 5))
        .catchError((onError) {
      print("Conexion no establecida, error en la conexion");
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);

      return Stats.fromJson(body["stat"]);
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  Future<Stats> updateStats(Stats stats, bool won, int index,
      String Function(int n) getSharable, int gameNumber) async {
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
    stats.lastBoard = getSharable(index);
    stats.gameNumber = gameNumber;

    await saveStats(stats);
    return stats;
  }

  Future<void> saveStats(Stats stats) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode({"userName":await prefs.getString('userName') ,"stat": stats});
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http
        .post(Uri.parse("https://mowapi.herokuapp.com/setStatsWordle"),
        headers: headers, body: jsonString)
        .timeout(const Duration(seconds: 5))
        .catchError((onError) {
      print("Conexion no establecida, error en la conexion");
    });

  }
}
