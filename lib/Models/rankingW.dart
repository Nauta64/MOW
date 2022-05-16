import 'package:MindOfWords/Wordle/domain.dart';

class RankingW {
  final String? UserName;
  final List<Stats>? StatW;
  final String? img;

  const RankingW({this.UserName, this.StatW, this.img});

  factory RankingW.fromJson(Map<String, dynamic> json){
    return RankingW(
      UserName : json['userName'],
      StatW : json['stat'],
      img : json['img'],
      //Role_Id : json['role_Id'],
    );
  }

  Map toJson() => {
    'userName': UserName,
    'stat': StatW,
    'img': img,
  };
//u.Role_Id = userResponse['role_Id'];
}