import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieapp/utils/carousel_slider.dart';

import '../../../models/movie.dart';
import '../../../models/movie_list.dart';
import '../../../services/api.dart';

class SliderImage extends StatefulWidget {
  const SliderImage({super.key});

  @override
  State<SliderImage> createState() => _SliderImageState();
}

class _SliderImageState extends State<SliderImage> {
  late List<String> imagePaths;
  late List<String> imageTitles;
  late Future<MoviesList> futureTrendingMovieDay;

  List<Widget> _pages = [];

  int _activePages = 0;

  final PageController _pageController = PageController(initialPage: 0);

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    initializeTrendingMovies();
    startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void initializeTrendingMovies() {
    futureTrendingMovieDay = api.getTopRatedMovies();
    futureTrendingMovieDay.then((moviesList) {
      if (moviesList.results != null) {
        _generateImagePathsAndTitles(moviesList.results!);
        _pages = generateCarouselPages();
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  void _generateImagePathsAndTitles(List<Movie> movies) {
    var entries = movies.take(5).map((movie) {
      return MapEntry(
        'https://image.tmdb.org/t/p/w500${movie.backdropPath}',
        movie.title ?? 'Untitled',
      );
    }).toList();

    imagePaths = entries.map((entry) => entry.key).toList();
    imageTitles = entries.map((entry) => entry.value).toList();
  }

  List<Widget> generateCarouselPages() {
    return imagePaths.map((path) => CarouselSlider(imagePath: path)).toList();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        int nextPage =
            _activePages + 1 < imagePaths.length ? _activePages + 1 : 0;
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
    return FutureBuilder<MoviesList>(
      future: futureTrendingMovieDay,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData &&
            _pages.isNotEmpty) {
          return buildPageView(context);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget buildPageView(BuildContext context) {
    return Stack(
      children: [
        buildMovieSlider(),
        buildIndicator(),
        buildTitleIndicator(),
      ],
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
            itemCount: imagePaths.length,
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
                    _pageController.animateToPage(index,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn);
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
                )),
      ),
    );
  }

  Widget buildTitleIndicator() {
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
