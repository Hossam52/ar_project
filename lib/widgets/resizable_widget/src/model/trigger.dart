import 'package:flutter/material.dart';
import 'package:ar_project/widgets/resizable_widget/resizable_widget.dart';

class Trigger {
  late final Alignment alignment;
  final Widget child;
  final double? height;
  final double? width;
  final DragTriggersEnum dragTriggerType;

  Trigger({
    Alignment? alignment,
    this.height,
    this.width,
    required this.child,
    required this.dragTriggerType,
  }) {
    this.alignment = alignment ?? dragTriggerType.alignment;
  }
}
