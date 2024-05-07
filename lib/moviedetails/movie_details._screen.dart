import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:movieapp/moviedetails/info/info_screen.dart';
import 'package:movieapp/moviedetails/casts/casts_screen.dart';
import 'package:movieapp/moviedetails/reviews/reviews_screen.dart';
import 'package:movieapp/moviedetails/trailermovie/trailer_movie.dart';
import 'package:movieapp/utils/back_screen.dart';
import 'package:movieapp/utils/next_screen.dart';
import 'package:provider/provider.dart';

import '../provider/movie_details_provider.dart';
import '../themes/theme_provider.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailsScreen({super.key, required this.movieId});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  int selectedSegmentIndex = 0;
  String formatRuntime(int? runtime) {
    if (runtime == null) {
      return 'Unknow';
    }
    final hours = runtime ~/ 60;
    final minutes = runtime % 60;
    return '${hours}h${minutes}min'; // Format "Xh Ymin"
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> segmentWidgets = [
      const InfoScreen(),
      const CastsScreen(),
      const ReviewsScreen(),
    ];
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    Color selectedColor =
        isDarkMode ? Colors.grey.shade800 : const Color(0xFFFAFAFA);

    return Scaffold(
      body: Consumer<MovieDetailsProvider>(builder: (context, provider, child) {
        final movieDetails = provider.movieDetails;

        // Khi dữ liệu chi tiết phim đang được tải
        if (movieDetails == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              children: [
                const SizedBox(
                  width: double.infinity,
                  height: 384,
                ),
                Positioned(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500/${movieDetails.backdropPath}',
                      width: double.infinity,
                      height: 266,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  left: 10,
                  top: 50,
                  child: InkWell(
                    onTap: () {
                      backScreen(context);
                    },
                    child: Container(
                      height: 34,
                      width: 34,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        IconlyBroken.arrow_left_square,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 20,
                  top: 187,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10), // Bo tròn ở đây
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500/${movieDetails.posterPath}',
                      width: 144,
                      height: 197,
                      fit: BoxFit.cover, // Để ảnh phủ kín và không bị méo
                    ),
                  ),
                ),
                Positioned(
                  top: 266,
                  left: 174,
                  child: SizedBox(
                    height: 58,
                    width: 202,
                    child: Text(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      '${movieDetails.title}',
                      style: GoogleFonts.dmSans(
                        textStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 326,
                  left: 174,
                  child: SizedBox(
                      width: 207,
                      height: 28,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Chuyển đổi ra tháng-năm
                          Text(DateFormat.yMMMd().format(
                              DateTime.parse('${movieDetails.releaseDate}'))),
                          Text(formatRuntime(movieDetails.runtime)),
                        ],
                      )),
                ),
                Positioned(
                  top: 356,
                  left: 174,
                  child: SizedBox(
                    height: 20,
                    width: 207,
                    child: Row(
                      children: [
                        Image.asset('assets/images/imdb.png'),
                        const SizedBox(width: 3),
                        Expanded(child: Text('${movieDetails.voteAverage}/10')),
                        Text('${movieDetails.voteCount} votes')
                      ],
                    ),
                  ),
                ),
                Positioned(
                  left: 320,
                  top: 187,
                  child: InkWell(
                    onTap: () {
                      nextScreen(context, const TrailerMovie());
                    },
                    child: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFff7652).withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                          ),
                        ],
                        color: const Color(0xFFff7652),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Icon(
                        IconlyBroken.play,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: Consumer<MovieDetailsProvider>(
                  builder: (context, provider, child) {
                    final genres = provider.movieDetails?.genres ?? [];
                    if (genres.isEmpty) {
                      return Container();
                    }
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: genres
                            .map((genre) => Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Chip(
                                      label: Text(genre.name ?? 'Unknows')),
                                ))
                            .toList(),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Row(
                      children: [
                        Icon(IconlyLight.bookmark),
                        SizedBox(width: 4),
                        Text('Save'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Row(
                      children: [
                        Icon(IconlyLight.star),
                        SizedBox(width: 4),
                        Text('Rate'),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Row(
                      children: [
                        Icon(IconlyLight.plus),
                        SizedBox(width: 4),
                        Text('List'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: selectedColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // Màu bóng đổ
                      spreadRadius: 1, // Khoảng cách tỏa của bóng đổ so với box
                      blurRadius: 20, // Độ mờ của bóng đổ
                      offset: const Offset(0, -2), // Vị trí bóng đổ
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    CustomSlidingSegmentedControl<int>(
                      initialValue: selectedSegmentIndex,
                      children: const {
                        0: Text(
                          'Info',
                        ),
                        1: Text(
                          'Casts',
                        ),
                        2: Text(
                          'Reviews',
                        ),
                      },
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? const Color(0xFF141414)
                            : CupertinoColors.lightBackgroundGray,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      thumbDecoration: BoxDecoration(
                        color: isDarkMode ? Colors.grey.shade800 : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.3),
                            blurRadius: 4.0,
                            spreadRadius: 1.0,
                            offset: const Offset(
                              0.0,
                              2.0,
                            ),
                          ),
                        ],
                      ),
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInToLinear,
                      onValueChanged: (int value) {
                        setState(() {
                          selectedSegmentIndex = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    Expanded(
                      child: segmentWidgets[
                          selectedSegmentIndex], // Hiển thị widget tương ứng với segment đã chọn
                    ),
                  ],
                ),
              ),
            )
          ],
        );
      }),
    );
  }
}