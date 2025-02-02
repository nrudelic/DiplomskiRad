import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gibalica/controllers/camera_view_controller.dart';
import 'package:gibalica/controllers/device_controller.dart';
import 'package:gibalica/controllers/game_controller.dart';
import 'package:gibalica/controllers/pose_controller.dart';
import 'package:gibalica/controllers/settings_controller.dart';
import 'package:gibalica/helpers/pose_calculator.dart';
import 'package:gibalica/main.dart';
import 'package:gibalica/models/pose_model.dart';
import 'package:gibalica/widgets/camera_view.dart';
import 'package:gibalica/widgets/pose_painter.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class PoseDetectorView extends StatefulWidget {
  final poseController = Get.find<PoseController>();
  final deviceController = Get.find<DeviceController>();

  PoseDetectorView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PoseDetectorViewState();
}

class _PoseDetectorViewState extends State<PoseDetectorView> {
  PoseDetector poseDetector = GoogleMlKit.vision.poseDetector();
  CameraViewController cameraViewController = Get.find<CameraViewController>();
  PoseCalculationHelper poseCalculationHelper = PoseCalculationHelper();
  GameController gameController = Get.find<GameController>();
  SettingsController settingsController = Get.find<SettingsController>();
  bool isBusy = false;
  CustomPaint? customPaint;
  DateTime? timestamp;
  AudioCache player = AudioCache();
  var alarmAudioPath = "bell.wav";

  @override
  void initState() {
    super.initState();
    cameraViewController.isPoseImageShowing = false;
    cameraViewController.isOnboardingImageShowing = false;
    cameraViewController.isProgressBarShowing = false;
    cameraViewController.isPoseSuccessfullAnimationShowing = false;
    cameraViewController.isOnboardingCompletedAnimationShowing = false;
    widget.poseController.onboardingCompleted = false;
    cameraViewController.isOnboardingImageShowing = true;
    widget.poseController.dayNightDict.forEach((name, value) => widget.poseController.dayNightDict[name] = 0);
    widget.poseController.poseCalculationDict.forEach((name, value) => widget.poseController.poseCalculationDict[name] = 0);
    widget.poseController.poseCalculationOnboardingDict.forEach((name, value) => widget.poseController.poseCalculationOnboardingDict[name] = 0);
  }

  @override
  void dispose() {
    cameraViewController.cameraOn = false;

    cameraViewController.cancelOnboardingTimer();
    cameraViewController.cancelTimer();
    cameraViewController.cancelInnerTimers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      title: 'Pose Detector',
      customPaint: customPaint,
      onImage: (inputImage) {
        processImage(inputImage);
      },
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (isBusy) return;
    isBusy = true;

    switch (gameController.gameMode) {
      case GameMode.training:
        trainingGameMode(inputImage);
        break;
      case GameMode.dayAndNight:
        dayNightGameMode(inputImage);
        break;
      case GameMode.repeating:
        repeatingGameMode(inputImage);
        break;
    }
  }

  void trainingGameMode(var inputImage) async {
    final poses = await poseDetector.processImage(inputImage);

    if (!cameraViewController.isProgressBarShowing) {
      widget.poseController.poseCalculationDict.forEach((name, value) => widget.poseController.poseCalculationDict[name] = 0);
    } else if (cameraViewController.isProgressBarShowing) {
      poseCalculationHelper.processBasePoses(poses, true);

      if (widget.poseController.onboardingCompleted) {
        isPoseSuccessful();
      } else {
        isOnboardingSuccessfull();
      }
    }

    if (inputImage.inputImageData?.size != null && inputImage.inputImageData?.imageRotation != null) {
      final painter = PosePainter(poses, inputImage.inputImageData!.size, inputImage.inputImageData!.imageRotation);
      customPaint = CustomPaint(painter: painter);
    } else {
      customPaint = null;
    }
    isBusy = false;
    if (mounted) {
      setState(() {});
    }

    if (timestamp == null) {
      timestamp = DateTime.now();
    } else {
      Duration diff = DateTime.now().difference(timestamp!);
      timestamp = DateTime.now();
      widget.poseController.frameDelta = diff.inMilliseconds / 1000;
    }
  }

