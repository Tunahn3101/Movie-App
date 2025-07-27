import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconly/iconly.dart';
import 'package:movieapp/provider/library_provider.dart';
import 'package:provider/provider.dart';

import '../moviedetails/movie_details_screen.dart';
import '../provider/movie_details_provider.dart';
import '../utils/next_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  static const int _listId = 8301129;

  void _removeMovie(int listId, int movieId) async {
    try {
      await Provider.of<LibraryProvider>(context, listen: false)
          .removeMovieFromList(listId, movieId);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Không thể xóa phim: $error'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<LibraryProvider>(context, listen: false)
          .loadMovieList(_listId);
    });
  }

  @override
  Widget build(BuildContext context) {
    MovieDetailsProvider movieDetailsProvider =
        Provider.of<MovieDetailsProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('List To Movie'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<LibraryProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Lỗi: ${provider.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.clearError();
                      provider.loadMovieList(_listId);
                    },
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            );
          }

          if (provider.movieList?.items == null ||
              provider.movieList!.items!.isEmpty) {
            return const Center(
              child: Text('Không có dữ liệu.'),
            );
          }

          return RefreshIndicator(
            onRefresh: () => provider.refreshMovieList(_listId),
            child: ListView.separated(
              itemCount: provider.movieList!.items!.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final movieList = provider.movieList;
                if (movieList == null || movieList.items == null) {
                  return const SizedBox.shrink();
                }
                final movie = movieList.items![index];
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      // slidable dùng để xóa item
                      SlidableAction(
                        onPressed: (context) {
                          _removeMovie(_listId, movie.id!);
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: IconlyBold.delete,
                        label: 'Delete',
                      ),
                    ],
                  ),
                  child: ListTile(
                    onTap: () {
                      movieDetailsProvider.fetchMoviesDetails(movie.id!);
                      nextScreen(
                          context, MovieDetailsScreen(movieId: movie.id!));
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                          'https://image.tmdb.org/t/p/w500${movie.posterPath}'),
                    ),
                    title: Text(
                        '${movie.title ?? 'Không có tiêu đề'} (${movie.releaseDate})'),
                    subtitle: Text(
                        'IMDB: ${movie.voteAverage}/10 - ${movie.voteCount} votes'),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
