import 'package:flutter/material.dart';

import '../constants.dart';

class ErrorFlashDriveModal extends StatefulWidget {
  const ErrorFlashDriveModal({Key? key}) : super(key: key);

  @override
  State<ErrorFlashDriveModal> createState() => _ErrorFlashDriveModalState();
}

class _ErrorFlashDriveModalState extends State<ErrorFlashDriveModal>
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
        height: 630,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.usb_off_rounded,
                  size: 96,
                  color: Colors.red[600],
                ),
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  'ERROR',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 48,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 80,
            ),
            const SizedBox(
              width: 650,
              height: 165,
              child: Text(
                'No Flashdrive has been detected. Please check the integrity of the drive and try again.',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  fontSize: 36,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 60,
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
