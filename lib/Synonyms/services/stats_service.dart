import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:MindOfWords/Synonyms/domain.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SynStatsService {
  Future<String> _readAsset(String fileName) async {
    WidgetsFlutterBinding.ensureInitialized();
    return await rootBundle.loadString(fileName);
  }

  Future<SynStats> loadStats() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode({"userName": prefs.getString('userName')});
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http
        .post(Uri.parse("https://t1edtq.deta.dev/getStatsSyn"),
        headers: headers, body: jsonString)
        .timeout(const Duration(seconds: 5))
        .catchError((onError) {
      print("Conexion no establecida, error en la conexion");
    });
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body);

      return SynStats.fromJson(body["stat"]);
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  Future<SynStats> updateStats(
      SynStats stats, bool won, int index, int gameNumber) async {
    if (won) {

      stats.won += 1;
      stats.streak.current += 1;
      if (stats.streak.current > stats.streak.max) {
        stats.streak.max = stats.streak.current;
      }
    } else {
      stats.lost += 1;
      stats.streak.current = 0;

    }


    await saveStats(stats);
    return stats;
  }

  Future<void> saveStats(SynStats stats) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode({"userName":await prefs.getString('userName') ,"stat": stats});
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response = await http
        .post(Uri.parse("https://t1edtq.deta.dev/setStatsSyn"),
        headers: headers, body: jsonString)
        .timeout(const Duration(seconds: 5))
        .catchError((onError) {
      print("Conexion no establecida, error en la conexion");
    });
  }
}
