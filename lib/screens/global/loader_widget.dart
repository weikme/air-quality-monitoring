import 'package:flutter/material.dart';

import 'loader_item_widget.dart';

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 128),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          LoaderItemWidget(
            color: Colors.purple,
            // size: size.value,
          ),
          LoaderItemWidget(
            color: Colors.blue,
            millisecondsAnimationDelay: 100,
            //     size: size.value,
          ),
          LoaderItemWidget(
            color: Colors.lightBlueAccent,
            millisecondsAnimationDelay: 200,
            //     size: size.value,
          ),
          LoaderItemWidget(
            color: Colors.tealAccent,
            millisecondsAnimationDelay: 300,
            //     size: size.value,
          ),
          LoaderItemWidget(
            color: Colors.pinkAccent,
            millisecondsAnimationDelay: 400,
            //    size: size.value,
          ),
        ],
      ),
    );
  }
}
