import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:peso_print_vendo_fe/screens/payment.dart';

import '../constants.dart';

class ProceedToPaymentModal extends StatefulWidget {
  const ProceedToPaymentModal({Key? key, required this.printJob})
      : super(key: key);
  final Map<String, dynamic> printJob;
  @override
  State<ProceedToPaymentModal> createState() => _ProceedToPaymentModalState();
}

class _ProceedToPaymentModalState extends State<ProceedToPaymentModal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  bool isDone = false;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10), // Total duration of the timer
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Timer has expired, call your function here
        // Navigator.pop(context);
        setState(() {
          isDone = true;
        });
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
      content: Container(
        padding: EdgeInsets.only(top: 50),
        width: 760,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Please note that cash insertion into this vending machine is irreversible and non-refundable. Change will be dispensed if applicable. \n\nKindly ensure correct print settings and prepare cash amount prior to payment. \n\nThank you.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 30,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 100,
            ),
            InkWell(
              onTap: isDone
                  ? () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => Payment(
                            printJob: widget.printJob,
                          ),
                        ),
                      );
                    }
                  : null,
              child: Container(
                width: 565,
                height: 75,
                decoration: BoxDecoration(
                    color: isDone ? primaryColor : const Color(0XFF545654),
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Text(
                    'I Understand',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 30),
              height: 125,
              width: 565,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        'Will allow to continue in ${(10 - (10 * _controller.value)).toInt()} seconds',
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
