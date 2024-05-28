import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieapp/common/app_screen_size.dart';
import 'package:movieapp/models/movie_list.dart';
import 'package:movieapp/models/movie.dart';
import 'package:movieapp/moviedetails/movie_details._screen.dart';
import 'package:movieapp/provider/movie_details_provider.dart';
import 'package:movieapp/utils/next_screen.dart';
import 'package:provider/provider.dart';

import '../../../services/api.dart';
import '../../../themes/theme_provider.dart';

class ForYouScreen extends StatefulWidget {
  const ForYouScreen({super.key});

  @override
  State<ForYouScreen> createState() => _ForYouScreenState();
}

class _ForYouScreenState extends State<ForYouScreen> {
  late Future<MoviesList> futureMovieList;
  final ScrollController _scrollController = ScrollController();
  List<Movie> _movies = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  int _currentPage = 1;

  @override
  void initState() {
    super.initState();
    super.initState();
    _loadMovies();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !_isLoadingMore) {
        _loadMoreMovies();
      }
    });
  }

  Future<void> _loadMovies() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final movieList = await api.getPopularMovies(_currentPage);
      setState(() {
        _movies = movieList.results!;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreMovies() async {
    setState(() {
      _isLoadingMore = true;
    });
    try {
      final movieList = await api.getPopularMovies(++_currentPage);
      setState(() {
        _movies.addAll(movieList.results!);
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _refreshMovie() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _currentPage = 1;
      _movies.clear();
      _loadMovies();
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    final selectedColor = isDarkMode ? Colors.white54 : Colors.black54;

    MovieDetailsProvider movieDetailsProvider =
        Provider.of<MovieDetailsProvider>(context, listen: false);

    final screenWidth = MediaQuery.of(context).size.width;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final crossAxisCount = isLandscape ? 3 : 2;

    return Scaffold(
      body: Stack(
        children: [
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: _refreshMovie,
                  child: GridView.builder(
                    controller: _scrollController,
                    dragStartBehavior: DragStartBehavior.start,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisExtent: 310,
                    ),
                    itemCount: _movies.length,
                    itemBuilder: (context, index) {
                      Movie movie = _movies[index];
                      return Padding(
                        padding: AppScreenSize.uiPadding,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                movieDetailsProvider
                                    .fetchMoviesDetails(movie.id!);
                                nextScreen(context,
                                    MovieDetailsScreen(movieId: movie.id!));
                              },
                              child: Container(
                                width: screenWidth / crossAxisCount,
                                height: 224,
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: selectedColor,
                                      blurRadius: 1,
                                      offset: const Offset(4, 4),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        'https://image.tmdb.org/t/p/w500${movie.posterPath}'),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              movie.title ?? 'Không có tiêu đề',
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                              style: GoogleFonts.inter(
                                  textStyle: const TextStyle(fontSize: 14)),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
          if (_isLoadingMore)
            const Positioned(
              left: 0,
              right: 0,
              bottom: 20,
              child: Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
