import 'package:MindOfWords/Spell/domain.dart';
import 'package:MindOfWords/Wordle/domain.dart';

class RankingSpell {
  String UserName;
  SpellStats StatS;
  String img;

  RankingSpell(this.UserName, this.StatS, this.img);

  RankingSpell.fromJson(Map<String, dynamic> json)
      : UserName = json['userName'],
        StatS = json['stat'] = SpellStats.fromJson(json['stat']),
        img = json['img'];
      //Role_Id : json['role_Id'],



  Map toJson() => {
    'userName': UserName,
    'stat': StatS,
    'img': img,
  };
//u.Role_Id = userResponse['role_Id'];
}