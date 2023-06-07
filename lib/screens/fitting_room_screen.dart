import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;

import 'package:ar_project/screens/camera_screen.dart';
import 'package:ar_project/widgets/draggable_item.dart';
import 'package:ar_project/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:ar_project/shared/constants.dart';

class FittingRoomScreen extends StatefulWidget {
  const FittingRoomScreen({Key? key}) : super(key: key);

  @override
  State<FittingRoomScreen> createState() => _FittingRoomScreenState();
}

class _FittingRoomScreenState extends State<FittingRoomScreen> {
  final List<DraggableItemDetails> draggableItems = [];
  File? _pickedFile;
  File? _previousFile;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  if (_pickedFile == null)
                    CameraScreen(
                      onBack: () {
                        log(_previousFile.toString());
                        if (_previousFile != null) {
                          setState(() {
                            _pickedFile = _previousFile;
                          });
                        }
                      },
                      onPicked: (File file) {
                        setState(() {
                          _pickedFile = file;
                        });
                        log(file.path);
                      },
                    )
                  else
                    SizedBox(
                        child: _PickedImagePreview(
                      file: _pickedFile!,
                      onChangeView: () {
                        setState(() {
                          _previousFile = _pickedFile!;
                          _pickedFile = null;
                        });
                      },
                    )),
                  for (int i = 0; i < draggableItems.length; i++)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          int index = draggableItems.indexWhere((element) =>
                              element.imagePath == draggableItems[i].imagePath);
                          final item = draggableItems[index];
                          draggableItems.removeAt(index);
                          draggableItems.add(item);
                        });
                      },
                      child: DraggableItem(
                        item: draggableItems[i],
                        canDelete: i == draggableItems.length - 1,
                      ),
                    )
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(0.8),
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(20))),
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  separatorBuilder: (context, index) => SizedBox(
                    width: width * 0.06,
                  ),
                  itemBuilder: (context, index) => ProductItem(
                    imagePath: Constatns.productImages[index],
                    onSelected: (imagePath) {
                      setState(() {
                        draggableItems.add(DraggableItemDetails(
                          imagePath: imagePath,
                          onDragEnd: (imagePath) {},
                          onDelete: (imagePath) {
                            draggableItems.removeWhere((element) {
                              return element.imagePath == imagePath;
                            });
                            setState(() {});
                          },
                        ));
                      });
                    },
                  ),
                  itemCount: Constatns.productImages.length,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _PickedImagePreview extends StatelessWidget {
  const _PickedImagePreview(
      {super.key, required this.file, required this.onChangeView});

  final File file;
  final VoidCallback onChangeView;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Image.file(
          file,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.fill,
        ),
        CircleAvatar(
            radius: 30,
            backgroundColor: Colors.transparent,
            child: IconButton(
                onPressed: onChangeView,
                iconSize: 40,
                icon: const Icon(
                  Icons.add_a_photo,
                  color: Color.fromARGB(255, 31, 5, 71),
                )))
      ],
    );
  }
}
