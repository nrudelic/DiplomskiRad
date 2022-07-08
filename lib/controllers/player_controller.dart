import 'package:get/get.dart';

class PlayerController extends GetxController {
  String? playerName;
  var avatarAssetPath = "assets/Avatar_1_Girl1.svg".obs;
  PositionPlayMode? positionPlayMode;
  var exerciseProgram = ExerciseProgram.all.obs;
  bool avatarChosen = false;
  
  var leftHandPref = false.obs; 
  var rightHandPref = false.obs;
  var squatPref = false.obs;
  var leftLegPref = false.obs;
  var rightLegPref = false.obs;
}

enum PositionPlayMode{
  standing,
  sitting
}

enum ExerciseProgram{
  all,
  special
}
