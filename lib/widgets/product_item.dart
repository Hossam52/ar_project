import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  const ProductItem(
      {super.key, required this.imagePath, required this.onSelected});
  final String imagePath;
  final void Function(String imagePath) onSelected;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onDoubleTap: () {
          onSelected(imagePath);
        },
        child: Image.asset(imagePath));
  }
}
