import 'dart:ui';

import 'package:MindOfWords/Spell/constants.dart';
import 'package:MindOfWords/Spell/text_to_speech.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDialogSelectAvatar extends StatefulWidget {
  final String title, descriptions, text, text2;
  Image img;

  CustomDialogSelectAvatar(
      {Key? key,
      required this.title,
      required this.descriptions,
      required this.text,
      required this.img,
      required this.text2})
      : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogSelectAvatar> {
  List<_Photo> _photos(BuildContext context) {
    return [
      _Photo(
        assetName: 'assets/avatars/cerdo.png',
      ),
      _Photo(
        assetName: 'assets/avatars/ciervo.png',
      ),
      _Photo(
        assetName: 'assets/avatars/gallina.png',
      ),
      _Photo(
        assetName: 'assets/avatars/gato.png',
      ),
      _Photo(
        assetName: 'assets/avatars/mono.png',
      ),
      _Photo(
        assetName: 'assets/avatars/panda.png',
      ),
      _Photo(
        assetName: 'assets/avatars/perro.png',
      ),
      _Photo(
        assetName: 'assets/avatars/vaca.png',
      ),
      _Photo(
        assetName: 'assets/avatars/zorro.png',
      ),

    ];
  }

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

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: Constants.padding,
              top: Constants.avatarRadius + Constants.padding,
              right: Constants.padding,
              bottom: Constants.padding),
          margin: EdgeInsets.only(top: Constants.avatarRadius),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(Constants.padding),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                widget.title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Container(

                child: GridView.count(
                  shrinkWrap: true,
                  restorationId: 'grid_view_demo_grid_offset',
                  crossAxisCount: 3,
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  padding: const EdgeInsets.all(8),
                  childAspectRatio: 1,
                  children: _photos(context).map<Widget>((photo) {
                    return image(photo.assetName);
                  }).toList(),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                        onPressed: () {
                          //===== TANCAR DIALOG =======
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                          //===== TANCAR SPELL =======
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          widget.text2,
                          style: TextStyle(fontSize: 18),
                        )),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FlatButton(
                        onPressed: () {
                          //===== TANCAR DIALOG =======
                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }
                          //====== REINICIAR VIEW =====
                          Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        SpellApp(),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ));
                        },
                        child: Text(
                          widget.text,
                          style: TextStyle(fontSize: 18),
                        )),
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
                borderRadius:
                    BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                child: Image.asset("assets/spell_background.png")),
          ),
        ),
      ],
    );
  }


  Widget image(String img) =>Material(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      clipBehavior: Clip.antiAlias,
      child: IconButton(
        icon: Image.asset(img),
        iconSize: 100,
        onPressed: () {
          setState(() {

            widget.img = Image.asset(img);
            print(widget.img);
          });
        },
      )
  );
}

class _Photo {
  _Photo({
    required this.assetName,
  });

  final String assetName;
}

