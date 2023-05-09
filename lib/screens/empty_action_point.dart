import 'package:flutter/material.dart';

class EmptyActionPoint extends StatelessWidget {
  const EmptyActionPoint({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset('assets/images/top_banner.png'),
        ],
      ),
    );
  }
}
