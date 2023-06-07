import 'package:ar_project/widgets/matrix_gesture_detector.dart';
import 'package:flutter/material.dart';

class DraggableItemDetails {
  final String imagePath;
  final void Function(String imagePath) onDelete;
  final void Function(String imagePath) onDragEnd;

  Matrix4 transform = Matrix4.identity();

  double width;
  double height;
  DraggableItemDetails({
    required this.imagePath,
    required this.onDelete,
    required this.onDragEnd,
    this.width = 0,
    this.height = 0,
  });
}

class DraggableItem extends StatefulWidget {
  const DraggableItem({super.key, required this.item, this.canDelete = false});
  final DraggableItemDetails item;
  final bool canDelete;

  @override
  State<DraggableItem> createState() => _DraggableItemState();
}

class _DraggableItemState extends State<DraggableItem> {
  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());

  @override
  void initState() {
    notifier.value = widget.item.transform;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        widget.item.width = constraints.maxWidth * 0.45;
        widget.item.height = constraints.maxHeight * 0.4;
        return SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: MatrixGestureDetector(
            matrix: widget.item.transform,
            // shouldRotate: false,
            onMatrixUpdate: (m, tm, sm, rm) {
              notifier.value = m;
              widget.item.transform = m;
            },
            onScaleStart: () {},
            onScaleEnd: () {},
            child: AnimatedBuilder(
              animation: notifier,
              builder: (ctx, child) {
                return Transform(
                  transform: notifier.value,
                  child: DragItem(
                    item: widget.item,
                    canDelete: widget.canDelete,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class DragItem extends StatelessWidget {
  final DraggableItemDetails item;
  final bool canDelete;
  const DragItem({super.key, required this.item, required this.canDelete});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          item.imagePath,
          width: item.width,
          height: item.height,
        ),
        if (canDelete)
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
                    icon: const Icon(Icons.close)),
              ),
            ),
          )
      ],
    );
  }
}
