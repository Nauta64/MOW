import 'package:MindOfWords/Synonyms/Models/Synonym.dart';
import 'package:MindOfWords/Synonyms/dialog_howTo.dart';
import 'package:MindOfWords/Synonyms/dialog_syn.dart';
import 'package:MindOfWords/Synonyms/syngame.dart';
import 'package:MindOfWords/Synonyms/widgets/stats.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:simple_timer/simple_timer.dart';
import 'package:quiver/collection.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../Spell/constants.dart';
import '../Synonyms/widgets/keyboard.dart';
import '../main.dart';

class SynApp extends StatelessWidget {
  const SynApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: SynView(title: 'Flutter Demo Home Page'),
    );
  }
}

class SynView extends StatefulWidget {
  SynView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SynView> createState() => _SpellViewState();
}

class _SpellViewState extends State<SynView>
    with SingleTickerProviderStateMixin {
  final SynGame _game = SynGame();

  int points = 0;
  bool _showStats = true;
  bool _showHelp = false;
  bool _showSettings = false;
  var txt = TextEditingController();
  var answer = TextEditingController();
  var btn_play = TextEditingController();
  late TimerController _timerController;
  TimerProgressIndicatorDirection _progressIndicatorDirection =
      TimerProgressIndicatorDirection.clockwise;
  TimerProgressTextCountDirection _progressTextCountDirection =
      TimerProgressTextCountDirection.count_down;

  Future<bool> _initialized = Future<bool>.value(false);
  final List<String> entries = <String>[];

  @override
  void initState() {
    // initialize timercontroller
    _timerController = TimerController(this);
    _initialized = _game.init().then((value) {
      print("initialized");
      return value;
    });
    btn_play.text = "PLAY";
    txt.text = "";
    super.initState();
  }

  void _onKeyPressed(String val) {
    setState(() {
      if (_game.evaluateTurn(val)) {
        if(txt.text == ""){
          entries.add(_game.context.guess.toLowerCase());
          _game.context.guess = "";
          txt.text = "";
        }
      } else {
        txt.text = _game.context.guess;
      }
      ;
    });
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
                            Navigator.of(context).push(PageTransition(type: PageTransitionType.leftToRight, child: MyApp()));
                          },
                          child: const Icon(
                            Icons.west,
                            size: 26.0,
                          ),
                        )),
                    title: Text("Synonyms"),
                    centerTitle: true,
                    actions: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16.0),
                          child: GestureDetector(
                            onTap: () => _openStats(),
                            child: const Icon(
                              Icons.leaderboard,
                              size: 26.0,
                            ),
                          )),
                      Padding(
                          padding: const EdgeInsets.only(right: 20.0),
                          child: GestureDetector(
                            onTap: () => _openHelp(),
                            child: const Icon(
                              Icons.help_outline,
                              size: 26.0,
                            ),
                          )),
                    ],
                  ),
                  body: Stack(children: [
                    Positioned(
                      bottom: 160,
                      top: 5,
                      left: 0,
                      right: 0,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 60,
                                margin: EdgeInsets.symmetric(vertical: 5),
                                child: SimpleTimer(
                                    duration: const Duration(seconds: 60),
                                    controller: _timerController,
                                    onStart: handleTimerOnStart,
                                    onEnd: handleTimerOnEnd,
                                    valueListener: timerValueChangeListener,
                                    backgroundColor: Colors.white10,
                                    progressIndicatorColor: Colors.blue,
                                    progressTextStyle:
                                        TextStyle(color: Colors.black),
                                    progressIndicatorDirection:
                                        _progressIndicatorDirection,
                                    progressTextCountDirection:
                                        _progressTextCountDirection,
                                    strokeWidth: 7),
                              ),
                              Container(
                                width: 50,
                              ),
                              Text(
                                answer.text,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                        bottom: 250,
                        top: 60,
                        left: 0,
                        right: 0,
                        child: Container(
                          margin: const EdgeInsets.all(15.0),
                          padding: const EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            // color: Colors.deepPurple.shade100,
                            color: Colors.white,
                            border: Border.all(
                                width: 3.0, color: const Color(0xFF000000)),
                          ),
                          child: ListView.builder(
                            padding: const EdgeInsets.all(8),
                            itemCount: entries.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(entries[index],
                                      textAlign: TextAlign.center),
                                ),
                              );
                            },
                          ),
                        )),
                    Positioned(
                      left: 15,
                      right: 15,
                      bottom: 210,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center, //Center Column contents vertically,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 220.0,
                            child: TextField(
                              controller: txt,
                              keyboardType: TextInputType.none,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.all(8.0),
                              ),
                            ),
                          ),
                          Container(
                            width: 7,
                          ),
                          Container(
                            width: 100.0,
                            height: 49,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  if (btn_play.text == "PLAY") {
                                    setState(() {
                                      answer.text = _game.context.answer.word;
                                    });
                                    _timerController.start();
                                    btn_play.text = "ENTER";
                                  } else {
                                    if(txt.text != ""){
                                      entries
                                          .add(txt.text);
                                      _game.context.guess = "";
                                      txt.text = "";
                                    }
                                  }
                                });
                              },
                              child: Text(
                                btn_play.text,
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox.expand(
                      child: FittedBox(
                          fit: BoxFit.contain,
                          child: SizedBox(
                              width: 400,
                              height: 670,
                              child: Stack(children: [
                                Positioned(
                                    top: 490,
                                    left: 0,
                                    child: Keyboard(
                                        _game.context.keys, _onKeyPressed)),
                              ]))),
                    ),
                  ])),
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
                          )
                      ),
                    ],
              ),
              ),
            ];
          }
          return Stack(children: children);
        });
  }

  void _setCountDirection(TimerProgressTextCountDirection countDirection) {
    setState(() {
      _progressTextCountDirection = countDirection;
    });
  }

  void _setProgressIndicatorDirection(
      TimerProgressIndicatorDirection progressIndicatorDirection) {
    setState(() {
      _progressIndicatorDirection = progressIndicatorDirection;
    });
  }

  void timerValueChangeListener(Duration timeElapsed) {}

  void handleTimerOnStart() {
    print("timer has just started");
  }

  void handleTimerOnEnd() {
    _game.context.answer.syn.sort((a, b) {
      //sorting in descending order
      return b.compareTo(a);
    });
    entries.sort((a, b) {
      //sorting in descending order
      return b.compareTo(a);
    });
    for (String correct in _game.context.answer.syn) {
      for (String guess in entries) {
        if (guess == correct) {
          _game.context.aciertos += 1;
        }
      }
    }
    _game.updateAfterSuccessfulGuess(entries).then((_) => setState(() {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogBox(
              title: "Time Up",
              descriptions: "You made ${_game.context.aciertos} of ${_game.context.answer.syn.length}",
              text: "Yes",
              text2: "No",
              img:
              Image(image: AssetImage('assets/spell_background.png')),
              points: points,
            );
          });
    }));


    print(_game.context.aciertos);
    print("timer has ended");
  }

  Widget _image(String asset) {
    return Image.asset(
      asset,
      height: 30.0,
      width: 30.0,
      color: Colors.red,
    );
  }

  _openHelp() {
    setState(() {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogHowTo(
              title: "How To Play Spell",
              descriptions: "The game starts with 3 lives.?",
              text: "Yes",
              text2: "No",
              img: Image(image: AssetImage('assets/spell_background.png')),
              points: points,
            );
          });
    });
  }

  _openStats() {
    setState(() {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return Container(
                padding: EdgeInsets.only(left: Constants.padding,top: Constants.avatarRadius
                + Constants.padding, right: Constants.padding,bottom: Constants.padding
            ),child: StatsWidget(_game.stats, _closeStats, _newGame));
          });

      _showStats = true;
    });
  }

  void _closeStats() {
    setState(() {
      _showStats = false;
    });
  }

  void _newGame() {
    setState(() {
      _game.init();
    });
  }
}
