import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:movieapp/utils/next_screen.dart';
import 'package:provider/provider.dart';

import '../../../models/movie.dart';
import '../../../models/movie_list.dart';
import '../../../moviedetails/movie_details._screen.dart';
import '../../../provider/movie_details_provider.dart';
import '../../../services/api.dart';
import '../../../themes/theme_provider.dart';
import '../details_trending_movies_week.dart';

class TrendingMoviesWeek extends StatefulWidget {
  const TrendingMoviesWeek({super.key});

  @override
  State<TrendingMoviesWeek> createState() => _TrendingMoviesWeekState();
}

class _TrendingMoviesWeekState extends State<TrendingMoviesWeek> {
  late Future<MoviesList> futureTrendingMoviesWeek;
  @override
  void initState() {
    super.initState();
    futureTrendingMoviesWeek = api.getTrendingMoviesWeek(1);
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final selectedColor = isDarkMode ? Colors.white54 : Colors.black54;
    MovieDetailsProvider movieDetailsProvider =
        Provider.of<MovieDetailsProvider>(context, listen: false);
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
                nextScreen(context, const DetailsTrendingMovieWeek());
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
          child: FutureBuilder<MoviesList>(
            future: futureTrendingMoviesWeek,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              } else if (snapshot.hasData && snapshot.data!.results != null) {
                int itemCount = 9;
                if (snapshot.data!.results!.length < itemCount) {
                  itemCount = snapshot.data!.results!.length;
                }
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: itemCount,
                  itemBuilder: (context, index) {
                    Movie movie = snapshot.data!.results![index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 30),
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
                          // Text(
                          //   movie.title ?? 'Không có tiêu đề',
                          //   textAlign: TextAlign.center,
                          //   maxLines: 3,
                          //   style: GoogleFonts.inter(
                          //       textStyle: const TextStyle(fontSize: 14)),
                          //   overflow: TextOverflow.ellipsis,
                          // ),
                        ],
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('Không có dữ liệu'),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
