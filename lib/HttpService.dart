import 'dart:convert';
import 'package:MindOfWords/Synonyms/Models/Synonym.dart';
import 'package:http/http.dart';
import 'package:MindOfWords/Wordle/Models/Word.dart';

class HttpService {
  final String postsURL = "https://t1edtq.deta.dev/get5Word";
  // final String postsSynonyms = "http://172.16.24.4:5000/getSynonym";
  final String postsSynonyms = "https://t1edtq.deta.dev/getSynonym";

  Future<String> getPosts() async {
    Response res = await get(Uri.parse(postsURL));

    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);
      String word = body["word"];
      print(word);

      return word;
    } else {
      throw "Unable to retrieve posts.";
    }
  }

  Future<Synonym> getSynonyms() async {
    Response res = await get(Uri.parse(postsSynonyms));
    print(res);
    if (res.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(res.body);

      String word = body["word"];
      List<String> syn = List<String>.from(body["syn"]);
      print(word);
      print(syn);

      return Synonym(word: word, syn: syn);
    } else {
      throw "Unable to retrieve posts.";
    }
  }
}