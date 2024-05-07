import 'package:flutter/material.dart';

class CarouselSlider extends StatelessWidget {
  const CarouselSlider({
    super.key,
    this.imagePath,
  });
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      width: double.maxFinite,
      height: 200,
      imagePath!,
      fit: BoxFit.cover,
    );
  }
}
