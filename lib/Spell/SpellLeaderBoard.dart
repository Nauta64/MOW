import 'dart:convert';

import 'package:MindOfWords/Models/lrankingw.dart';
import 'package:MindOfWords/Models/rankingSpell.dart';
import 'package:MindOfWords/Models/rankingW.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:page_transition/page_transition.dart';
import '../HttpService.dart';
import '../profile.dart';

class SpellLeaderBoardApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter App Learning',
        theme: ThemeData(
          primarySwatch: Colors.grey,
        ),
        home: LeaderBoardView());
  }
}

class LeaderBoardView extends StatefulWidget {
  LeaderBoardView({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<LeaderBoardView> {
  late List<RankingSpell> r;

  Future<bool> _initialized = Future<bool>.value(false);

  @override
  void initState() {
    // initialize timercontroller
    _initialized = init().then((value) {
      print("initialized");
      return value;
    });
    super.initState();
  }

  Future<bool> init() async {
    r = await getRanking();
    return true;
  }

  Future<List<RankingSpell>> getRanking() async {
    Response res =
        await get(Uri.parse("https://mowapi.herokuapp.com/getrankingSpell"));

    if (res.statusCode == 200) {
      List<RankingSpell> rank = List<RankingSpell>.empty(growable: true);
      int count = 0;
      print(res.body);
      Map<String, dynamic> body = jsonDecode(res.body);
      for (int i = 0; i < body.keys.length; i++) {
        print(body["$i"]);
        rank.add(RankingSpell.fromJson(body["$i"]));
      }

      r = rank;
      return rank;
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialized,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          List<Widget> children = [];
          if (snapshot.hasData) {
            children = [
              Scaffold(
                  appBar: AppBar(
                    leading: Padding(
                        padding: const EdgeInsets.only(left: 16, right: 20.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(PageTransition(type: PageTransitionType.leftToRight, child: ProfileApp()));
                          },
                          child: const Icon(
                            Icons.west,
                            size: 26.0,
                          ),
                        )),
                    title: Text("Ranking Wordle"),
                  ),
                  body: ListView.builder(
                    itemBuilder: (BuildContext, index) {
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(r[index].img),
                          ),
                          title: Text("${index+1}   ${r[index].UserName}"),
                          trailing: Column(children: [
                            Text("Won: ${r[index].StatS.won}"),
                            Padding(padding: EdgeInsets.only(top: 5)),
                            Text("Max Streak: ${r[index].StatS.streak.max}"),
                          ],),
                        ),
                      );
                    },
                    itemCount: r.length,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(5),
                    scrollDirection: Axis.vertical,
                  ))
            ];
          } else {
            children = [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    Text("Loading...",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                        )),
                  ],
                ),
              ),
            ];
          }
          return Stack(children: children);
        });
  }
}