  void dayNightGameMode(InputImage inputImage) async {
    final poses = await poseDetector.processImage(inputImage);

    if (!cameraViewController.isProgressBarShowing) {
      widget.poseController.dayNightDict.forEach((name, value) => widget.poseController.dayNightDict[name] = 0);
    }

    if (cameraViewController.isProgressBarShowing) {
      poseCalculationHelper.processBasePoses(poses, true);

      if (widget.poseController.onboardingCompleted) {
        isDayNight();
      } else {
        isOnboardingSuccessfull();
      }
    }

    // Painter for poses
    if (inputImage.inputImageData?.size != null && inputImage.inputImageData?.imageRotation != null) {
      final painter = PosePainter(poses, inputImage.inputImageData!.size, inputImage.inputImageData!.imageRotation);
      customPaint = CustomPaint(painter: painter);
    } else {
      customPaint = null;
    }
    isBusy = false;
    if (mounted) {
      setState(() {});
    }

    // Frame time diff calculation
    if (timestamp == null) {
      timestamp = DateTime.now();
    } else {
      Duration diff = DateTime.now().difference(timestamp!);
      timestamp = DateTime.now();
      widget.poseController.frameDelta = diff.inMilliseconds / 1000;
    }
  }

  void repeatingGameMode(var inputImage) async {
    final poses = await poseDetector.processImage(inputImage);

    if (!cameraViewController.isProgressBarShowing) {
      widget.poseController.poseCalculationDict.forEach((name, value) => widget.poseController.poseCalculationDict[name] = 0);
    }

    if (cameraViewController.isProgressBarShowing) {
      poseCalculationHelper.processBasePoses(poses, true);

      if (widget.poseController.onboardingCompleted) {
        isRepeatingPoseSuccessful();
      } else {
        isOnboardingSuccessfull();
      }
    }

    if (inputImage.inputImageData?.size != null && inputImage.inputImageData?.imageRotation != null) {
      final painter = PosePainter(poses, inputImage.inputImageData!.size, inputImage.inputImageData!.imageRotation);
      customPaint = CustomPaint(painter: painter);
    } else {
      customPaint = null;
    }
    isBusy = false;
    if (mounted) {
      setState(() {});
    }

    if (timestamp == null) {
      timestamp = DateTime.now();
    } else {
      Duration diff = DateTime.now().difference(timestamp!);
      timestamp = DateTime.now();
      widget.poseController.frameDelta = diff.inMilliseconds / 1000;
    }
  }

  void isPoseSuccessful() {
    if (widget.poseController.poseCalculationDict[widget.poseController.wantedPose]! > 1 && cameraViewController.poseTimer != null && cameraViewController.poseTimer!.isActive) {
      cameraViewController.cancelTimer();
    }
    if (widget.poseController.poseCalculationDict[widget.poseController.wantedPose]! < 0.5 && (cameraViewController.poseTimer == null || !cameraViewController.poseTimer!.isActive)) {
      cameraViewController.startCameraTimer();
    }
    if (widget.poseController.poseCalculationDict[widget.poseController.wantedPose] == 3) {
      if (settingsController.isSoundOn.value) playSound();

      print("PODIZEEM");
      gameController.currentRepetitionCounter++;

      widget.poseController.updateLottieStatus(true);

      cameraViewController.isProgressBarShowing = false;
      widget.poseController.onboardingCompleted = false;
    }
  }

