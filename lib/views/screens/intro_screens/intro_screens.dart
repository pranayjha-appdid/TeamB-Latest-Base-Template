import 'package:flutter/material.dart';

class IntroScreens extends StatelessWidget {
  const IntroScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return Text('Test');
      },
    ));
  }
}
