import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../constants.dart';

class DocumentPages extends StatefulWidget {
  const DocumentPages({Key? key, required this.pages, required this.fileName})
      : super(key: key);
  final List<dynamic> pages;
  final String fileName;
  @override
  State<DocumentPages> createState() => DocumentPagesState();
}

class DocumentPagesState extends State<DocumentPages> {
  final pageController = PageController();
  int page = 1;
  List<Widget> pageWidgets = [];
  @override
  void initState() {
    for (String page in widget.pages) {
      pageWidgets.add(Image.memory(base64Decode(page)));
    }
    super.initState();
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
          Text(
            widget.fileName.split("\\").last,
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 50,
                color: Color(0XFF455A64)),
          ),
          const Text(
            'Filename',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 24,
                color: Color(0XFF455A64)),
          ),
          SizedBox(
            width: size.width * 0.9,
            height: 1000,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 30.0),
                  child: InkWell(
                    onTap: () {
                      pageController.previousPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut);
                    },
                    child: const Icon(
                      Icons.keyboard_arrow_left_rounded,
                      size: 80,
                      color: primaryColor,
                    ),
                  ),
                ),
                Expanded(
                    child: PageView(
                  controller: pageController,
                  children: pageWidgets,
                  onPageChanged: (value) {
                    setState(() {
                      page = value + 1;
                    });
                  },
                )),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0),
                  child: InkWell(
                    onTap: () {
                      pageController.nextPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut);
                    },
                    child: const Icon(
                      Icons.keyboard_arrow_right_rounded,
                      size: 90,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Page $page of ${pageWidgets.length}',
            style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 24,
                color: Color(0XFF455A64)),
          ),
          const SizedBox(
            height: 50,
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: 565,
              height: 60,
              decoration: BoxDecoration(
                  color: primaryColor, borderRadius: BorderRadius.circular(10)),
              child: const Center(
                child: Text(
                  'Exit Preview',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 28,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
