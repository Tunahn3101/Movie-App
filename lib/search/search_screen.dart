import 'package:flutter/material.dart';
import 'package:movieapp/common/app_screen_size.dart';
import 'package:movieapp/provider/movie_search_provider.dart';
import 'package:provider/provider.dart';

import '../moviedetails/movie_details._screen.dart';
import '../provider/movie_details_provider.dart';
import '../themes/theme_provider.dart';
import '../utils/next_screen.dart';
import 'widget/genres.dart';
import 'widget/input_search_screen.dart';
import 'widget/slider_images.dart';
import 'widget/trending_movies_week.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _handleSearch(String query) {
    final provider = Provider.of<MovieSearchProvider>(context, listen: false);
    provider.searchMovies(query);
  }

  @override
  void initState() {
    super.initState();
    // Lắng nghe sự thay đổi của text controller
    _searchController.addListener(() {
      final query = _searchController.text;
      if (query.isEmpty) {
        final provider =
            Provider.of<MovieSearchProvider>(context, listen: false);
        provider.searchMovies(query);
        setState(() {}); // Kích hoạt cập nhật UI nếu ô tìm kiếm được làm sạch
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        Provider.of<MovieSearchProvider>(context, listen: false)
            .loadMoreMovies();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MovieDetailsProvider movieDetailsProvider =
        Provider.of<MovieDetailsProvider>(context, listen: false);
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
        child: Column(
          children: [
            const SizedBox(height: 50),
            InputSearchScreen(
                controller: _searchController, onSearch: _handleSearch),
            Expanded(
              child: Consumer<MovieSearchProvider>(
                builder: (context, provider, _) {
                  if (_searchController.text.isNotEmpty &&
                      provider.isSearching) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (_searchController.text.isNotEmpty &&
                      provider.movieList != null) {
                    return RefreshIndicator(
                      onRefresh: provider.refreshMovies,
                      child: Column(
                        children: [
                          Expanded(
                            child: GridView.builder(
                              controller: _scrollController,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisExtent: 310,
                                crossAxisSpacing: 20,
                              ),
                              shrinkWrap: true,
                              itemCount: provider.movieList!.length,
                              itemBuilder: (context, index) {
                                final movie = provider.movieList![index];
                                return InkWell(
                                  onTap: () {
                                    movieDetailsProvider
                                        .fetchMoviesDetails(movie.id!);
                                    nextScreen(context,
                                        MovieDetailsScreen(movieId: movie.id!));
                                  },
                                  child: Column(
                                    children: [
                                      Container(
                                        width: screenWidth / crossAxisCount,
                                        height: 224, // Đặt chiều cao cố định
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: selectedColor,
                                                blurRadius: 1,
                                                offset: const Offset(4, 4)),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              movie.posterPath != null
                                                  ? 'https://image.tmdb.org/t/p/w500${movie.posterPath}'
                                                  : '',
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        movie.title!,
                                        textAlign: TextAlign.center,
                                        maxLines:
                                            2, // Giới hạn số dòng hiển thị cho tiêu đề
                                        overflow: TextOverflow
                                            .ellipsis, // Thêm dấu ba chấm nếu tiêu đề quá dài
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                          if (provider.isLoadingMore)
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      ),
                    );
                  } else {
                    // Show default widgets when not searching or search results are empty
                    return const SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: 16),
                          SliderImage(),
                          SizedBox(height: 16),
                          Genres(),
                          SizedBox(height: 16),
                          TrendingMoviesWeek(),
                        ],
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
