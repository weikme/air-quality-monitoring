import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;

class RandomFacts {
  Uri factUri =
      Uri(path: 'http://randomuselessfact.appspot.com/random.txt?language=en');

  Future<String?> fetchFact() async {
    ConnectivityResult connectivityResult =
        await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      try {
        final response = await http.get(factUri);
        if (response.statusCode == 200) {
          return response.body.toString();
        }
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
