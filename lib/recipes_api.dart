import 'dart:convert';
import 'package:http/http.dart' as http;

import 'hits.dart';

class Recipie {
  List<Hits> hits = [];

  Future<void> getReceipe() async {
    var client = http.Client();
    var url =
        "https://api.edamam.com/search?q=banana&app_id=75862168&app_key=eaa751eb66608b026e8916cd01aa2414";
    var response = await client.get(Uri.parse(url));

    var jsonData = jsonDecode(response.body);
    jsonData["hits"].forEach((element) {
      Hits hits = Hits(
        recipeModel: element['recipe'],
      );
      // hits.recipeModel = add(Hits.fromMap(hits.recipeModel));
    });
  }
}