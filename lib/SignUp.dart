import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:MindOfWords/Models/user.dart';
import 'package:MindOfWords/signIn.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  Widget currentPage = const SignUpPage();

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    setState(() {
      currentPage = const MyApp();
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool circular = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            // color: Colors.deepPurple.shade100,
            image: DecorationImage(
              image: AssetImage("assets/bg5.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  mailItem("Email", _emailController, false),
                  const SizedBox(
                    height: 15,
                  ),
                  textItem("UserName", _nameController, false),
                  const SizedBox(
                    height: 15,
                  ),
                  textItem("Password", _passwordController, true),
                  const SizedBox(
                    height: 15,
                  ),
                  colorButton("Sign Up"),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        "If you already have an Account ?",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => const SignInPage()),
                              (route) => false);
                        },
                        child: const Text(
                          " Login",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Widget buttonItem(
      String imagePath, String buttonName, double size, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width - 60,
        height: 60,
        child: Card(
          elevation: 8,
          color: Colors.black,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: const BorderSide(
                width: 1,
                color: Colors.grey,
              )),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 15,
              ),
              Text(
                buttonName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget textItem(
      String name, TextEditingController controller, bool obsecureText) {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      height: 55,
      child: TextFormField(
        controller: controller,
        obscureText: obsecureText,
        style: const TextStyle(
          fontSize: 17,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black,
          labelText: name,
          labelStyle: const TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 1.5,
              color: Colors.amber,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  Widget mailItem(
      String name, TextEditingController controller, bool obsecureText) {
    return Container(
      width: MediaQuery.of(context).size.width - 70,
      height: 55,
      child: TextFormField(
        controller: controller,
        obscureText: obsecureText,
        style: const TextStyle(
          fontSize: 17,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.black,
          labelText: name,
          labelStyle: const TextStyle(
            fontSize: 17,
            color: Colors.white,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 1.5,
              color: Colors.amber,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(
              width: 1,
              color: Colors.grey,
            ),
          ),
        ),
        keyboardType: TextInputType.emailAddress,
      ),
    );
  }

  Widget colorButton(String name) {
    return InkWell(
      onTap: () async {
        setState(() {
          circular = true;
        });
        try {
          if (!_emailController.text.contains("@")) {
            final snackbar = SnackBar(content: Text("Mail no valid"));
            ScaffoldMessenger.of(context).showSnackBar(snackbar);
          } else {
            final prefs = await SharedPreferences.getInstance();
            final jsonString = json.encode(User(
                Mail: _emailController.text,
                UserName: _nameController.text,
                Password: _passwordController.text,
                img: "assets/avatars/cerdo.png"));
            final headers = {
              HttpHeaders.contentTypeHeader: 'application/json',
              "Access-Control-Allow-Origin": "*"
            };
            final response = await http
                .post(Uri.parse("https://mowapi.herokuapp.com/adduser"),
                    headers: headers, body: jsonString)
                .timeout(const Duration(seconds: 5))
                .catchError((onError) {
              print("Conexion no establecida, error en la conexion");
            });
            Map<String, dynamic> user;
            if (response.statusCode == 200) {
              print("Conexion Establecida");
              await prefs.setString('userName', _nameController.text);
              await prefs.setString('mail', _emailController.text);
              await prefs.setString('avatar', "assets/avatars/cerdo.png");
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (builder) => const MyApp()),
                  (route) => false);
            } else {
              final snackbar =
                  SnackBar(content: Text("This username is taken"));
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            }

            // firebase_auth.UserCredential userCredential =
            // await firebaseAuth.createUserWithEmailAndPassword(
            //     email: _emailController.text,
            //     password: _passwordController.text);
            // print(userCredential.user.email);

          }
          setState(() {
            circular = false;
          });
        } catch (e) {
          final snackbar = SnackBar(content: Text(e.toString()));
          ScaffoldMessenger.of(context).showSnackBar(snackbar);
          setState(() {
            circular = false;
          });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 90,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(colors: [
            Color(0xFFFD746C),
            Color(0xFFFF9068),
            Color(0xFFFD746C),
          ]),
        ),
        child: Center(
          child: circular
              ? const CircularProgressIndicator()
              : Text(name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  )),
        ),
      ),
    );
  }
}
