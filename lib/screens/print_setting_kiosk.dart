import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:peso_print_vendo_fe/components/color_mode_card.dart';
import 'package:peso_print_vendo_fe/components/number_of_copies.dart';
import 'package:peso_print_vendo_fe/components/page_to_print_card.dart';
import 'package:peso_print_vendo_fe/constants.dart';
import 'package:peso_print_vendo_fe/modals/success_print_job.dart';
import 'package:peso_print_vendo_fe/providers/print_setting_provider.dart';
import 'package:peso_print_vendo_fe/screens/show_document_pages.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../components/page_size_card.dart';
import '../modals/loading_modal.dart';

class PrintSettingKiosk extends StatelessWidget {
  const PrintSettingKiosk({Key? key, required this.data}) : super(key: key);
  final Map<String, dynamic> data;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final printSettingProvider = Provider.of<PrintSettingProvider>(context);
    printSettingProvider.numberOfPages = data["page_count"];
    if (printSettingProvider.checkedPages.isEmpty) {
      for (int i = 0; i < printSettingProvider.numberOfPages; i++) {
        printSettingProvider.checkedPages.add(true);
      }
    }

    Future<String?> _showLoadingData() async {
      String? resp = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return const LoadingModal();
        },
      );
      return resp;
    }

    Future<String?> _showSuccessPrintJob(String queueCode) async {
      String? resp = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SuccessPrintJob(queueCode: queueCode);
        },
      );
      return resp;
    }

    Future addPrintJob() async {
      Map<String, dynamic> printJob = {
        "absolute_file_path": data["absolute_file_path"],
        "amount_payable": printSettingProvider.amount,
        "copies": printSettingProvider.numberOfCopies,
        "is_colored": printSettingProvider.isColored,
        "pages_to_print": printSettingProvider.checkedPages.join(","),
        "paper_size": printSettingProvider.paperSize,
      };
      String url = '$baseURL/create_print_job_flashdrive';
      final response =
          await http.post(Uri.parse(url), body: json.encode(printJob));
      final decoded = json.decode(response.body) as Map<String, dynamic>;
      return decoded;
    }

    printSettingProvider.computeAmount();
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      'assets/images/top_banner.png',
                      width: size.width,
                    ),
                    SizedBox(
                      width: 460,
                      height: 600,
                      child: Stack(
                        children: [
                          Image.asset(
                            'assets/images/file_placeholder_blurred.png',
                            width: size.width,
                          ),
                          Center(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (BuildContext context) =>
                                        DocumentPages(
                                      pages: data["pages"],
                                      fileName: data["absolute_file_path"],
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                width: 350,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: primaryColor,
                                ),
                                child: const Center(
                                  child: Text(
                                    'Click to Preview',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 28,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 90, vertical: 50),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  NumberOfCopiesCard(),
                                  ColorModeCard(),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  PageToPrintCard(),
                                  PageSizeCard(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                width: size.width,
                height: 210,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(7, 0),
                      blurRadius: 9,
                      color: Colors.black.withOpacity(0.5),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Amount Payable:',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                            color: secondaryColor,
                          ),
                        ),
                        Consumer<PrintSettingProvider>(
                          builder: (context, value, child) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Text(
                                'Php ${value.amount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 28,
                                  fontWeight: FontWeight.w700,
                                  color: primaryColor,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              printSettingProvider.resetToDefault();
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0XFF878484),
                              ),
                              child: const Center(
                                  child: Text(
                                'Cancel Print Job',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              )),
                            ),
                          ),
                        ),
                        const SizedBox(width: 25),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              _showLoadingData();
                              final result = await addPrintJob();
                              Navigator.pop(context);
                              if (result["status"] == 200) {
                                await _showSuccessPrintJob(
                                    result["queue_code"]);
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: printSettingProvider.amount > 0
                                    ? primaryColor
                                    : Color(0XFF878484),
                              ),
                              child: const Center(
                                  child: Text(
                                'Add to Queue',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              )),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