  void isOnboardingSuccessfull() {
    // Cancelation of timer that is used to show pose image if user didn't stand in a pose for X time
    if (widget.poseController.poseCalculationDict[BasePose.leftArmNeutral]! > 1 && widget.poseController.poseCalculationDict[BasePose.rightArmNeutral]! > 1 && widget.poseController.poseCalculationDict[BasePose.leftLegNeutral]! > 1 && widget.poseController.poseCalculationDict[BasePose.rightLegNeutral]! > 1 && cameraViewController.onboardingTimer != null && cameraViewController.onboardingTimer!.isActive) {
      cameraViewController.cancelOnboardingTimer();
    }

    // Starting timer if user didn't took pose for X time
    if (widget.poseController.poseCalculationDict[BasePose.leftArmNeutral]! < 0.5 && widget.poseController.poseCalculationDict[BasePose.rightArmNeutral]! < 0.5 && widget.poseController.poseCalculationDict[BasePose.leftLegNeutral]! < 0.5 && widget.poseController.poseCalculationDict[BasePose.rightLegNeutral]! < 0.5 && (cameraViewController.onboardingTimer == null || !cameraViewController.onboardingTimer!.isActive)) {
      cameraViewController.startCameraOnboardingTimer();
    }
    if (widget.poseController.poseCalculationDict[BasePose.leftArmNeutral] == 3 && widget.poseController.poseCalculationDict[BasePose.rightArmNeutral] == 3 && widget.poseController.poseCalculationDict[BasePose.leftLegNeutral] == 3 && widget.poseController.poseCalculationDict[BasePose.rightLegNeutral] == 3) {
      if (settingsController.isSoundOn.value) playSound();

      if (gameController.gameMode == GameMode.training) {
        poseCalculationHelper.setNewTrainingGameModePose();
      } else {
        poseCalculationHelper.setNewRepeatinGameModePose();
      }
      poseCalculationHelper.setNewDayNightPosition();

      widget.poseController.onboardingCompleted = true;
      if (gameController.gameMode == GameMode.repeating) {
        cameraViewController.pauseRepetitionTimer();
      }
      widget.poseController.updateLottieStatus(true);

      cameraViewController.isProgressBarShowing = false;
    }
  }

  void isDayNight() {
    // Cancelation of timer that is used to show pose image if user didn't stand in a pose for X time
    if (widget.poseController.dayNightDict[widget.poseController.wantedDayNightPosition]! > 1 && cameraViewController.poseTimer != null && cameraViewController.poseTimer!.isActive) {
      cameraViewController.cancelTimer();
    }

    // Starting timer if user didn't took pose for X time
    if (widget.poseController.dayNightDict[widget.poseController.wantedDayNightPosition]! < 0.5 && (cameraViewController.poseTimer == null || !cameraViewController.poseTimer!.isActive)) {
      cameraViewController.startCameraTimer();
    }

    if (widget.poseController.dayNightDict[widget.poseController.wantedDayNightPosition] == 3) {
      if (settingsController.isSoundOn.value) playSound();

      gameController.currentRepetitionCounter++;
      poseCalculationHelper.setNewDayNightPosition();
      widget.poseController.updateLottieStatus(true);
      cameraViewController.isProgressBarShowing = false;
    }
  }

  void isRepeatingPoseSuccessful() {
    if (widget.poseController.poseCalculationDict[widget.poseController.wantedPose]! > 1 && cameraViewController.poseTimer != null && cameraViewController.poseTimer!.isActive) {
      cameraViewController.cancelTimer();
    }
    if (widget.poseController.poseCalculationDict[widget.poseController.wantedPose]! < 0.5 && (cameraViewController.poseTimer == null || !cameraViewController.poseTimer!.isActive)) {
      cameraViewController.startCameraTimer();
    }
    if (widget.poseController.poseCalculationDict[widget.poseController.wantedPose] == 3) {
      if (settingsController.isSoundOn.value) playSound();

      gameController.currentRepetitionCounter++;
      cameraViewController.pauseRepetitionTimer();
      widget.poseController.updateLottieStatus(true);
      poseCalculationHelper.setNewRepeatinGameModePose();
      cameraViewController.isProgressBarShowing = false;
    }
  }

  void playSound() {
    player.play(alarmAudioPath);
  }
}
