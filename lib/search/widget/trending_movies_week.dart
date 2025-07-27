import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:movieapp/utils/next_screen.dart';
import 'package:provider/provider.dart';

import '../../../models/movie.dart';
import '../../moviedetails/movie_details_screen.dart';
import '../../../provider/movie_details_provider.dart';
import '../../../provider/movie_search_provider.dart';
import '../../../themes/theme_provider.dart';
import '../details_trending_movies_week.dart';

class TrendingMoviesWeek extends StatefulWidget {
  const TrendingMoviesWeek({super.key});

  @override
  State<TrendingMoviesWeek> createState() => _TrendingMoviesWeekState();
}

class _TrendingMoviesWeekState extends State<TrendingMoviesWeek> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final selectedColor = isDarkMode ? Colors.white54 : Colors.black54;
    MovieDetailsProvider movieDetailsProvider =
        Provider.of<MovieDetailsProvider>(context, listen: false);

    return Consumer<MovieSearchProvider>(
      builder: (context, provider, child) {
        if (provider.trendingWeekMovies.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Trending Movies Week',
                  style: TextStyle(fontSize: 22),
                ),
                IconButton(
                  onPressed: () {
                    nextScreen(
                      context,
                      const DetailsTrendingMovieWeek(),
                    );
                  },
                  icon: Icon(
                    isDarkMode
                        ? IconlyBold.arrow_right_square
                        : IconlyLight.arrow_right_square,
                  ),
                )
              ],
            ),
            SizedBox(
              height: 270,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: provider.trendingWeekMovies.length > 9
                    ? 9
                    : provider.trendingWeekMovies.length,
                itemBuilder: (context, index) {
                  Movie movie = provider.trendingWeekMovies[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            movieDetailsProvider.fetchMoviesDetails(movie.id!);
                            nextScreen(context,
                                MovieDetailsScreen(movieId: movie.id!));
                          },
                          child: Container(
                            width: 115,
                            height: 156,
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
                                image: NetworkImage(
                                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                ),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
