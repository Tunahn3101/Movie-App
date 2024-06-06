import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';
import 'package:movieapp/common/app_images.dart';
import 'package:provider/provider.dart';

import '../provider/authentication_provider.dart';
import '../provider/movie_details_provider.dart';
import '../themes/theme_provider.dart';
import '../utils/back_screen.dart';
import '../utils/next_screen.dart';

import 'casts/casts_screen.dart';
import 'info/info_screen.dart';
import 'reviews/reviews_screen.dart';
import 'trailermovie/trailer_movie.dart';
import 'ui_webview.dart';

class MovieDetailsScreen extends StatefulWidget {
  final int movieId;

  const MovieDetailsScreen({
    super.key,
    required this.movieId,
  });

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  int selectedSegmentIndex = 0;
  late int movieId;

  @override
  void initState() {
    super.initState();
    movieId = widget.movieId;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void handleSaveMovie(BuildContext context, int movieId) async {
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    if (authProvider.sessionID.isNotEmpty) {
      print("Lưu phim với Session ID: ${authProvider.sessionID}");
      try {
        bool isMovieExists =
            await authProvider.getCheckItemStatus(8301129, movieId);
        if (isMovieExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Phim đã có trong danh sách'),
            ),
          );
        } else {
          await authProvider.addMovieToList(8301129, movieId);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Phim đã được thêm vào danh sách thành công'),
            ),
          );
        }
      } catch (e) {
        print('Error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Có lỗi xảy ra vui lòng thử lại'),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Yêu cầu xác thực",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 4),
                  Image.asset(
                    AppImage.icTMDB,
                    width: 100,
                    height: 100,
                  ),
                  const SizedBox(height: 8),
                  const Text("Hãy đăng nhập vào TMDB để xác thực."),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: const Text("Đăng nhập"),
                        onPressed: () {
                          Navigator.pop(context);
                          nextScreen(context, const UIWebView());
                        },
                      ),
                      TextButton(
                        child: const Text("Hủy"),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      );
    }
  }

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

    Color selectedText = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      body: Consumer<MovieDetailsProvider>(builder: (context, provider, child) {
        final movieDetails = provider.movieDetails;

        if (movieDetails == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  const SizedBox(width: double.infinity, height: 384),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.network(
                      'https://image.tmdb.org/t/p/w500/${movieDetails.backdropPath}',
                      width: double.infinity,
                      height: 266,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Container(
                    height: 34,
                    width: 34,
                    margin: const EdgeInsets.only(left: 10, top: 50),
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
                    child: InkWell(
                      onTap: () {
                        backScreen(context);
                      },
                      child: const Icon(
                        IconlyBroken.arrow_left_square,
                        size: 24,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 187),
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
                  Container(
                    height: 58,
                    width: 202,
                    margin: const EdgeInsets.only(top: 266, left: 174),
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
                  Container(
                    height: 20,
                    width: 207,
                    margin: const EdgeInsets.only(top: 356, left: 174),
                    child: Row(
                      children: [
                        Image.asset('assets/images/imdb.png'),
                        const SizedBox(width: 3),
                        Expanded(child: Text('${movieDetails.voteAverage}/10')),
                        Text('${movieDetails.voteCount} votes')
                      ],
                    ),
                  ),
                  Container(
                      width: 207,
                      height: 28,
                      margin: const EdgeInsets.only(top: 326, left: 174),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Chuyển đổi ra tháng-năm
                          Text(DateFormat.yMMMd().format(
                              DateTime.parse('${movieDetails.releaseDate}'))),
                          Text(formatRuntime(movieDetails.runtime)),
                        ],
                      )),
                  Positioned(
                    right: 30,
                    top: 187,
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
                      child: InkWell(
                        onTap: () {
                          nextScreen(context, const TrailerMovie());
                        },
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
                      onPressed: () {
                        handleSaveMovie(context, movieId);
                      },
                      child: Row(
                        children: [
                          Icon(
                            IconlyLight.category,
                            size: 20,
                            color: selectedText,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Add List',
                            style: TextStyle(color: selectedText),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Row(
                        children: [
                          Icon(
                            IconlyLight.star,
                            size: 20,
                            color: selectedText,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Rate',
                            style: TextStyle(color: selectedText),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 430,
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
              )
            ],
          ),
        );
      }),
    );
  }
}
