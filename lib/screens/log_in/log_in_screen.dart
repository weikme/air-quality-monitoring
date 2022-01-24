import 'package:cursach_diagrams/screens/home/home_screen.dart';
import 'package:flutter/material.dart';

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
            Navigator.pushNamed(context, HomeScreen.id);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('PushMe'),
          ),
        ),
      ),
    );
  }
}
