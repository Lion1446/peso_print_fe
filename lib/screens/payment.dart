import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class Payment extends StatelessWidget {
  const Payment({Key? key, required this.printJob}) : super(key: key);
  final Map<String, dynamic> printJob;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Image.asset(
              'assets/images/top_banner.png',
              width: size.width,
            ),
          ],
        ),
      ),
    );
  }
}
