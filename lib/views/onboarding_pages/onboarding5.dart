import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../color_palette.dart';

class Onboarding5 extends StatelessWidget {
  const Onboarding5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: SvgPicture.asset('assets/Gibalica_training.svg'),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Center(
                  child: AutoSizeText(
                    "Trening".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: ColorPalette.darkBlue),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: AutoSizeText(
                    "IgraSVježbamaZaRukeINoge".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 40, color: ColorPalette.darkBlue),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
