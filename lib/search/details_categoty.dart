import 'package:flutter/material.dart';

class DetailsCategory extends StatefulWidget {
  const DetailsCategory({super.key});

  @override
  State<DetailsCategory> createState() => _DetailsCategoryState();
}

class _DetailsCategoryState extends State<DetailsCategory> {
  final List<String> svgPicture = [
    'assets/color_cinema_icons/TV.svg',
    'assets/color_cinema_icons/Alien.svg',
    'assets/color_cinema_icons/Comedy.svg',
    'assets/color_cinema_icons/Moon.svg',
    'assets/color_cinema_icons/Audience.svg',
    'assets/color_cinema_icons/Ballet Shoes.svg',
  ];
  final List<String> nameSvgPicture = [
    'On Tv',
    'Alien',
    'Comedy',
    'Science Fiction',
    'Audience',
    'Ballet Shoes',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details Genres'),
        centerTitle: true,
      ),
      body: Container(),
    );
  }
}
