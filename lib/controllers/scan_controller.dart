import 'dart:convert';
import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial_ble/flutter_bluetooth_serial_ble.dart';

// import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class ScanController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initCamera();
    // initTFLite();
  }

  @override
  void dispose() {
    super.dispose();
    cameraController.dispose();
  }

  late CameraController cameraController;
  late List<CameraDescription> cameras;

  var isCameraInitialized = false;
  var cameraCount = 0;
  var detectorBusy = false;
  bool connectionIsHeld = false;
  final double threshold = 0.5;
  String error = '';

  bool lettuceInSight = false;

  initCamera() async {
    if (await Permission.camera.request().isGranted) {
      cameras = await availableCameras();
      cameraController = CameraController(cameras[0], ResolutionPreset.max);
      await cameraController.initialize().then((value) {
        cameraController.startImageStream((image) {
          cameraCount++;
          if (cameraCount % 10 == 0) {
            cameraCount = 0;
            objectDetector(image);
          }
        });
        update();
      });
      isCameraInitialized = true;
      update();
    } else {
      debugPrint("Permission to access camera is not granted by user");
    }
    update();
  }

  communicateToBT(BluetoothDevice device, String message) async {
    // Some simplest connection :F
    try {
      BluetoothConnection connection =
          await BluetoothConnection.toAddress(device.address);
      print('Connected to the device');
      print('sending.... : $message');
      if (connection.isConnected) {
        connectionIsHeld = true;
        update();
        connection!.output
            .add(Uint8List.fromList(utf8.encode(message + "\r\n")));
        await connection!.output.allSent;
        print("menssage sent!!!");
        connection.close();
        update();
      } else {
        error = "Cpnnection Lost with device";
        connectionIsHeld = false;
        update();
      }
    } catch (e) {
      error = "$e";
      update();
    }
  }

  // objectDetectorFromWS(Stream<CameraImage> imageStream) {
  //   imageStream.listen((frame) async {
  //     try {
  //       if (detectorBusy) {
  //         debugPrint("Detector is busy, skipping");
  //         return;
  //       }
  //       detectorBusy = true;
  //       var detector = await Tflite.runModelOnFrame(
  //         bytesList: frame.planes.map((e) {
  //           return e.bytes;
  //         }).toList(),
  //         imageHeight: frame.height,
  //         imageWidth: frame.width,
  //         imageMean: 127.5,
  //         imageStd: 127.5,
  //         rotation: 0,
  //         numResults: 5,
  //         threshold: 0.1,
  //       );

  //       if (detector != null) {
  //         bool lettuceAux = false;
  //         for (var obj in detector) {
  //           if (obj['label'] == "1 lettuce") {
  //             debugPrint("uwu");
  //             lettuceAux = true;
  //             debugPrint('$detector');
  //           }
  //         }
  //         if (lettuceAux) {
  //           lettuceInSight = true;
  //         } else {
  //           lettuceInSight = false;
  //         }
  //         update();
  //       }
  //     } catch (e) {
  //       debugPrint("$e");
  //     } finally {
  //       detectorBusy = false;
  //     }
  //   });
  // }

  objectDetector(CameraImage frame) async {
    try {
      if (detectorBusy) {
        debugPrint("detector is busy, skiping");
        return;
      }
      detectorBusy = true;
      // // // var detector = await Tflite.runModelOnFrame(
      // // //     bytesList: frame.planes.map((e) {
      // // //       return e.bytes;
      // // //     }).toList(),
      // // //     imageHeight: frame.height,
      // // //     imageWidth: frame.width,
      // // //     imageMean: 127.5,
      // // //     imageStd: 127.5,
      // // //     rotation: 0,
      // // //     numResults: 5,
      // // //     threshold: 0.1);

      // // if (detector != null) {
      // //   bool lettuceAux = false;
      // //   for (var obj in detector) {
      // //     if (obj['label'] == "1 lettuce") {
      // //       debugPrint("uwu");
      // //       lettuceAux = true;
      // //       debugPrint('$detector');
      // //     }
      // //   }
      //   if (lettuceAux) {
      //     lettuceInSight = true;
      //   } else {
      //     lettuceInSight = false;
      //   }
      //   update();
      // }
    } catch (e) {
      debugPrint("$e");
    } finally {
      detectorBusy = false;
    }
  }

  // initTFLite() async {
  //   await Tflite.loadModel(
  //     model: "assets/trainedModel/weedDetector.tflite",
  //     labels: "assets/trainedModel/labels.txt",
  //   );
  // }
}
