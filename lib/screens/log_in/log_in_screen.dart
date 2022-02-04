import 'package:flutter/material.dart';

import '../home/home_screen.dart';

class LogInScreen extends StatelessWidget {
  const LogInScreen({Key? key}) : super(key: key);

  static const String id = 'log_in_screen';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ThemeData.dark().primaryColor,
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, HomeScreen.id);
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('PushMe'),
          ),
        ),
      ),
    );
  }
}
