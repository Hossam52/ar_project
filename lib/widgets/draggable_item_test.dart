import 'dart:developer';

import 'package:ar_project/widgets/matrix_gesture_detector.dart';
import 'package:ar_project/widgets/resizable_widget/src/resizable_widget.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'resizable_widget/src/drag_triggers_enum.dart';
import 'resizable_widget/src/model/trigger.dart';
import 'resizable_widget/src/resizable_widget_controller.dart';

class _DraggableItemDetails {
  final String imagePath;
  final void Function(String imagePath) onDelete;
  final void Function(String imagePath) onDragEnd;

  Matrix4 transform = Matrix4.identity();
  double top;
  double left;

  double width;
  double height;
  _DraggableItemDetails({
    required this.imagePath,
    required this.onDelete,
    required this.onDragEnd,
    this.top = 0,
    this.left = 0,
    this.width = 0,
    this.height = 0,
  });
}

class _DraggableItem extends StatefulWidget {
  const _DraggableItem({super.key, required this.item});
  final _DraggableItemDetails item;

  @override
  State<_DraggableItem> createState() => __DraggableItemState();
}

class __DraggableItemState extends State<_DraggableItem> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      widget.item.width = constraints.maxWidth * 0.45;
      widget.item.height = constraints.maxHeight * 0.4;
      return Test(
        item: widget.item,
        key: widget.key,
      );
    });
  }
}

class Test extends StatefulWidget {
  const Test({super.key, required this.item});
  final _DraggableItemDetails item;
  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());

  double maxWidth = 0;
  double maxHeight = 0;
  @override
  void initState() {
    notifier.value = widget.item.transform;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        maxWidth = constraints.maxWidth;
        maxHeight = constraints.maxHeight;
        // log(constraints.toString());

        return Container(
          constraints: constraints,
          child: Draggable(
            feedback: Container(
              padding:
                  EdgeInsets.only(top: widget.item.top, left: widget.item.left),
              child: DragItem(
                item: widget.item,
              ),
            ),
            childWhenDragging: Container(),
            onDragCompleted: () {},
            onDragEnd: (drag) {
              setState(() {
                updateVertical(drag);
                updateHorizontal(drag);
                widget.item.onDragEnd(widget.item.imagePath);
              });
            },
            child: Container(
              padding:
                  EdgeInsets.only(top: widget.item.top, left: widget.item.left),
              child: DragItem(
                item: widget.item,
              ),
            ),
          ),
        );
      },
    );
  }

  void updateVertical(DraggableDetails drag) {
    if ((widget.item.top + drag.offset.dy) > (maxHeight - widget.item.height)) {
      widget.item.top = (maxHeight - widget.item.height);
    } else if ((widget.item.top + drag.offset.dy) < 0.0) {
      widget.item.top = 0;
    } else {
      widget.item.top = widget.item.top + drag.offset.dy;
    }
  }

  void updateHorizontal(DraggableDetails drag) {
    if ((widget.item.left + drag.offset.dx) > (maxWidth - widget.item.width)) {
      widget.item.left = (maxWidth - widget.item.width);
    } else if ((widget.item.left + drag.offset.dx) < 0.0) {
      widget.item.left = 0;
    } else {
      widget.item.left = widget.item.left + drag.offset.dx;
    }
  }
}

class DragItem extends StatelessWidget {
  final _DraggableItemDetails item;

  const DragItem({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Image.asset(
          item.imagePath,
          width: item.width,
          height: item.height,
        ),
        Material(
          color: Colors.transparent,
          child: CircleAvatar(
            radius: 15,
            backgroundColor: Colors.blueGrey.withOpacity(0.7),
            child: FittedBox(
              child: IconButton(
                  onPressed: () {
                    item.onDelete(item.imagePath);
                  },
                  icon: Icon(Icons.close)),
            ),
          ),
        )
      ],
    );
  }
}
