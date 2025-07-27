import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:movieapp/utils/carousel_slider.dart';

import '../../../provider/movie_search_provider.dart';

class SliderImage extends StatefulWidget {
  const SliderImage({super.key});

  @override
  State<SliderImage> createState() => _SliderImageState();
}

class _SliderImageState extends State<SliderImage> {
  List<Widget> _pages = [];
  int _activePages = 0;
  final PageController _pageController = PageController(initialPage: 0);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _generatePages(List<String> imagePaths) {
    _pages = imagePaths.map((path) => CarouselSlider(imagePath: path)).toList();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients && _pages.isNotEmpty) {
        int nextPage = _activePages + 1 < _pages.length ? _activePages + 1 : 0;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MovieSearchProvider>(
      builder: (context, provider, child) {
        if (provider.sliderMovies.isEmpty) {
          return const SizedBox.shrink();
        }

        // Generate image paths and titles
        final imagePaths = provider.sliderMovies.take(5).map((movie) {
          return 'https://image.tmdb.org/t/p/w500${movie.backdropPath}';
        }).toList();

        final imageTitles = provider.sliderMovies.take(5).map((movie) {
          return movie.title ?? 'Untitled';
        }).toList();

        // Generate pages if not already done
        if (_pages.isEmpty) {
          _generatePages(imagePaths);
        }

        return Stack(
          children: [
            buildMovieSlider(),
            buildIndicator(),
            buildTitleIndicator(imageTitles),
          ],
        );
      },
    );
  }

  Widget buildMovieSlider() {
    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        width: double.infinity,
        height: 252,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: PageView.builder(
            onPageChanged: (value) {
              setState(() {
                _activePages = value;
              });
            },
            controller: _pageController,
            itemCount: _pages.length,
            itemBuilder: (context, index) => _pages[index],
          ),
        ),
      ),
    );
  }

  Widget buildIndicator() {
    return Positioned(
      bottom: 10,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(
          _pages.length,
          (index) => InkWell(
            onTap: () {
              _pageController.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn,
              );
              setState(() {
                _activePages = index;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10),
              child: CircleAvatar(
                radius: 4,
                backgroundColor:
                    _activePages == index ? Colors.yellow : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTitleIndicator(List<String> imageTitles) {
    if (_activePages < imageTitles.length) {
      return Positioned(
        bottom: 43,
        left: 15,
        child: SizedBox(
          width: 200,
          child: Text(
            imageTitles[_activePages],
            maxLines: 2,
            style: GoogleFonts.honk(
              textStyle: const TextStyle(
                fontSize: 27,
                fontWeight: FontWeight.w600,
                color: Colors.orange,
              ),
            ),
          ),
        ),
      );
    } else {
      return Container(); // Trả về một container trống nếu không có tiêu đề
    }
  }
}
