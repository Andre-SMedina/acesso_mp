import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Camera2 {
  final BuildContext context;
  final List<CameraDescription> cameras;
  final Function() alert;
  final Function() reload;

  Camera2(
      {required this.context,
      required this.alert,
      required this.cameras,
      required this.reload});

  CameraController? controller;
  Uint8List? capturedImage;

  Future<void> initializeCamera() async {
    controller = CameraController(cameras[0], ResolutionPreset.low);
    await controller!.initialize();
    reload;
  }

  CameraPreview cameraPreview() {
    initializeCamera();
    return CameraPreview(controller!);
  }

  int numb() {
    return 1;
  }
}
