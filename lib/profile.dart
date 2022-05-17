import 'dart:io';
import 'package:MindOfWords/LeaderBoard.dart';
import 'package:MindOfWords/SignUp.dart';
import 'package:MindOfWords/Wordle/domain.dart';
import 'package:MindOfWords/Spell/domain.dart';
import 'package:MindOfWords/Synonyms/domain.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Wordle/services/stats_service.dart';
import 'Spell/services/stats_service.dart';
import 'Synonyms/services/stats_service.dart';
import 'dialog_selectAvatar.dart';

class ProfileApp extends StatelessWidget {
  const ProfileApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  String pathimage = "assets/Solid_white.png";
  var username = TextEditingController();
  late Stats wstats;
  late SpellStats spellstats;
  late SynStats synstats;
  Future<bool> _initialized = Future<bool>.value(false);

  // late XFile image;
  @override
  void initState() {
    // initialize timercontroller
    _initialized = LoadImage().then((value) {
      return value;
    });
    super.initState();
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
                  backgroundColor: Colors.grey[300],
                  body: SafeArea(
                      child:SingleChildScrollView(
                            child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                              CircleAvatar(
                                                    radius: 60,
                                                    backgroundImage: getImage(pathimage),
                                              ),
                                              IconButton(
                                                    onPressed: () async {
                                                          _avatarPicker();
                                                          setState(() {
                                                                // image = image;
                                                          });
                                                    },
                                                    icon: Icon(
                                                          Icons.add_a_photo,
                                                          color: Colors.tealAccent,
                                                          size: 30,
                                                    ),
                                              ),
                                              Text(
                                                    username.text,
                                                    style: TextStyle(
                                                          fontSize: 24,
                                                    ),
                                              ),
                                              Padding(padding: EdgeInsets.only(top: 10, bottom: 5)),
                                              SingleChildScrollView(
                                                    child: Column(
                                                          children: [
                                                                Container(
                                                                      width: 250,
                                                                      height: 180,
                                                                      decoration: BoxDecoration(
                                                                            border: Border.all(
                                                                                  color: Colors.black,
                                                                                  width: 5,
                                                                            ),
                                                                            borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      child: Center(
                                                                          child: Column(
                                                                                children: [
                                                                                      const Center(
                                                                                          child: Padding(
                                                                                              padding: EdgeInsets.only(top: 5),
                                                                                              child: Text(
                                                                                                    "WORDLE",
                                                                                                    style: TextStyle(
                                                                                                          fontSize: 18,
                                                                                                    ),
                                                                                              ))),
                                                                                      Padding(
                                                                                            padding: const EdgeInsets.fromLTRB(
                                                                                                10, 10, 10, 5),
                                                                                            child: Row(
                                                                                                  crossAxisAlignment:
                                                                                                  CrossAxisAlignment.start,
                                                                                                  mainAxisAlignment:
                                                                                                  MainAxisAlignment.center,
                                                                                                  children: [
                                                                                                        Padding(
                                                                                                              padding: const EdgeInsets.only(
                                                                                                                  left: 4, right: 4),
                                                                                                              child: Column(
                                                                                                                    children: [
                                                                                                                          Text(
                                                                                                                                wstats.played.toString(),
                                                                                                                                style: const TextStyle(
                                                                                                                                      fontSize: 36,
                                                                                                                                ),
                                                                                                                          ),
                                                                                                                          const Text(
                                                                                                                                "Played",
                                                                                                                                style: TextStyle(
                                                                                                                                      fontSize: 12,
                                                                                                                                ),
                                                                                                                          )
                                                                                                                    ],
                                                                                                              ),
                                                                                                        ),
                                                                                                        Padding(
                                                                                                              padding: const EdgeInsets.only(
                                                                                                                  left: 4, right: 4),
                                                                                                              child: Column(
                                                                                                                    children: [
                                                                                                                          Text(
                                                                                                                                wstats.percentWon.toString(),
                                                                                                                                style: const TextStyle(
                                                                                                                                      fontSize: 36,
                                                                                                                                ),
                                                                                                                          ),
                                                                                                                          const Text(
                                                                                                                                "Win %",
                                                                                                                                style: TextStyle(
                                                                                                                                      fontSize: 12,
                                                                                                                                ),
                                                                                                                          )
                                                                                                                    ],
                                                                                                              ),
                                                                                                        ),
                                                                                                        Padding(
                                                                                                              padding: const EdgeInsets.only(
                                                                                                                  left: 4, right: 4),
                                                                                                              child: Column(
                                                                                                                    children: [
                                                                                                                          Text(
                                                                                                                                wstats.streak.current
                                                                                                                                    .toString(),
                                                                                                                                style: const TextStyle(
                                                                                                                                      fontSize: 36,
                                                                                                                                ),
                                                                                                                          ),
                                                                                                                          Column(children: const [
                                                                                                                                Center(
                                                                                                                                    child: Text(
                                                                                                                                          "Current",
                                                                                                                                          style: TextStyle(
                                                                                                                                                fontSize: 12,
                                                                                                                                          ),
                                                                                                                                    )),
                                                                                                                                Center(
                                                                                                                                    child: Text(
                                                                                                                                          "Streak",
                                                                                                                                          style: TextStyle(
                                                                                                                                                fontSize: 12,
                                                                                                                                          ),
                                                                                                                                    ))
                                                                                                                          ]),
                                                                                                                    ],
                                                                                                              ),
                                                                                                        ),
                                                                                                        Padding(
                                                                                                              padding: const EdgeInsets.only(
                                                                                                                  left: 4, right: 4),
                                                                                                              child: Column(
                                                                                                                    children: [
                                                                                                                          Text(
                                                                                                                                wstats.streak.max.toString(),
                                                                                                                                style: const TextStyle(
                                                                                                                                      fontSize: 36,
                                                                                                                                ),
                                                                                                                          ),
                                                                                                                          Column(children: const [
                                                                                                                                Center(
                                                                                                                                    child: Text(
                                                                                                                                          "Max",
                                                                                                                                          style: TextStyle(
                                                                                                                                                fontSize: 12,
                                                                                                                                          ),
                                                                                                                                    )),
                                                                                                                                Center(
                                                                                                                                    child: Text(
                                                                                                                                          "Streak",
                                                                                                                                          style: TextStyle(
                                                                                                                                                fontSize: 12,
                                                                                                                                          ),
                                                                                                                                    ))
                                                                                                                          ]),
                                                                                                                    ],
                                                                                                              ),
                                                                                                        )
                                                                                                  ],
                                                                                            ),
                                                                                      ),
                                                                                      Padding(padding: EdgeInsets.only(top: 10)),
                                                                                      TextButton(
                                                                                            onPressed: () {
                                                                                                  Navigator.push(
                                                                                                        context,
                                                                                                        MaterialPageRoute(
                                                                                                            builder: (context) =>
                                                                                                                LeaderBoardApp()),
                                                                                                  );
                                                                                            },
                                                                                            child: Text('Leaderboard'),
                                                                                            style: ButtonStyle(
                                                                                                  backgroundColor:
                                                                                                  MaterialStateProperty.all<Color>(
                                                                                                      Colors.black38),
                                                                                                  foregroundColor:
                                                                                                  MaterialStateProperty.all<Color>(
                                                                                                      Colors.black),
                                                                                            ),
                                                                                      ),
                                                                                ],
                                                                          )),
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets.only(top: 10, bottom: 5)),
                                                                Container(
                                                                      width: 250,
                                                                      height: 180,
                                                                      decoration: BoxDecoration(
                                                                            border: Border.all(
                                                                                  color: Colors.black,
                                                                                  width: 5,
                                                                            ),
                                                                            borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      child: Center(
                                                                          child: Column(
                                                                                children: [
                                                                                      const Center(
                                                                                          child: Padding(
                                                                                              padding: EdgeInsets.only(top: 5),
                                                                                              child: Text(
                                                                                                    "SPELL",
                                                                                                    style: TextStyle(
                                                                                                          fontSize: 18,
                                                                                                    ),
                                                                                              ))),
                                                                                      Padding(
                                                                                            padding: const EdgeInsets.fromLTRB(
                                                                                                10, 10, 10, 5),
                                                                                            child: Row(
                                                                                                  crossAxisAlignment:
                                                                                                  CrossAxisAlignment.start,
                                                                                                  mainAxisAlignment:
                                                                                                  MainAxisAlignment.center,
                                                                                                  children: [
                                                                                                        Padding(
                                                                                                              padding: const EdgeInsets.only(
                                                                                                                  left: 4, right: 4),
                                                                                                              child: Column(
                                                                                                                    children: [
                                                                                                                          Text(
                                                                                                                                spellstats.played.toString(),
                                                                                                                                style: const TextStyle(
                                                                                                                                      fontSize: 36,
                                                                                                                                ),
                                                                                                                          ),
                                                                                                                          const Text(
                                                                                                                                "Played",
                                                                                                                                style: TextStyle(
                                                                                                                                      fontSize: 12,
                                                                                                                                ),
                                                                                                                          )
                                                                                                                    ],
                                                                                                              ),
                                                                                                        ),
                                                                                                        Padding(
                                                                                                              padding: const EdgeInsets.only(
                                                                                                                  left: 4, right: 4),
                                                                                                              child: Column(
                                                                                                                    children: [
                                                                                                                          Text(
                                                                                                                                spellstats.percentWon
                                                                                                                                    .toString(),
                                                                                                                                style: const TextStyle(
                                                                                                                                      fontSize: 36,
                                                                                                                                ),
                                                                                                                          ),
                                                                                                                          const Text(
                                                                                                                                "Win %",
                                                                                                                                style: TextStyle(
                                                                                                                                      fontSize: 12,
                                                                                                                                ),
                                                                                                                          )
                                                                                                                    ],
                                                                                                              ),
                                                                                                        ),
                                                                                                        Padding(
                                                                                                              padding: const EdgeInsets.only(
                                                                                                                  left: 4, right: 4),
                                                                                                              child: Column(
                                                                                                                    children: [
                                                                                                                          Text(
                                                                                                                                spellstats.streak.current
                                                                                                                                    .toString(),
                                                                                                                                style: const TextStyle(
                                                                                                                                      fontSize: 36,
                                                                                                                                ),
                                                                                                                          ),
                                                                                                                          Column(children: const [
                                                                                                                                Center(
                                                                                                                                    child: Text(
                                                                                                                                          "Current",
                                                                                                                                          style: TextStyle(
                                                                                                                                                fontSize: 12,
                                                                                                                                          ),
                                                                                                                                    )),
                                                                                                                                Center(
                                                                                                                                    child: Text(
                                                                                                                                          "Streak",
                                                                                                                                          style: TextStyle(
                                                                                                                                                fontSize: 12,
                                                                                                                                          ),
                                                                                                                                    ))
                                                                                                                          ]),
                                                                                                                    ],
                                                                                                              ),
                                                                                                        ),
                                                                                                        Padding(
                                                                                                              padding: const EdgeInsets.only(
                                                                                                                  left: 4, right: 4),
                                                                                                              child: Column(
                                                                                                                    children: [
                                                                                                                          Text(
                                                                                                                                spellstats.streak.max
                                                                                                                                    .toString(),
                                                                                                                                style: const TextStyle(
                                                                                                                                      fontSize: 36,
                                                                                                                                ),
                                                                                                                          ),
                                                                                                                          Column(children: const [
                                                                                                                                Center(
                                                                                                                                    child: Text(
                                                                                                                                          "Max",
                                                                                                                                          style: TextStyle(
                                                                                                                                                fontSize: 12,
                                                                                                                                          ),
                                                                                                                                    )),
                                                                                                                                Center(
                                                                                                                                    child: Text(
                                                                                                                                          "Streak",
                                                                                                                                          style: TextStyle(
                                                                                                                                                fontSize: 12,
                                                                                                                                          ),
                                                                                                                                    ))
                                                                                                                          ]),
                                                                                                                    ],
                                                                                                              ),
                                                                                                        )
                                                                                                  ],
                                                                                            ),
                                                                                      ),
                                                                                      Padding(padding: EdgeInsets.only(top: 10)),
                                                                                      TextButton(
                                                                                            onPressed: () {
                                                                                                  Navigator.push(
                                                                                                        context,
                                                                                                        MaterialPageRoute(
                                                                                                            builder: (context) =>
                                                                                                                LeaderBoardApp()),
                                                                                                  );
                                                                                            },
                                                                                            child: Text('Leaderboard'),
                                                                                            style: ButtonStyle(
                                                                                                  backgroundColor:
                                                                                                  MaterialStateProperty.all<Color>(
                                                                                                      Colors.black38),
                                                                                                  foregroundColor:
                                                                                                  MaterialStateProperty.all<Color>(
                                                                                                      Colors.black),
                                                                                            ),
                                                                                      ),
                                                                                ],
                                                                          )),
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets.only(top: 10, bottom: 5)),
                                                                Container(
                                                                      width: 250,
                                                                      height: 180,
                                                                      decoration: BoxDecoration(
                                                                            border: Border.all(
                                                                                  color: Colors.black,
                                                                                  width: 5,
                                                                            ),
                                                                            borderRadius: BorderRadius.circular(10),
                                                                      ),
                                                                      child: Center(
                                                                          child: Column(
                                                                                children: [
                                                                                      const Center(
                                                                                          child: Padding(
                                                                                              padding: EdgeInsets.only(top: 5),
                                                                                              child: Text(
                                                                                                    "SYNONYMS",
                                                                                                    style: TextStyle(
                                                                                                          fontSize: 18,
                                                                                                    ),
                                                                                              ))),
                                                                                      Padding(
                                                                                            padding: const EdgeInsets.fromLTRB(
                                                                                                10, 10, 10, 5),
                                                                                            child: Row(
                                                                                                  crossAxisAlignment:
                                                                                                  CrossAxisAlignment.start,
                                                                                                  mainAxisAlignment:
                                                                                                  MainAxisAlignment.center,
                                                                                                  children: [
                                                                                                        Padding(
                                                                                                              padding: const EdgeInsets.only(
                                                                                                                  left: 4, right: 4),
                                                                                                              child: Column(
                                                                                                                    children: [
                                                                                                                          Text(
                                                                                                                                synstats.played.toString(),
                                                                                                                                style: const TextStyle(
                                                                                                                                      fontSize: 36,
                                                                                                                                ),
                                                                                                                          ),
                                                                                                                          const Text(
                                                                                                                                "Played",
                                                                                                                                style: TextStyle(
                                                                                                                                      fontSize: 12,
                                                                                                                                ),
                                                                                                                          )
                                                                                                                    ],
                                                                                                              ),
                                                                                                        ),
                                                                                                        Padding(
                                                                                                              padding: const EdgeInsets.only(
                                                                                                                  left: 4, right: 4),
                                                                                                              child: Column(
                                                                                                                    children: [
                                                                                                                          Text(
                                                                                                                                synstats.percentWon
                                                                                                                                    .toString(),
                                                                                                                                style: const TextStyle(
                                                                                                                                      fontSize: 36,
                                                                                                                                ),
                                                                                                                          ),
                                                                                                                          const Text(
                                                                                                                                "Win %",
                                                                                                                                style: TextStyle(
                                                                                                                                      fontSize: 12,
                                                                                                                                ),
                                                                                                                          )
                                                                                                                    ],
                                                                                                              ),
                                                                                                        ),
                                                                                                        Padding(
                                                                                                              padding: const EdgeInsets.only(
                                                                                                                  left: 4, right: 4),
                                                                                                              child: Column(
                                                                                                                    children: [
                                                                                                                          Text(
                                                                                                                                synstats.streak.current
                                                                                                                                    .toString(),
                                                                                                                                style: const TextStyle(
                                                                                                                                      fontSize: 36,
                                                                                                                                ),
                                                                                                                          ),
                                                                                                                          Column(children: const [
                                                                                                                                Center(
                                                                                                                                    child: Text(
                                                                                                                                          "Current",
                                                                                                                                          style: TextStyle(
                                                                                                                                                fontSize: 12,
                                                                                                                                          ),
                                                                                                                                    )),
                                                                                                                                Center(
                                                                                                                                    child: Text(
                                                                                                                                          "Streak",
                                                                                                                                          style: TextStyle(
                                                                                                                                                fontSize: 12,
                                                                                                                                          ),
                                                                                                                                    ))
                                                                                                                          ]),
                                                                                                                    ],
                                                                                                              ),
                                                                                                        ),
                                                                                                        Padding(
                                                                                                              padding: const EdgeInsets.only(
                                                                                                                  left: 4, right: 4),
                                                                                                              child: Column(
                                                                                                                    children: [
                                                                                                                          Text(
                                                                                                                                synstats.streak.max
                                                                                                                                    .toString(),
                                                                                                                                style: const TextStyle(
                                                                                                                                      fontSize: 36,
                                                                                                                                ),
                                                                                                                          ),
                                                                                                                          Column(children: const [
                                                                                                                                Center(
                                                                                                                                    child: Text(
                                                                                                                                          "Max",
                                                                                                                                          style: TextStyle(
                                                                                                                                                fontSize: 12,
                                                                                                                                          ),
                                                                                                                                    )),
                                                                                                                                Center(
                                                                                                                                    child: Text(
                                                                                                                                          "Streak",
                                                                                                                                          style: TextStyle(
                                                                                                                                                fontSize: 12,
                                                                                                                                          ),
                                                                                                                                    ))
                                                                                                                          ]),
                                                                                                                    ],
                                                                                                              ),
                                                                                                        )
                                                                                                  ],
                                                                                            ),
                                                                                      ),
                                                                                      Padding(padding: EdgeInsets.only(top: 10)),
                                                                                      TextButton(
                                                                                            onPressed: () {
                                                                                                  Navigator.push(
                                                                                                        context,
                                                                                                        MaterialPageRoute(
                                                                                                            builder: (context) =>
                                                                                                                LeaderBoardApp()),
                                                                                                  );
                                                                                            },
                                                                                            child: Text('Leaderboard'),
                                                                                            style: ButtonStyle(
                                                                                                  backgroundColor:
                                                                                                  MaterialStateProperty.all<Color>(
                                                                                                      Colors.black38),
                                                                                                  foregroundColor:
                                                                                                  MaterialStateProperty.all<Color>(
                                                                                                      Colors.black),
                                                                                            ),
                                                                                      ),
                                                                                ],
                                                                          )),
                                                                ),
                                                          ],
                                                    ),
                                              ),
                                        ],
                                  ),
                            ),
                      ),
                      ))
            ];
          } else {
            children = [
              Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              )
            ];
          }
          return Stack(children: children);
        });
  }

  _avatarPicker() {
    setState(() {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return CustomDialogSelectAvatar(
              title: "Select your Avatar",
              descriptions:
                  "Select your avatar to display as your profile picture",
              text: "Yes",
              text2: "No",
              img: Image(image: AssetImage('assets/spell_background.png')),
            );
          });
    });
  }

  ImageProvider getImage(String a) {
    // if (image != null) {
    //   return FileImage(File(image.path));
    // }

    return AssetImage(a);
  }

  Future<bool> LoadImage() async {
    final prefs = await SharedPreferences.getInstance();
    String? a = await prefs.getString('avatar');
    String? u = await prefs.getString('userName');
    wstats = await StatsService().loadStats();
    spellstats = await SpellStatsService().loadStats();
    synstats = await SynStatsService().loadStats();
    if (a != null && u != null) {
      setState(() {
        pathimage = a;
        username.text = u;
      });
    }
    return true;
  }
}
