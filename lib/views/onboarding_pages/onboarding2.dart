import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../color_palette.dart';
import '../../controllers/settings_controller.dart';

class Onboarding2 extends StatelessWidget {
  const Onboarding2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var settingsController = Get.find<SettingsController>();

    return Column(
      children: [
        Expanded(
          child: Lottie.asset("assets/lotties/camera-roll.json"),
        ),
        Expanded(
          child: Center(
            child: AutoSizeText(
              "PrednjomIStražnjomKameromMožešSnimatiPokretTijela".tr,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 40,
                color: settingsController.isNormalContrast.isFalse ? Colors.yellow : ColorPalette.darkBlue,
                background: Paint()..color = settingsController.isNormalContrast.isFalse ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
