import 'dart:io';
import 'package:MindOfWords/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dialog_selectAvatar.dart';

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
        backgroundColor: Colors.black87,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text(
            "Profile",
            style: TextStyle(
              color: Colors.purple,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
            child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: getImage(pathimage),
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  button("Save image"),
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
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.40,
              ),
              Text(
                "Exit App",
                style: TextStyle(color: Colors.purple, fontSize: 25),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (builder) => const SignUpPage()));
                  },
                  icon: Center(
                    child: Icon(
                      Icons.exit_to_app,
                      color: Colors.purple,
                      size: 40,
                    ),
                  )),
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

  Widget button(String name) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width / 2,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(colors: [
            Color(0xff8a32f1),
            Color(0xffad32f9),
          ]),
        ),
        child: Center(
            child: Text(
          name,
          style: const TextStyle(color: Colors.white),
        )),
      ),
    );
  }
}
