import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:movieapp/utils/next_screen.dart';
import 'package:provider/provider.dart';

import '../../../themes/theme_provider.dart';
import '../details_categoty.dart';

class Genres extends StatefulWidget {
  const Genres({super.key});

  @override
  State<Genres> createState() => _GenresState();
}

class _GenresState extends State<Genres> {
  final Map<String, String> genresMap = {
    'assets/color_cinema_icons/TV.svg': 'On Tv',
    'assets/color_cinema_icons/Alien.svg': 'Alien',
    'assets/color_cinema_icons/Comedy.svg': 'Comedy',
    'assets/color_cinema_icons/Moon.svg': 'Science Fiction',
  };

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Genres',
              style: TextStyle(fontSize: 22),
            ),
            TextButton(
              onPressed: () {
                nextScreen(context, const DetailsCategory());
              },
              child: const Text('See more'),
            )
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: genresMap.length,
            itemBuilder: (context, index) {
              String svgPath = genresMap.keys.elementAt(index);
              String genreName = genresMap.values.elementAt(index);
              return Padding(
                padding: const EdgeInsets.only(right: 25),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor:
                          isDarkMode ? Colors.white12 : Colors.white10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  onPressed: () {},
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        svgPath,
                        width: 40,
                        height: 40,
                      ),
                      Text(
                        genreName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
