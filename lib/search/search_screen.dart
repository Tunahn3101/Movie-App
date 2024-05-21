import 'package:flutter/material.dart';
import 'package:movieapp/provider/movie_search_provider.dart';
import 'package:provider/provider.dart';

import '../moviedetails/movie_details._screen.dart';
import '../provider/movie_details_provider.dart';
import '../utils/next_screen.dart';
import 'widget/input_search_screen.dart';
import 'widget/slider_images.dart';
import 'widget/genres.dart';
import 'widget/trending_movies_week.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

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
        setState(() {}); // Kích hoạt cập nhật UI nếu ô tìm kiếm được làm sạch
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MovieDetailsProvider movieDetailsProvider =
        Provider.of<MovieDetailsProvider>(context, listen: false);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 50),
            InputSearchScreen(
                controller: _searchController, onSearch: _handleSearch),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<MovieSearchProvider>(
                builder: (context, provider, _) {
                  if (_searchController.text.isNotEmpty &&
                      provider.isSearching) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (_searchController.text.isNotEmpty &&
                      provider.searchResults != null) {
                    // Sử dụng GridView.builder thay vì ListView.builder
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Số cột được hiển thị
                        mainAxisExtent: 250,
                      ),
                      shrinkWrap: true,
                      itemCount: provider.searchResults!.results!.length,
                      itemBuilder: (context, index) {
                        final movie = provider.searchResults!.results![index];
                        return InkWell(
                          onTap: () {
                            movieDetailsProvider.fetchMoviesDetails(movie.id!);
                            nextScreen(context,
                                MovieDetailsScreen(movieId: movie.id!));
                          },
                          child: Column(
                            children: [
                              Container(
                                // Điều chỉnh kích thước container để phù hợp với GridView
                                width: MediaQuery.of(context).size.width / 2 -
                                    30, // Lấy chiều rộng của màn hình và chia cho 2 trừ đi khoảng cách
                                height: 200, // Đặt chiều cao cố định
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
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
                    );
                  } else {
                    // Show default widgets when not searching or search results are empty
                    return const SingleChildScrollView(
                      child: Column(
                        children: [
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
