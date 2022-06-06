import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:gibalica/color_palette.dart';
import 'package:gibalica/controllers/game_controller.dart';
import 'package:gibalica/models/pose_model.dart';
import 'package:gibalica/widgets/training_popup.dart';

class RightHandTraining extends StatefulWidget {
  const RightHandTraining({Key? key}) : super(key: key);

  @override
  State<RightHandTraining> createState() => _RightHandTrainingState();
}

class _RightHandTrainingState extends State<RightHandTraining> {
  final GameController gameController = Get.find<GameController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(children: [
        Expanded(
          flex: 1,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Text(
                    "DESNA",
                    style: TextStyle(fontSize: 30, color: ColorPalette.darkBlue, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "RUKA",
                    style: TextStyle(fontSize: 30, color: ColorPalette.darkBlue, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GestureDetector(onTap: () {}, child: SvgPicture.asset("assets/Hand_Right.svg")),
              ),
            ),
          ]),
        ),
        Expanded(
          flex: 2,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 6,
                            child: GestureDetector(
                              onTap: () {
                                gameController.possiblePoses = [BasePose.rightArmUp];
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    gameController.gameMode = GameMode.training;
                                    gameController.repeatNumber.value = 3;
                                    gameController.gameType.value = GameType.personal;
                                      gameController.currentMode = GamePlayModes.rightArmUp;

                                    return StatefulBuilder(builder: ((context, setState) => buildPopupDialog(gameController, setState)));
                                  },
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: LayoutBuilder(builder: (context, constraint) {
                                  return CircleAvatar(
                                    child: SvgPicture.asset(
                                      "assets/Avatar_1_Girl1.svg",
                                    ),
                                    minRadius: constraint.biggest.height,
                                  );
                                }),
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                "U vis",
                                style: TextStyle(color: ColorPalette.darkBlue, fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 6,
                            child: GestureDetector(
                              onTap: () {
                                gameController.possiblePoses = [BasePose.rightArmMiddle];
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    gameController.gameMode = GameMode.training;
                                    gameController.repeatNumber.value = 3;
                                    gameController.gameType.value = GameType.personal;
                                      gameController.currentMode = GamePlayModes.rightArmMiddle;

                                    return StatefulBuilder(builder: ((context, setState) => buildPopupDialog(gameController, setState)));
                                  },
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: LayoutBuilder(builder: (context, constraint) {
                                  return CircleAvatar(
                                    child: SvgPicture.asset(
                                      "assets/Avatar_1_Girl1.svg",
                                    ),
                                    minRadius: constraint.biggest.height,
                                  );
                                }),
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                "Sa strane",
                                style: TextStyle(color: ColorPalette.darkBlue, fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Expanded(flex: 1, child: Container()),
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          Expanded(
                            flex: 6,
                            child: GestureDetector(
                              onTap: () {
                                gameController.possiblePoses = [BasePose.rightArmMiddle, BasePose.rightArmUp];
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      gameController.gameMode = GameMode.training;
                                      gameController.repeatNumber.value = 3;
                                      gameController.gameType.value = GameType.personal;
                                      gameController.currentMode = GamePlayModes.rightArmUpAndMiddle;

                                      return StatefulBuilder(builder: ((context, setState) => buildPopupDialog(gameController, setState)));
                                    });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(15),
                                child: LayoutBuilder(builder: (context, constraint) {
                                  return CircleAvatar(
                                    child: SvgPicture.asset(
                                      "assets/Avatar_1_Girl1.svg",
                                    ),
                                    minRadius: constraint.biggest.height,
                                  );
                                }),
                              ),
                            ),
                          ),
                          const Expanded(
                            flex: 2,
                            child: Center(
                              child: Text(
                                "U vis i sa strane",
                                style: TextStyle(color: ColorPalette.darkBlue, fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}