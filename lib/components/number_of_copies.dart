import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:peso_print_vendo_fe/providers/print_setting_provider.dart';
import 'package:provider/provider.dart';

import '../constants.dart';

class NumberOfCopiesCard extends StatelessWidget {
  const NumberOfCopiesCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final printSettingProvider = Provider.of<PrintSettingProvider>(context);
    return Container(
      width: 340,
      height: 105,
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
      child: Row(
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
                'Copies',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.w400,
                  color: secondaryColor,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.remove),
                    onPressed: printSettingProvider.decrementCopies,
                  ),
                  SizedBox(width: 8),
                  Consumer<PrintSettingProvider>(
                    builder: (context, value, child) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Text(
                          value.numberOfCopies.toString(),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.add),
                    onPressed: printSettingProvider.incrementCopies,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
