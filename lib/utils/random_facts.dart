import 'dart:convert';
import 'dart:developer';

import 'package:connectivity/connectivity.dart';
import 'package:cursach_diagrams/models/random_facts_model.dart';
import 'package:http/http.dart' as http_connector;

///HTTP link to get random facts
///'http://randomuselessfact.appspot.com/random.json?language=en'

class RandomFacts {
  static const String urlRandomFacts = 'randomuselessfact.appspot.com';
  static const String pathRandomFacts = '/random.json?language=en';

  Future<RandomFactsModel?> fetchFact() async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());

    if (connectivityResult != ConnectivityResult.none) {
      try {
        final response =
            await http_connector.get(Uri.http(urlRandomFacts, pathRandomFacts));
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
