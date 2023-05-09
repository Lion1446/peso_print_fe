import 'package:flutter/material.dart';

import '../constants.dart';

class SuccessPrintJob extends StatefulWidget {
  const SuccessPrintJob({Key? key, required this.queueCode}) : super(key: key);
  final String queueCode;
  @override
  State<SuccessPrintJob> createState() => _SuccessPrintJobState();
}

class _SuccessPrintJobState extends State<SuccessPrintJob>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // Total duration of the timer
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
    return AlertDialog(
      content: SizedBox(
        width: 765,
        height: 900,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 650,
              height: 165,
              child: Text(
                'Your document has been added to the Print Job Successfully.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: 280,
              height: 280,
              child: Stack(
                children: [
                  Center(
                    child: Image.asset(
                      'assets/images/queue_circle.png',
                      width: 280,
                      height: 280,
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.queueCode,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 90,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          "QUEUE CODE",
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w300,
                              fontSize: 20,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'Take note of your queue number and please wait for your turn to pay.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 30,
                color: primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 90,
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                width: 565,
                height: 60,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Text(
                    'Done',
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
                        'Closes automatically in ${(10 - (10 * _controller.value)).toInt()} seconds',
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
      ),
    );
  }
}
