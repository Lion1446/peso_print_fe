import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../constants.dart';

class PrintJobCard extends StatelessWidget {
  const PrintJobCard({Key? key, required this.printJob}) : super(key: key);
  final Map<String, dynamic> printJob;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 105,
      margin: const EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 3),
            blurRadius: 3,
            color: Colors.black.withOpacity(0.25),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            printJob["absolute_file_path"].toString().contains(".pdf")
                ? 'assets/images/pdf_icon.png'
                : 'assets/images/docx_icon.png',
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  printJob["queue_code"],
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: secondaryColor,
                  ),
                ),
                Text(
                  printJob["absolute_file_path"]
                      .toString()
                      .split("\\")
                      .last
                      .split("(separator)")
                      .last,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: secondaryColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
