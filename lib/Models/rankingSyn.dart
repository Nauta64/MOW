import 'package:MindOfWords/Spell/domain.dart';
import 'package:MindOfWords/Wordle/domain.dart';

import '../Synonyms/domain.dart';

class RankingSyn {
  String UserName;
  SynStats StatS;
  String img;

  RankingSyn(this.UserName, this.StatS, this.img);

  RankingSyn.fromJson(Map<String, dynamic> json)
      : UserName = json['userName'],
        StatS = json['stat'] = SynStats.fromJson(json['stat']),
        img = json['img'];
      //Role_Id : json['role_Id'],



  Map toJson() => {
    'userName': UserName,
    'stat': StatS,
    'img': img,
  };
//u.Role_Id = userResponse['role_Id'];
}