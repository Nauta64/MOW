import 'package:MindOfWords/Wordle/domain.dart';

class RankingW {
  String UserName;
  Stats StatW;
  String img;

  RankingW(this.UserName, this.StatW, this.img);

  RankingW.fromJson(Map<String, dynamic> json)
      : UserName = json['userName'],
        StatW = json['stat'] = Stats.fromJson(json['stat']),
        img = json['img'];
      //Role_Id : json['role_Id'],



  Map toJson() => {
    'userName': UserName,
    'stat': StatW,
    'img': img,
  };
//u.Role_Id = userResponse['role_Id'];
}