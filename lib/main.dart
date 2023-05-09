import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:peso_print_vendo_fe/constants.dart';
import 'package:peso_print_vendo_fe/modals/loading_modal.dart';
import 'package:peso_print_vendo_fe/providers/print_setting_provider.dart';
import 'package:peso_print_vendo_fe/screens/print_queue.dart';
import 'package:peso_print_vendo_fe/screens/splash_screen.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'screens/print_setting_kiosk.dart';
import 'screens/show_document_pages.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => PrintSettingProvider())
      ],
      child: const App(),
    ),
  );
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final printJobStream =
      WebSocketChannel.connect(Uri.parse("$wsURL/print_job_stream"));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StreamBuilder(
          stream: printJobStream.stream,
          builder: (context, snapshot) {
            final jsonData = json.decode(snapshot.data.toString());
            if (snapshot.hasData) {
              if (jsonData["print_jobs"].isNotEmpty) {
                return PrintQueue(
                  printJobs: (jsonData["print_jobs"] as List)
                      .cast<Map<String, dynamic>>(),
                );
              } else {
                return const SplashScreen();
              }
            } else {
              return Scaffold(
                body: Center(
                  child: Column(
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
                ),
              );
            }
          }),
      debugShowCheckedModeBanner: false,
    );
  }
}
