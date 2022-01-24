import 'package:cursach_diagrams/screens/log_in/log_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../../bloc/air_condition_bloc.dart';
import '../global/loader_widget.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash_screen';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<AirConditionBloc>().add(
          GetAirConditionValueByCityEvent(),
        );
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushNamed(context, LogInScreen.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeData.dark().primaryColor,
      child: LoaderWidget(),
    );
  }
}
