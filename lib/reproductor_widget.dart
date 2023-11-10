import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_serial_example/controllers/scan_controller.dart';
import 'package:flutter_bluetooth_serial_example/currentState.dart';

import 'package:get/get.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    Key? key,
  }) : super(key: key);

  @override
  VideoPlayerWidgetState createState() => VideoPlayerWidgetState();
}

class VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  ValueNotifier<bool> showNextChapterButton = ValueNotifier<bool>(false);

  int motor1En = 0;
  int motor2En = 0;
  int tool = 0;
  int dir1 = 1;
  int dir2 = 1;
  bool pickUpTool = false;
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  }

  @override
  Future<void> dispose() async {
    super.dispose();
  }

  Future<void> sendMssg(ScanController controller) async {
    String message = '$motor1En,$dir1,$motor2En,$dir2,$tool';
    await controller.communicateToBT(currentDevice, message);
  }

  @override
  Widget build(BuildContext context) {
    // if (_controller.value.isInitialized) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: GetBuilder<ScanController>(
          init: ScanController(),
          builder: (controller) {
            // debugPrint("lettuce in sight: ${controller.lettuceInSight}");
            if (controller.error != '') {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Text(controller.error),
                ),
              );
              controller.error = '';
            }
            return Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Container(
                    width: screenWidth,
                    height: screenHeight,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red, // Border color
                        width: controller.lettuceInSight
                            ? 10.0
                            : 0, // Border width
                      ),
                      borderRadius:
                          BorderRadius.circular(10.0), // Border radius
                    ),
                    child: controller.isCameraInitialized
                        ? CameraPreview(controller.cameraController)
                        : const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF8471F5)),
                            ),
                          )),
                Positioned(
                  left: 16, // Ajusta la posición izquierda según sea necesario
                  bottom: 16, // Ajusta la posición inferior según sea necesario
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: IconButton(
                            icon: const Icon(Icons.arrow_upward,
                                color: Colors.white),
                            onPressed: null,
                          ),
                          onLongPressEnd: (details) async {
                            setState(() {
                              motor1En = 0;
                            });
                            await sendMssg(controller);
                            debugPrint("tap up");
                          },
                          onLongPressStart: (details) async {
                            setState(() {
                              motor1En = 1;
                              dir1 = 1;
                            });
                            await sendMssg(controller);
                            debugPrint("tap d");
                          },
                        ),
                        GestureDetector(
                          child: IconButton(
                            icon: const Icon(Icons.arrow_downward,
                                color: Colors.white),
                            onPressed: null,
                          ),
                          onLongPressEnd: (details) async {
                            setState(() {
                              motor1En = 0;
                            });
                            await sendMssg(controller);
                            debugPrint("tap up");
                          },
                          onLongPressStart: (details) async {
                            setState(() {
                              motor1En = 1;
                              dir1 = 0;
                            });
                            await sendMssg(controller);
                            debugPrint("tap d");
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(-0.9, -0.9),
                  child: Text(
                      "Status is device connected: ${controller.connectionIsHeld}"),
                ),
                Align(
                    alignment: const Alignment(0.95,
                        0.3), // Ajusta la posición inferior según sea necesario
                    child: ElevatedButton(
                      onPressed: () {},
                      child: Container(
                        width: 140,
                        child: Row(
                          children: [
                            Text(isSwitched ? 'Apagar' : 'Deshierbar',
                                style: TextStyle(
                                    fontFamily: "poppins",
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green[300])),
                            Switch(
                              value: isSwitched,
                              onChanged: (value) async {
                                setState(() {
                                  isSwitched = value;
                                  tool = value
                                      ? 1
                                      : 0; // Cambiar tool a 1 si el interruptor está encendido (on), o a 0 si está apagado (off).
                                });

                                await sendMssg(
                                    controller); // Si el interruptor está encendido (on), envía un mensaje.
                              },
                            ),
                          ],
                        ),
                      ),
                    )),
                Align(
                  alignment: const Alignment(0.95,
                      0.90), // Ajusta la posición inferior según sea necesario
                  child: Container(
                    width: 190,
                    child: GestureDetector(
                      onLongPressEnd: (details) async {
                        setState(() {
                          motor2En = 0;
                        });
                        debugPrint("tap up");
                        await sendMssg(controller);
                      },
                      onLongPressStart: (details) async {
                        setState(() {
                          motor2En = 1;
                          dir2 = 0;
                        });
                        debugPrint("tap d");
                        await sendMssg(controller);
                      },
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("Bajar herramienta",
                            style: TextStyle(
                                fontFamily: "poppins",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[300])),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(0.95,
                      0.6), // Ajusta la posición inferior según sea necesario
                  child: Container(
                    width: 190,
                    child: GestureDetector(
                      onLongPressEnd: (details) async {
                        setState(() {
                          motor2En = 0;
                        });
                        await sendMssg(controller);
                        debugPrint("tap up");
                      },
                      onLongPressStart: (details) async {
                        setState(() {
                          motor2En = 1;
                          dir2 = 1;
                        });
                        await sendMssg(controller);
                        debugPrint("tap d");
                      },
                      child: ElevatedButton(
                        onPressed: () {},
                        child: Text("Subir herramienta",
                            style: TextStyle(
                                fontFamily: "poppins",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[300])),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: const Alignment(1, -1),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed("/devices");
                      },
                      backgroundColor: Color.fromARGB(207, 255, 255, 255),
                      child: Icon(
                        Icons.bluetooth_connected,
                        color: Colors.blue,
                        size: 50,
                      ),
                    ),
                  ),
                ),
                controller.lettuceInSight
                    ? Align(
                        alignment: const Alignment(0, 0.9),
                        child: Container(
                          height: 80,
                          width: 200,
                          alignment: const Alignment(0, 0),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius:
                                BorderRadius.circular(10.0), // Border radius
                          ),
                          child: const Text(
                            'Cuidado, Se ha detectado una Lechuga en rango de corte',
                            style: TextStyle(fontSize: 15, color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ))
                    : const SizedBox(),
              ],
            );
          }),
    );
    // }
    // else {
    //   return Container(
    //     color: Colors.black,
    //     child: const Center(
    //       child: CircularProgressIndicator(
    //         valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF8471F5)),
    //         backgroundColor: Colors.white,
    //       ),
    //     ),
    //   );
    // }
  }
}
