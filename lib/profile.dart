import 'dart:io';
import 'package:MindOfWords/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  // late XFile image;
  @override
  void initState() {
    // initialize timercontroller
    LoadImage();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey,
        body: SafeArea(
            child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: getImage(pathimage),
              ), IconButton(
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
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [


                ],
              ),


            ],
          ),
        )));
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

  void LoadImage() async {
    final prefs = await SharedPreferences.getInstance();
    String? a = await prefs.getString('avatar');
    if(a!= null){
      setState(() {
        pathimage = a;
      });

    }
  }


}
