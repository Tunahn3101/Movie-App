import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/movie.dart';
import '../../moviedetails/movie_details._screen.dart';
import '../../provider/movie_details_provider.dart';
import '../../services/api.dart';
import '../../themes/theme_provider.dart';
import '../../utils/next_screen.dart';
import '../common/app_screen_size.dart';
import '../provider/movies_provider.dart';

class DetailsTrendingMovieWeek extends StatefulWidget {
  const DetailsTrendingMovieWeek({super.key});

  @override
  State<DetailsTrendingMovieWeek> createState() =>
      _DetailsTrendingMovieWeekState();
}

class _DetailsTrendingMovieWeekState extends State<DetailsTrendingMovieWeek> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MoviesProvider>(context, listen: false)
          .loadMovies(api.getTrendingMoviesWeek);
    });
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      Provider.of<MoviesProvider>(context, listen: false)
          .loadMoreMovies(api.getTrendingMoviesWeek);
    }
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MoviesProvider>(context);
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final screenWidth = MediaQuery.of(context).size.width;
    final selectedColor = isDarkMode ? Colors.white54 : Colors.black54;
    final movieDetailsProvider =
        Provider.of<MovieDetailsProvider>(context, listen: false);

    // landscape: xoay ngang
    // portrait : xoay dọc
    // xác định hướng hiển thị (ngang - dọc) của thiết bị
    final isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    // dựa vào hướng thiết bị để chia cột
    final crossAxisCount = isLandScape ? 3 : 2;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trending Movies Week'),
      ),
      body: Stack(
        children: [
          movieProvider.isLoading
              ? const Center(child: CircularProgressIndicator())
              : RefreshIndicator(
                  onRefresh: () =>
                      movieProvider.refreshMovies(api.getTrendingMoviesWeek),
                  child: GridView.builder(
                    controller: _scrollController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      mainAxisExtent: 310,
                    ),
                    itemCount: movieProvider.movies.length,
                    itemBuilder: (context, index) {
                      Movie movie = movieProvider.movies[index];
                      return Padding(
                        padding: AppScreenSize.uiPadding,
                        child: Column(
                          children: [
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
                                        offset: const Offset(4, 4)),
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
          if (movieProvider.isLoadingMore)
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
}
