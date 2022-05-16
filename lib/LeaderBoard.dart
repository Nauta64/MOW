import 'dart:convert';

import 'package:MindOfWords/Models/lrankingw.dart';
import 'package:MindOfWords/Models/rankingW.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'HttpService.dart';

class LeaderBoardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter App Learning',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: LeaderBoardView()
    );
  }
}

class LeaderBoardView extends StatefulWidget {
  LeaderBoardView({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LeaderBoardView> {
  late List<RankingW> r ;
  @override
  void initState()  {
    // initialize timercontroller
    init();
    super.initState();
  }

  Future<bool> init() async {
      r = await getRanking();

    return true;
  }
  Future<List<RankingW>> getRanking() async {
    Response res = await get(Uri.parse("http://192.168.0.134:5000/getrankingWordle"));

    if (res.statusCode == 200) {
      List<RankingW> rank = List<RankingW>.empty(growable: true);
      int count = 0;
      Map<String, dynamic> body = jsonDecode(res.body);
      for (int i = 0; i < 50; i++) {
        print(body["$i"]);
        rank.add(RankingW.fromJson(body["$i"]));
      }
      return rank;

      //
      // for (var i in body){
      //   rank.add(RankingW.fromJson(body[count]));
      //   count+=1;
      // // }
      // r = ListRanking(rank: rank);
      // return ListRanking.fromJson((jsonDecode(res.body)["statWordle"] as List).map((e) => e as Map<String, dynamic>)?.toList());
    } else {
      throw "Unable to retrieve posts.";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Flutter ListView"),
        ),
        body: ListView.builder(
          itemBuilder: (BuildContext, index){
            return Card(
              child: ListTile(
                leading: CircleAvatar(backgroundImage: AssetImage(r[index].img),),
                title: Text(r[index].UserName),
                subtitle: Text("This is subtitle"),
              ),
            );
          },
          itemCount: r.length,
          shrinkWrap: true,
          padding: EdgeInsets.all(5),
          scrollDirection: Axis.vertical,
        )
    );
  }
}