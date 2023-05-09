import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../providers/print_setting_provider.dart';

class ColorModeCard extends StatefulWidget {
  const ColorModeCard({Key? key}) : super(key: key);

  @override
  State<ColorModeCard> createState() => _ColorModeCardState();
}

class _ColorModeCardState extends State<ColorModeCard> {
  late Widget selectedWidget;
  bool isClicked = false;

  Widget coloredPrint = SizedBox(
    height: 105,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: 10,
        ),
        Image.asset('assets/images/colored_print.png'),
        const SizedBox(
          width: 35,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Colored',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: secondaryColor,
              ),
            ),
            Text(
              'Standard',
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

  Widget grayscalePrint = SizedBox(
    height: 105,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          width: 10,
        ),
        Image.asset('assets/images/black_and_white_image.png'),
        const SizedBox(
          width: 35,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Grayscale',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.w400,
                color: secondaryColor,
              ),
            ),
            Text(
              'Black and white',
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

  @override
  void initState() {
    selectedWidget = coloredPrint;
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
            height: isClicked ? 105 * 2 : 105,
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
                            if (selectedWidget == coloredPrint) {
                              selectedWidget = grayscalePrint;
                              printSettingProvider.updateIsColored(false);
                            } else {
                              selectedWidget = coloredPrint;
                              printSettingProvider.updateIsColored(true);
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
                          child: selectedWidget == coloredPrint
                              ? grayscalePrint
                              : coloredPrint,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: SizedBox(
                    width: 320,
                    child: Row(
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
