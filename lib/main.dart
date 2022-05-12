import 'package:MindOfWords/SignUp.dart';
import 'package:MindOfWords/Synonyms/synonym.dart';
import 'package:MindOfWords/profile.dart';
import 'package:MindOfWords/signIn.dart';
import 'package:MindOfWords/spell.dart';
import 'package:MindOfWords/Wordle/wordle.dart';
import 'package:MindOfWords/Spell/text_to_speech.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _hasUser = false;
  bool _showHelp = false;
  bool _showSettings = false;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  Future<bool> _initialized = Future<bool>.value(false);
  @override
  void initState() {
    _initialized =_getUser().then((value) {
      _hasUser = value;
      print(value);
      return value;
    });
    super.initState();
  }
  Future<bool> _getUser() async {
    final SharedPreferences prefs = await _prefs;
    final String? username = prefs.getString('userName');
    bool a = false;
    if(username != null){
      a = true;
    }
    return a;
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialized,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          List<Widget> children = [];
          if (_hasUser) {
            children = [_withuser()
              ];
          } else {
            children = [
              _withoutuser()
            ];
          }
          return Stack(children: children);
        });
  }
  Widget _withuser() => MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.grey[300],
          appBar: AppBar(
            backgroundColor: Colors.black87,
            title: Row(
              children: [
                Text("Mind Of Words"),
              ],
            ),
            actions: [
               _Logged_in(),
              const SizedBox(
                width: 25,
              ),
            ],
          ),
          body: _body()
        ),
      ),
    );
  Widget _withoutuser() => MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SafeArea(
      child: Scaffold(
          backgroundColor: Colors.grey[300],
          appBar: AppBar(
            backgroundColor: Colors.black87,
            title: Row(
              children: [
                Text("Mind Of Words"),
              ],
            ),
            actions: [
              _NoSignUp(),
              const SizedBox(
                width: 25,
              ),
            ],
          ),
          body: _body()
      ),
    ),
  );
  Widget _body() => Center(
    child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: 315,
              height: 315,
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // color: Colors.deepPurple.shade100,
                color: Colors.white,
                border:
                Border.all(width: 3.0, color: const Color(0xFF000000)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Wordle",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 200,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/wordle_background.png',
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WordleApp()),
                            );
                          },
                          child: Text('Play'),
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
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 315,
              height: 315,
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // color: Colors.deepPurple.shade100,
                color: Colors.white,
                border:
                Border.all(width: 3.0, color: const Color(0xFF000000)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Spell Word",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 200,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/spell_background.png',
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SpellApp()),
                            );
                          },
                          child: Text('Play'),
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
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 315,
              height: 315,
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                // color: Colors.deepPurple.shade100,
                color: Colors.white,
                border:
                Border.all(width: 3.0, color: const Color(0xFF000000)),
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Synonyms",
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 200,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/synonyms.png',
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    width: 200,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SynApp()),
                            );
                          },
                          child: Text('Play'),
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
                    ),
                  ),
                ],
              ),
            ),
          ],
        )),
  );
  Widget _NoSignUp() => PopupMenuButton(
    // add icon, by default "3 dot" icon
    // icon: Icon(Icons.book)
      itemBuilder: (context) {
        return [
          PopupMenuItem<int>(
            value: 0,
            child: Text("Sign Up"),
          ),
          PopupMenuItem<int>(
            value: 1,
            child: Text("Log In"),
          ),
        ];
      }, onSelected: (value) {
    if (value == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (builder) => const SignUpPage()));
    } else if (value == 1) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (builder) => const SignInPage()));
    }
  });

  Widget _Logged_in() => PopupMenuButton(
    // add icon, by default "3 dot" icon
    // icon: Icon(Icons.book)
      itemBuilder: (context) {
        return [
          PopupMenuItem<int>(
            value: 0,
            child: Text("Show Profile"),
          ),
          PopupMenuItem<int>(
            value: 1,
            child: Text("Log Out"),
          ),
        ];
      }, onSelected: (value) async {
    if (value == 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (builder) => const ProfilePage()));
    } else if (value == 1) {
      final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userName');
      await prefs.remove('mail');
      await prefs.remove('password');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (builder) => const MyApp()));
    }
  });
  _openHelp() {
    setState(() {
      _showHelp = true;
    });
  }



  _openSettings() {
    setState(() {
      _showSettings = true;
    });
  }
}
