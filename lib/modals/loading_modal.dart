import 'package:flutter/material.dart';
import 'package:peso_print_vendo_fe/constants.dart';

class LoadingModal extends StatelessWidget {
  const LoadingModal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text(
            "Loading Data",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 24,
            ),
          ),
          SizedBox(
            height: 50,
          ),
          Center(
            child: SizedBox(
              width: 100,
              height: 100,
              child: CircularProgressIndicator(
                color: primaryColor,
                strokeWidth: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
