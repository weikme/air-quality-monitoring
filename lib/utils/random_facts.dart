import 'dart:convert';
import 'dart:developer';

import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as httpConnector;

class RandomFacts {
  String httpMyLink =
      'http://randomuselessfact.appspot.com/random.json?language=en';

  Future<String?> fetchFact() async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult != ConnectivityResult.none) {
      try {
        final response = await httpConnector.get(Uri.http(
            'randomuselessfact.appspot.com', '/random.json?language=en'));
        final parsedJson = jsonDecode(response.body);
        log(response.toString());
        log(response.body.toString());
        log(response.statusCode.toString());
        log(parsedJson["text"]);
        if (response.statusCode == 200) {
          return parsedJson["text"];
        }
      } catch (e) {
        log(e.toString());
        return null;
      }
    }
    return null;
  }
}
