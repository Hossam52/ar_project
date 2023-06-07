import 'dart:developer';
import 'dart:io';

import 'package:ar_project/main.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key, required this.onPicked, required this.onBack})
      : super(key: key);
  final void Function(File) onPicked;
  final VoidCallback onBack;
  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    controller =
        CameraController(cameras[0], ResolutionPreset.max, enableAudio: false);
    _initializeControllerFuture = controller.initialize();
  }

  void changeCamera() {
    if (cameras.length == 1 || cameras.isEmpty) return;
    setState(() {
      if (controller.description == cameras[0]) {
        controller.setDescription(cameras[1]);
      } else {
        controller.setDescription(cameras[0]);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return Container(
          constraints: constraints,
          child: FutureBuilder(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SizedBox(
                    width: double.infinity,
                    child: CameraPreview(
                      controller,
                      child: _CameraWidget(
                        controller: controller,
                        onPicked: widget.onPicked,
                        onBack: widget.onBack,
                        onChangeCamera: changeCamera,
                      ),
                    ),
                  );
                } else {
                  // Otherwise, display a loading indicator.
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        );
      }),
    );
  }
}

class _CameraWidget extends StatelessWidget {
  const _CameraWidget(
      {super.key,
      required this.onPicked,
      required this.controller,
      required this.onBack,
      required this.onChangeCamera});
  final void Function(File) onPicked;
  final VoidCallback onBack;
  final VoidCallback onChangeCamera;
  final CameraController controller;
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final height = constraints.maxHeight;
      final width = constraints.maxWidth;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/images/body_skin.png',
                color: Colors.grey.withOpacity(1),
                height: height * 0.8,
                width: width * 0.4,
                fit: BoxFit.fill,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  child: IconButton(
                      onPressed: onBack,
                      iconSize: 40,
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color.fromARGB(255, 31, 5, 71),
                      ))),
              CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  child: IconButton(
                      onPressed: () async {
                        try {
                          final file = await controller.takePicture();

                          onPicked(File(file.path));
                        } on CameraException {
                          log('Camera exception occured');
                        }
                      },
                      iconSize: 40,
                      icon: const Icon(
                        Icons.camera,
                        color: Color.fromARGB(255, 31, 5, 71),
                      ))),
              CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.transparent,
                  child: IconButton(
                      onPressed: onChangeCamera,
                      iconSize: 40,
                      icon: const Icon(
                        CupertinoIcons.switch_camera,
                        color: Color.fromARGB(255, 31, 5, 71),
                      ))),
            ],
          )
        ],
      );
    });
  }
}
