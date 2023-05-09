import 'package:flutter/material.dart';
import 'package:peso_print_vendo_fe/components/print_job_card.dart';
import 'package:peso_print_vendo_fe/constants.dart';
import 'package:peso_print_vendo_fe/modals/proceed_payment_modal.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../functions.dart';
import '../modals/directory_modal.dart';
import '../modals/error_flashdrive_modal.dart';
import '../modals/loading_modal.dart';
import 'print_setting_kiosk.dart';

class PrintQueue extends StatefulWidget {
  const PrintQueue({Key? key, required this.printJobs}) : super(key: key);
  final List<Map<String, dynamic>> printJobs;
  @override
  State<PrintQueue> createState() => _PrintQueueState();
}

class _PrintQueueState extends State<PrintQueue>
    with SingleTickerProviderStateMixin {
  Future<String?> _showProceedToPaymentModal(
      Map<String, dynamic> printJob) async {
    String? resp = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return ProceedToPaymentModal(
            printJob: printJob,
          );
        });
    return resp;
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

  late AnimationController _controller;
  int secondsRemaining = 120;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 120), // Total duration of the timer
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        // Timer has expired, call your function here
        // Navigator.pop(context);
        // Call your function or perform any other action here
      }
    });

    _controller.forward();
    _controller.addListener(() {
      setState(() {
        secondsRemaining = 120 - _controller.lastElapsedDuration!.inSeconds;
      });
    });
    super.initState();
  }

  String formatCountdown(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    String formattedMinutes = minutes.toString().padLeft(2, '0');
    String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');
    return '$formattedMinutes:$formattedSeconds';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              height: size.height,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/sidepanel.png"),
                  fit: BoxFit.fill,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 240,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: widget.printJobs.length,
                      itemBuilder: (context, index) {
                        return PrintJobCard(printJob: widget.printJobs[index]);
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () async {
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
                    },
                    child: Container(
                      height: 80,
                      margin: const EdgeInsets.only(bottom: 100),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            offset: const Offset(0, 3),
                            blurRadius: 3,
                            color: Colors.black.withOpacity(0.25),
                          ),
                        ],
                        color: primaryColor,
                      ),
                      child: const Center(
                          child: Text(
                        'Upload File',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      )),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 300),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text(
                          'UP NEXT',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 100,
                            fontWeight: FontWeight.w300,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          widget.printJobs.first["queue_code"],
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 200,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 400,
                      height: 400,
                      child: SfRadialGauge(
                        axes: [
                          RadialAxis(
                            startAngle: -90,
                            endAngle: 270,
                            minimum: 0,
                            maximum: 120,
                            showLabels: false,
                            showTicks: false,
                            interval: 10,
                            axisLineStyle: const AxisLineStyle(
                              thickness: 0.15,
                              thicknessUnit: GaugeSizeUnit.factor,
                            ),
                            pointers: <GaugePointer>[
                              RangePointer(
                                value: 120 - (_controller.value * 100),
                                cornerStyle: CornerStyle.bothCurve,
                                width: 30,
                                // color: primaryColor,
                                gradient: const SweepGradient(colors: <Color>[
                                  Color(0xFF20692D),
                                  Color(0xFF357D34),
                                  Color(0xFF4CA543),
                                  Color(0xFF5CBE54),
                                  Color(0xFF6CD864),
                                ], stops: <double>[
                                  0,
                                  0.25,
                                  0.5,
                                  0.75,
                                  1
                                ]),
                              )
                            ],
                            annotations: [
                              GaugeAnnotation(
                                positionFactor: 0.1,
                                widget: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Print job cancels in",
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      formatCountdown(secondsRemaining),
                                      style: const TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 80,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            _showProceedToPaymentModal(widget.printJobs.first);
                          },
                          child: Container(
                            width: 565,
                            height: 75,
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Center(
                              child: Text(
                                'Proceed to Payment',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Container(
                            width: 565,
                            height: 75,
                            decoration: BoxDecoration(
                                color: Color(0XFF878484),
                                borderRadius: BorderRadius.circular(10)),
                            child: const Center(
                              child: Text(
                                'Cancel Print Job',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 30,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
