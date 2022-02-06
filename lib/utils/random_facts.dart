import 'dart:convert';
import 'dart:developer';

import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/random_facts_model.dart';

///HTTP link to get random facts
///'http://randomuselessfact.appspot.com/random.json?language=en'

class RandomFacts {
  Future<RandomFactsModel?> fetchFact() async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult != ConnectivityResult.none) {
      try {
        final response =
            await http.get(Uri.http(urlRandomFacts, pathRandomFacts));
        final parsedJson = jsonDecode(response.body);

        if (response.statusCode == 200) {
          return RandomFactsModel.fromJson(parsedJson);
        }
      } catch (e) {
        log(e.toString());
        return null;
      }
    }
    return null;
  }
}
