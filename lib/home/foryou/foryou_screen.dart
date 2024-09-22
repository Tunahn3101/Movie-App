import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieapp/common/app_screen_size.dart';
import 'package:movieapp/models/movie.dart';
import 'package:movieapp/moviedetails/movie_details._screen.dart';
import 'package:movieapp/utils/next_screen.dart';
import 'package:provider/provider.dart';
import '../../../themes/theme_provider.dart';
import '../../provider/movies_provider.dart';
import '../../services/api.dart';

class ForYouScreen extends StatefulWidget {
  const ForYouScreen({super.key});

  @override
  State<ForYouScreen> createState() => _ForYouScreenState();
}

class _ForYouScreenState extends State<ForYouScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // sử dụng WidgetsBinding.instance.addPostFrameCallback để đảm bảo loadMovies chi được gọi sau khi xây dựng widget làn đầu tiên
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MoviesProvider>(context, listen: false)
          .loadMovies(api.getPopularMovies);
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
          .loadMoreMovies(api.getPopularMovies);
    }
  }

  @override
  Widget build(BuildContext context) {
    final movieProvider = Provider.of<MoviesProvider>(context);
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final selectedColor = isDarkMode ? Colors.white54 : Colors.black54;
    final screenWidth = MediaQuery.of(context).size.width;
    // landscape: xoay ngang
    // portrait : xoay dọc
    // xác định hướng hiển thị (ngang - dọc) của thiết bị
    final isLandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    // dựa vào hướng thiết bị để chia cột
    final crossAxisCount = isLandScape ? 3 : 2;

    return Scaffold(
      body: Padding(
        padding: AppScreenSize.uiPadding,
        child: Stack(
          children: [
            movieProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () =>
                        movieProvider.refreshMovies(api.getPopularMovies),
                    child: GridView.builder(
                      padding: const EdgeInsets.only(top: 12),
                      controller: _scrollController,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisExtent: 300,
                        crossAxisSpacing: 16,
                      ),
                      itemCount: movieProvider.movies.length,
                      itemBuilder: (context, index) {
                        Movie movie = movieProvider.movies[index];
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                nextScreen(context,
                                    MovieDetailsScreen(movieId: movie.id!));
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
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
      ),
    );
  }
}
