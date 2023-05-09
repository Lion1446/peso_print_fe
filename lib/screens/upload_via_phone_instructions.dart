import 'package:flutter/material.dart';

import '../constants.dart';

class PhoneUploadInstructions extends StatefulWidget {
  const PhoneUploadInstructions({Key? key}) : super(key: key);

  @override
  State<PhoneUploadInstructions> createState() =>
      _PhoneUploadInstructionsState();
}

class _PhoneUploadInstructionsState extends State<PhoneUploadInstructions>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60), // Total duration of the timer
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Timer has expired, call your function here
        Navigator.pop(context);
        // Call your function or perform any other action here
      }
    });

    _controller.forward();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        children: [
          Image.asset(
            'assets/images/top_banner.png',
            width: size.width,
          ),
          const Text(
            'Upload File Via Phone',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 75,
              fontWeight: FontWeight.w500,
              color: secondaryColor,
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          SizedBox(
            width: 780,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/images/step_1.png'),
                Image.asset('assets/images/step_2.png'),
                Image.asset('assets/images/step_3.png'),
              ],
            ),
          ),
          const SizedBox(
            height: 70,
          ),
          SizedBox(
            width: 780,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset('assets/images/step_4.png'),
                Image.asset('assets/images/step_5.png'),
                Image.asset('assets/images/step_6.png'),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: 565,
              height: 60,
              margin: EdgeInsets.only(top: 30),
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(10)),
              child: const Center(
                child: Text(
                  'Okay',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 30, bottom: 10),
            height: 125,
            width: 565,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      clipBehavior: Clip.antiAlias,
                      height: 10,
                      child: LinearProgressIndicator(
                        value: 1.0 - _controller.value,
                        backgroundColor: const Color(0XFF777676),
                        valueColor:
                            const AlwaysStoppedAnimation<Color>(primaryColor),
                      ),
                    ),
                    Text(
                      'Closes automatically in ${(60 - (60 * _controller.value)).toInt()} seconds',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: primaryColor,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
