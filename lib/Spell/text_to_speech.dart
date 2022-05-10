import 'dart:async';
import 'dart:io' show Platform;
import 'dart:ui';
import 'package:MindOfWords/Spell/dialog_howTo.dart';
import 'package:MindOfWords/Spell/dialog_spell.dart';
import 'package:MindOfWords/Spell/how_to.dart';
import 'package:MindOfWords/Spell/widgets/keyboard.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../HttpService.dart';
import 'Spellgame.dart';

class SpellApp extends StatelessWidget {
  const SpellApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: SpellView(title: 'Flutter Demo Home Page'),
    );
  }
}

class SpellView extends StatefulWidget {
  SpellView({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SpellView> createState() => text_to_speech();
}

enum TtsState { playing, stopped, paused, continued }

class text_to_speech extends State<SpellView> {
  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;
  bool _showStats = false;
  bool _showHelp = false;
  bool _showSettings = false;
  final SpellGame _game = SpellGame();
  int points = 0;
  double _healts = 3;

  String? _newVoiceText;
  String? _enteredText;
  int? _inputLength;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  get isPaused => ttsState == TtsState.paused;

  get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  bool get isWeb => kIsWeb;

  var txt = TextEditingController();
  Future<bool> _initialized = Future<bool>.value(false);

  @override
  Future<String?> getWordForAudio() async {
    final HttpService httpService = HttpService();
    _initialized = _game.init().then((value) {
      print("initialized");
      return value;
    });
    String randword = _game.context.answer;
    _newVoiceText = randword;
    // _newVoiceText = "Roger Roger";
    print(randword);
    print(_newVoiceText);
    return _newVoiceText;
  }

  @override
  initState() {
    super.initState();
    initTts();
    getWordForAudio();
  }

  void _closeStats() {
    setState(() {
      _showStats = false;
    });
  }

  void _closeHelp() {
    setState(() {
      _showHelp = false;
    });
  }

  initTts() {
    flutterTts = FlutterTts();

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultEngine();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    if (isWeb || isIOS) {
      flutterTts.setPauseHandler(() {
        setState(() {
          print("Paused");
          ttsState = TtsState.paused;
        });
      });

      flutterTts.setContinueHandler(() {
        setState(() {
          print("Continued");
          ttsState = TtsState.continued;
        });
      });
    }

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future<dynamic> _getLanguages() => flutterTts.getLanguages;

  Future<dynamic> _getEngines() => flutterTts.getEngines;

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (_newVoiceText != null) {
      if (_newVoiceText!.isNotEmpty) {
        await flutterTts.speak(_newVoiceText!);
      }
    }
  }

  Future _check() async {
    if (_enteredText == _newVoiceText) {
      setState(() {
        points++;
        getWordForAudio();
      });

      print(points);
    } else {
      setState(() {
        _healts = _healts - 1;
        if (_healts == 0) {
          setState(() {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return CustomDialogBox(
                    title: "Game Over",
                    descriptions: "You lost, do you want to try again?",
                    text: "Yes",
                    text2: "No",
                    img:
                        Image(image: AssetImage('assets/spell_background.png')),
                    points: points,
                  );
                });
          });
        }
      });
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Future _pause() async {
    var result = await flutterTts.pause();
    if (result == 1) setState(() => ttsState = TtsState.paused);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getEnginesDropDownMenuItems(dynamic engines) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in engines) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedEnginesDropDownItem(String? selectedEngine) {
    flutterTts.setEngine(selectedEngine!);
    language = null;
    setState(() {
      engine = selectedEngine;
    });
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems(
      dynamic languages) {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(DropdownMenuItem(
          value: type as String?, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String? selectedType) {
    setState(() {
      language = selectedType;
      flutterTts.setLanguage(language!);
      if (isAndroid) {
        flutterTts
            .isLanguageInstalled(language!)
            .then((value) => isCurrentLanguageInstalled = (value as bool));
      }
    });
  }

  void _onChange(String text) {
    setState(() {
      _enteredText = text;
    });
  }

  void _onKeyPressed(String val) {
    setState(() {
      if (_game.evaluateTurn(val)) {
        _game.context.guess = "";
        txt.text = "";
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
                // appBar: AppBar(
                //   title: Text('Text to Speech'),
                // ),

                appBar: AppBar(
                  leading: Padding(
                      padding: const EdgeInsets.only(left: 16, right: 20.0),
                      child: GestureDetector(
                        onTap: () => _openHelp(),
                        child: const Icon(
                          Icons.help_outline,
                          size: 26.0,
                        ),
                      )),
                  title: Text("Spell"),
                  centerTitle: true,
                  actions: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(left: 16, right: 16.0),
                        child: GestureDetector(
                          // onTap: () => _openStats(),
                          child: const Icon(
                            Icons.leaderboard,
                            size: 26.0,
                          ),
                        )),
                    Padding(
                        padding: const EdgeInsets.only(right: 20.0),
                        child: GestureDetector(
                          // onTap: () => _openSettings(),
                          child: const Icon(
                            Icons.settings,
                            size: 26.0,
                          ),
                        )),
                  ],
                ),

                body: Stack(
                  // scrollDirection: Axis.vertical,
                  children: [
                    Column(children: [
                      // _actionBar(),
                      _ratingBar(),
                      _inputSection(),
                      _btnSection(),
                      _engineSection(),
                      _futureBuilder(),
                      _buildSliders(),
                    ]),
                    Positioned(
                      bottom: 0,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 250,
                            child: Stack(children: [
                              Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  top: 70,
                                  child: Keyboard(
                                      _game.context.keys, _onKeyPressed)),
                            ])),
                      ),
                    ),
                  ],
                ),
              ),
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

  Widget _engineSection() {
    if (isAndroid) {
      return FutureBuilder<dynamic>(
          future: _getEngines(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              return _enginesDropDownSection(snapshot.data);
            } else if (snapshot.hasError) {
              return Text('Error loading engines...');
            } else
              return Text('Loading engines...');
          });
    } else
      return Container(width: 0, height: 0);
  }

  Widget _futureBuilder() => FutureBuilder<dynamic>(
      future: _getLanguages(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return _languageDropDownSection(snapshot.data);
        } else if (snapshot.hasError) {
          return Text('Error loading languages...');
        } else
          return Text('Loading Languages...');
      });

  Widget _actionBar() => Row();

  Widget _ratingBar() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            padding: EdgeInsets.only(top: 10.0, right: 65.0),
            child: Text(
              "Points: ${points}",
              style: TextStyle(fontSize: 30),
            ),
          ),
          Container(
              padding: EdgeInsets.only(top: 10.0),
              child: RatingBar(
                initialRating: _healts,
                direction: Axis.horizontal,
                allowHalfRating: true,
                ignoreGestures: true,
                itemCount: 3,
                ratingWidget: RatingWidget(
                  full: _image('assets/heart.png'),
                  half: _image('assets/heart_half.png'),
                  empty: _image('assets/heart_border.png'),
                ),
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                onRatingUpdate: (rating) {
                  print(rating);
                },
              )),
        ],
      );

  Widget _inputSection() => Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 2.0, left: 25.0, right: 25.0),
      child: TextField(
        controller: txt,
        keyboardType: TextInputType.none,
        onChanged: (String value) {
          _onChange(value);
        },
        style: TextStyle(fontSize: 18),
      ));

  Widget _btnSection() {
    if (isAndroid) {
      return Container(
          padding: EdgeInsets.only(top: 20.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _buildButtonColumn(Colors.green, Colors.greenAccent,
                Icons.play_arrow, 'PLAY', _speak),
            _buildButtonColumn(Colors.blue, Colors.blue,
                Icons.wifi_protected_setup_outlined, 'CHECK', _check),
            _buildButtonColumn(
                Colors.red, Colors.redAccent, Icons.stop, 'STOP', _stop),
          ]));
    } else {
      return Container(
          padding: EdgeInsets.only(top: 20.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            _buildButtonColumn(Colors.green, Colors.greenAccent,
                Icons.play_arrow, 'PLAY', _speak),
            _buildButtonColumn(
                Colors.red, Colors.redAccent, Icons.stop, 'STOP', _stop),
            _buildButtonColumn(
                Colors.blue, Colors.blueAccent, Icons.pause, 'PAUSE', _pause),
          ]));
    }
  }

  Widget _enginesDropDownSection(dynamic engines) => Container(
        padding: EdgeInsets.only(top: 30.0),
        child: DropdownButton(
          value: engine,
          items: getEnginesDropDownMenuItems(engines),
          onChanged: changedEnginesDropDownItem,
        ),
      );

  Widget _languageDropDownSection(dynamic languages) => Container(
      padding: EdgeInsets.only(top: 10.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        DropdownButton(
          value: language,
          items: getLanguageDropDownMenuItems(languages),
          onChanged: changedLanguageDropDownItem,
        ),
        Visibility(
          visible: isAndroid,
          child: Text("Is installed: $isCurrentLanguageInstalled"),
        ),
      ]));

  Column _buildButtonColumn(Color color, Color splashColor, IconData icon,
      String label, Function func) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
              icon: Icon(icon),
              color: color,
              splashColor: splashColor,
              onPressed: () => func()),
          Container(
              margin: const EdgeInsets.only(top: 8.0),
              child: Text(label,
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                      color: color)))
        ]);
  }

  Widget _buildSliders() {
    return Column(
      children: [_volume(), _pitch(), _rate()],
    );
  }

  Widget _volume() {
    return Slider(
        value: volume,
        onChanged: (newVolume) {
          setState(() => volume = newVolume);
        },
        min: 0.0,
        max: 1.0,
        divisions: 10,
        label: "Volume: $volume",
        activeColor: Colors.blue);
  }

  Widget _pitch() {
    return Slider(
      value: pitch,
      onChanged: (newPitch) {
        setState(() => pitch = newPitch);
      },
      min: 0.5,
      max: 2.0,
      divisions: 15,
      label: "Pitch: $pitch",
      activeColor: Colors.red,
    );
  }

  Widget _rate() {
    return Slider(
      value: rate,
      onChanged: (newRate) {
        setState(() => rate = newRate);
      },
      min: 0.0,
      max: 1.0,
      divisions: 10,
      label: "Rate: $rate",
      activeColor: Colors.green,
    );
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
      _showStats = true;
    });
  }

  _openSettings() {
    setState(() {
      _showSettings = true;
    });
  }
}
