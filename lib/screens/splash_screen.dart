// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:peso_print_vendo_fe/constants.dart';
import 'package:peso_print_vendo_fe/modals/error_flashdrive_modal.dart';
import 'package:peso_print_vendo_fe/modals/loading_modal.dart';
import 'package:peso_print_vendo_fe/screens/print_setting_kiosk.dart';
import 'package:peso_print_vendo_fe/screens/upload_via_phone_instructions.dart';
import 'package:provider/provider.dart';

import '../functions.dart';
import '../modals/directory_modal.dart';
import '../providers/print_setting_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Future<List<Map<String, dynamic>>> flashDriveData;

  @override
  void initState() {
    super.initState();
  }

  Future<String?> _showDirectoryModal() async {
    String? resp = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: getFlashDriveStructure(),
          builder: (BuildContext context,
              AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingModal();
            } else if (snapshot.hasError) {
              return const ErrorFlashDriveModal();
            } else {
              return DirectoryModal(
                  data: snapshot.data!.cast<Map<String, dynamic>>());
            }
          },
        ); // Pass the JSON data to DirectoryModal
      },
    );
    return resp;
  }

  bool hasClicked = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final printSettingProvider = Provider.of<PrintSettingProvider>(context);
    return Scaffold(
      body: InkWell(
        onTap: () {
          setState(() {
            hasClicked = true;
          });
        },
        child: Stack(
          children: [
            Positioned(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeInOutExpo,
                opacity: hasClicked ? 1 : 0,
                child: Image.asset(
                  'assets/images/top_banner.png',
                  width: size.width,
                ),
              ),
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeInOut,
              top: hasClicked ? -2000 : 0,
              left: 0,
              child: Image.asset(
                'assets/images/splash_screen.png',
                width: size.width,
              ),
            ),
            Center(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeInOutExpo,
                opacity: hasClicked ? 1 : 0,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Upload a file',
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
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: hasClicked
                              ? () {
                                  Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder: (context, animation,
                                          secondaryAnimation) {
                                        return const PhoneUploadInstructions();
                                      },
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        // Customize the page transition animation here
                                        return FadeTransition(
                                          opacity: Tween<double>(
                                            begin: 0.0,
                                            end: 1.0,
                                          ).animate(animation),
                                          child: child,
                                        );
                                      },
                                    ),
                                  );
                                }
                              : null,
                          child: Image.asset(
                            'assets/images/via_phone_button.png',
                            width: 325,
                          ),
                        ),
                        const SizedBox(
                          width: 45,
                        ),
                        InkWell(
                          onTap: hasClicked
                              ? () async {
                                  showDialog(
                                    context: context,
                                    builder: (context) => const LoadingModal(),
                                  );
                                  String? file = await _showDirectoryModal();
                                  if (file != null) {
                                    Map<String, dynamic> response =
                                        await uploadFileFromDrive(file);
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            PrintSettingKiosk(
                                          data: response,
                                        ),
                                      ),
                                    );
                                  } else {
                                    Navigator.pop(context);
                                  }
                                }
                              : null,
                          child: Image.asset(
                            'assets/images/via_usb_button.png',
                            width: 325,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 82,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeInOut,
                opacity: hasClicked ? 0 : 1,
                child: const Text(
                  'Touch anywhere to start',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 62,
                    fontWeight: FontWeight.w500,
                    color: primaryColor,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
