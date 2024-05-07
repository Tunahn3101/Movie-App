import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/movie.dart';
import '../../models/movie_list.dart';
import '../../moviedetails/movie_details._screen.dart';
import '../../provider/movie_details_provider.dart';
import '../../services/api.dart';
import '../../themes/theme_provider.dart';
import '../../utils/next_screen.dart';

class DetailsTrendingMovieWeek extends StatefulWidget {
  const DetailsTrendingMovieWeek({super.key});

  @override
  State<DetailsTrendingMovieWeek> createState() =>
      _DetailsTrendingMovieWeekState();
}

class _DetailsTrendingMovieWeekState extends State<DetailsTrendingMovieWeek> {
  late Future<MoviesList> futureTrendingMoviesWeek;
  @override
  void initState() {
    super.initState();
    futureTrendingMoviesWeek = api.getTrendingMoviesWeek();
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final selectedColor = isDarkMode ? Colors.white54 : Colors.black54;
    MovieDetailsProvider movieDetailsProvider =
        Provider.of<MovieDetailsProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trending Movies Week'),
      ),
      body: FutureBuilder<MoviesList>(
        future: futureTrendingMoviesWeek,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.results != null) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisExtent: 320
                  // Số lượng cột
                  ),
              itemCount: snapshot.data!.results!.length,
              itemBuilder: (context, index) {
                Movie movie = snapshot.data!.results![index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {
                          movieDetailsProvider.fetchMoviesDetails(movie.id!);
                          nextScreen(
                              context, MovieDetailsScreen(movieId: movie.id!));
                        },
                        child: Container(
                          width: 184,
                          height: 224,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: selectedColor,
                                blurRadius: 1, // Chỉnh sửa độ mờ của bóng
                                offset: const Offset(
                                    4, 4), // Thay đổi vị trí của bóng
                              ),
                            ],
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              fit: BoxFit.cover, // Đảm bảo ảnh được phủ kín
                              image: NetworkImage(
                                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        movie.title ?? 'Không có tiêu đề',
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        style: GoogleFonts.inter(
                            textStyle: const TextStyle(fontSize: 14)),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("Không có dữ liệu"));
          }
        },
      ),
    );
  }
}
