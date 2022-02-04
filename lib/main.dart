import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'bloc/air_condition_bloc.dart';
import 'hive_models/city_model.dart';
import 'hive_models/list_of_city_models.dart';
import 'screens/home/details_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/log_in/log_in_screen.dart';
import 'screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(CityModelAdapter());
  Hive.registerAdapter(ListOfCityModelsAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AirConditionBloc>(
          create: (BuildContext context) => AirConditionBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        initialRoute: SplashScreen.id,
        routes: {
          SplashScreen.id: (BuildContext context) => const SplashScreen(),
          LogInScreen.id: (BuildContext context) => const LogInScreen(),
          HomeScreen.id: (BuildContext context) => HomeScreen(),
          DetailsScreen.id: (BuildContext context) => const DetailsScreen(),
        },
      ),
    );
  }
}
