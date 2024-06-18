import 'package:flutter/material.dart';

class ImageData extends StatelessWidget {
  final String path;
  final double? width;
  final double? height;
  final Color? color;

  const ImageData({
    super.key,
    required this.path,
    this.width = 30,
    this.height = 30,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      width: width,
      height: height,
      color: color,
    );
  }
}
