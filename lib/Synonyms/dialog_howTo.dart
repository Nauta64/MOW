import 'dart:ui';


import 'package:MindOfWords/Spell/constants.dart';
import 'package:MindOfWords/Spell/text_to_speech.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialogHowTo extends StatefulWidget {
  final String title, descriptions, text, text2;
  final Image img;
  final int points;

  const CustomDialogHowTo({Key? key, required this.title, required this.descriptions, required this.text, required this.img, required this.points, required this.text2}) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogHowTo> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Constants.padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }
  contentBox(context){
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: Constants.padding,top: Constants.avatarRadius
              + Constants.padding, right: Constants.padding,bottom: Constants.padding
          ),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(color: Colors.black,offset: Offset(0,10),
                    blurRadius: 10
                ),
              ]
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,

            children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  child: Text(widget.title,style: TextStyle(fontSize: 22,fontWeight: FontWeight.w600), textAlign: TextAlign.center)
              ),

              SizedBox(height: 15,),
              Text("Description:",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
              Text("· The goal of the game is to guess the most synoynms of a words in 1 minute.",style: TextStyle(fontSize: 14),textAlign: TextAlign.left,),
              Text("· When the button play is pressed at the top will apear the word where you'll have to find the synonyms.",style: TextStyle(fontSize: 14),textAlign: TextAlign.left,),
              Text("· At the left of the word there's a timer that will start at he same time the word appear.",style: TextStyle(fontSize: 14),textAlign: TextAlign.left,),
              SizedBox(height: 22,),
              Text("Instructions:",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
              Text("1. Hit the play button.",style: TextStyle(fontSize: 14),textAlign: TextAlign.left,),
              Text("2. Write a word and press SEND that word will be stored in the list.",style: TextStyle(fontSize: 14),textAlign: TextAlign.left,),
              Text("3. Write the most synonyms of the word you can before the time runs out.",style: TextStyle(fontSize: 14),textAlign: TextAlign.left,),
              Text("4. Once the time is up, the result will show as well as the list of correct synonyms.",style: TextStyle(fontSize: 14),textAlign: TextAlign.left,),
              SizedBox(height: 22,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                        onPressed: (){
                          //===== TANCAR DIALOG =======
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        child: Text(widget.text,style: TextStyle(fontSize: 18),)),
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: Constants.padding,
          right: Constants.padding,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: Constants.avatarRadius,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                child: Image.asset("assets/spell_background.png")
            ),
          ),
        ),
      ],
    );
  }
}