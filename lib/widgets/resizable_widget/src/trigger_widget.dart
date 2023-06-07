import 'package:flutter/material.dart';
import 'package:ar_project/widgets/resizable_widget/src/model/trigger.dart';
import 'drag_triggers_enum.dart';

class TriggerWidget extends StatefulWidget {
  final DragDetailsCallback onDrag;
  final Trigger trigger;

  const TriggerWidget({
    Key? key,
    required this.onDrag,
    required this.trigger,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TriggerWidgetState();
  }
}

class _TriggerWidgetState extends State<TriggerWidget> {
  double initX = 0;
  double initY = 0;

  void _handleDrag(DragStartDetails details) {
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;
  }

  void _handleUpdate(DragUpdateDetails details) {
    final double dx = details.globalPosition.dx - initX;
    final double dy = details.globalPosition.dy - initY;
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;

    widget.onDrag(dx, dy);
  }

  double _scaleFactor = 0.5;
  double _baseScaleFactor = 0.5;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        // onPanStart: _handleDrag,
        // onPanUpdate: _handleUpdate,
        onScaleStart: (details) {
          _baseScaleFactor = _scaleFactor;
        },
        onScaleUpdate: (details) {
          setState(() {
            _scaleFactor = _baseScaleFactor * details.scale;
          });
        },
        // onScaleEnd: (details) {
        //   // return to initial scale
        //   _scaleFactor = _baseScaleFactor;
        // },
        child: Transform.scale(
            scale: _scaleFactor, child: Container(color: Colors.yellow)),

        // child: SizedBox(
        //   width: widget.trigger.width,
        //   height: widget.trigger.height,
        //   child: Align(
        //     alignment: widget.trigger.alignment,
        //     child: widget.trigger.child,
        //   ),
        // ),
      ),
    );
  }
}
