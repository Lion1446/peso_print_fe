import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:peso_print_vendo_fe/constants.dart';
import 'package:provider/provider.dart';

import '../providers/print_setting_provider.dart';

class PageToPrintCard extends StatefulWidget {
  const PageToPrintCard({Key? key}) : super(key: key);

  @override
  State<PageToPrintCard> createState() => PageToPrintCardState();
}

class PageToPrintCardState extends State<PageToPrintCard> {
  bool isClicked = false;
  late Widget selectedWidget;

  Widget printAllPages = SizedBox(
    height: 105,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: 10,
        ),
        const Icon(
          Icons.copy,
          size: 48,
          color: secondaryColor,
        ),
        const SizedBox(
          width: 35,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Print All Pages',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: secondaryColor,
              ),
            ),
            Text(
              'The whole thing',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: secondaryColor.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  Widget customPrint = SizedBox(
    height: 105,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: 10,
        ),
        const Icon(
          Icons.copy,
          size: 48,
          color: secondaryColor,
        ),
        const SizedBox(
          width: 35,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Custom Print',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: secondaryColor,
              ),
            ),
            Row(
              children: [
                Text(
                  'Pages: ',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: secondaryColor.withOpacity(0.5),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  );

  @override
  void initState() {
    selectedWidget = printAllPages;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final printSettingProvider = Provider.of<PrintSettingProvider>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: () {
            setState(() {
              isClicked = !isClicked;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            width: 340,
            height: isClicked
                ? 105 * 2
                : selectedWidget == customPrint
                    ? 320
                    : 105,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 3),
                  blurRadius: 3,
                  color: Colors.black.withOpacity(0.25),
                ),
              ],
              color: Colors.white,
            ),
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  top: isClicked ? 105 : 0,
                  child: Visibility(
                    visible: isClicked,
                    child: AnimatedOpacity(
                      opacity: isClicked ? 1.0 : 0.0,
                      curve: Curves.easeInOut,
                      duration: const Duration(milliseconds: 500),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            if (selectedWidget == printAllPages) {
                              selectedWidget = customPrint;
                            } else {
                              selectedWidget = printAllPages;
                              printSettingProvider.checkAllPages();
                            }
                            isClicked = false;
                          });
                        },
                        child: Container(
                          height: 105,
                          width: 340,
                          decoration: const BoxDecoration(
                            color: Color(0XFFBAC8BD),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            ),
                          ),
                          child: selectedWidget == printAllPages
                              ? customPrint
                              : printAllPages,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    width: 320,
                    height: selectedWidget == customPrint ? 320 : 105,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            selectedWidget,
                            Icon(
                              isClicked
                                  ? Icons.keyboard_arrow_up_outlined
                                  : Icons.keyboard_arrow_down_outlined,
                              color: secondaryColor,
                            ),
                          ],
                        ),
                        Expanded(
                          child: Visibility(
                            visible: !isClicked,
                            child: Scrollbar(
                              child: ListView.builder(
                                itemCount: printSettingProvider.numberOfPages,
                                itemBuilder: (BuildContext context, int index) {
                                  final pageNumber = index + 1;
                                  return InkWell(
                                    onTap: () {
                                      printSettingProvider.toggleCheckedPages(
                                          index,
                                          !printSettingProvider
                                              .checkedPages[index]);
                                    },
                                    child: Container(
                                      color: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 15),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Page $pageNumber',
                                            style: const TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                              color: secondaryColor,
                                            ),
                                          ),
                                          Checkbox(
                                            value: printSettingProvider
                                                .checkedPages[index],
                                            onChanged: (bool? val) {
                                              printSettingProvider
                                                  .toggleCheckedPages(
                                                      index, val!);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
