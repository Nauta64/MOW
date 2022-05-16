import 'package:MindOfWords/Models/rankingW.dart';
import 'package:MindOfWords/Models/rankingW.dart';
import 'package:MindOfWords/Wordle/domain.dart';

class ListRanking {
  final List<RankingW>? rank;

  const ListRanking({this.rank});

  factory ListRanking.fromJson(Map<String, dynamic> json){
    return ListRanking(
      rank : json['statWordle'],

      //Role_Id : json['role_Id'],
    );
  }

  Map toJson() => {
    'statWordle': rank,

  };
//u.Role_Id = userResponse['role_Id'];
}