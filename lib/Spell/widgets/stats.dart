import 'dart:math';
import 'package:MindOfWords/Spell/domain.dart';
import 'package:MindOfWords/Spell/text_to_speech.dart';
import 'package:MindOfWords/main.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../constants.dart';
import '../services/stats_service.dart';


class StatsWidget extends StatefulWidget {
  StatsWidget(this._stats, this._close, this._newGame, {Key? key})
      : super(key: key);

  final SpellStats _stats;
  final Function _close;
  final Function _newGame;

  SpellStats get stats => _stats;

  Function get close => _close;

  Function get newGame => _newGame;

  @override
  State<StatefulWidget> createState() => _StatsState();
}

class _StatsState extends State<StatsWidget> {
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
          padding: EdgeInsets.only(left: Constants.padding,top: 0
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
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () => {
                      //===== TANCAR DIALOG =======
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context)
                      }
                    },
                    child: const Text("X",
                        style: TextStyle(fontSize: 20))),
              ),

              const Center(
                  child: Text(
                    "STATISTICS",
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  )),
              Padding(
                padding:
                const EdgeInsets.fromLTRB(10, 20, 10, 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 4, right: 4),
                      child: Column(
                        children: [
                          Text(
                            widget._stats.played.toString(),
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
                            widget._stats.percentWon.toString(),
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
                            widget._stats.streak.current
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
                            widget._stats.streak.max.toString(),
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
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 5, left: 5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => SpellApp()),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text('PLAY AGAIN',
                                    style: TextStyle(
                                      fontWeight:
                                      FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 13.3,
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      VerticalDivider(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary,
                        width: 2,
                        indent: 2,
                        endIndent: 2,
                        thickness: 2,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 5, left: 5),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.green),
                            onPressed: () {

                              Share.share(
                                  'MOW ${widget._stats.won} }',
                                  subject: 'MOW Synonyms/6');
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Text('SHARE',
                                    style: TextStyle(
                                      fontWeight:
                                      FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 13.3,
                                    )),
                                SizedBox(
                                  width: 5,
                                ),
                                Icon(
                                  Icons.share,
                                  color: Colors.white,
                                  size: 24.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

      ],
    );
  }

}
