import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class ShowPagesToPrint extends StatefulWidget {
  const ShowPagesToPrint(
      {Key? key, required this.pages, required this.fileName})
      : super(key: key);
  final List<dynamic> pages;
  final String fileName;

  @override
  State<ShowPagesToPrint> createState() => _ShowPagesToPrintState();
}

class _ShowPagesToPrintState extends State<ShowPagesToPrint> {
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
    return AlertDialog(
      content: SizedBox(
        height: 1200,
        width: double.maxFinite,
        child: Column(
          children: [
            Text('File Name: ${widget.fileName.split("\\").last}'),
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
            SizedBox(
              height: 100,
              width: 300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      pageController.previousPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut);
                    },
                    child: Icon(Icons.keyboard_arrow_left_rounded),
                  ),
                  Text("Page $page"),
                  InkWell(
                    onTap: () {
                      pageController.nextPage(
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut);
                    },
                    child: Icon(Icons.keyboard_arrow_right_rounded),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
