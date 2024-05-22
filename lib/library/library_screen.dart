import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:iconly/iconly.dart';
import 'package:movieapp/models/details_movie_to_list.dart';
import 'package:movieapp/provider/authentication_provider.dart';
import 'package:movieapp/services/api.dart';
import 'package:provider/provider.dart';

import '../moviedetails/movie_details._screen.dart';
import '../provider/movie_details_provider.dart';
import '../utils/next_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  late Future<DetailsMovieToList> detailsMovieToList;

  void _removeMoovie(int listId, int movieId) async {
    try {
      await Provider.of<AuthenticationProvider>(context, listen: false)
          .removeMovieFromList(listId, movieId);

      setState(() {
        detailsMovieToList = api.getDetailsMovieToList(8301129);
      });
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
    detailsMovieToList = api.getDetailsMovieToList(8301129);
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
      body: FutureBuilder<DetailsMovieToList>(
        future: detailsMovieToList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.items!.isNotEmpty) {
            return ListView.separated(
              itemCount: snapshot.data!.items!.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final movie = snapshot.data!.items![index];
                return Slidable(
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) {
                          _removeMoovie(8301129, movie.id!);
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
                    leading: Image.network(
                        'https://image.tmdb.org/t/p/w500${movie.posterPath}'),
                    title: Text(
                        '${movie.title ?? 'Không có tiêu đề'} (${movie.releaseDate})'),
                    subtitle: Text(
                        'IMDB: ${movie.voteAverage}/10 - ${movie.voteCount} votes'),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('Không có dữ liệu.'),
            );
          }
        },
      ),
    );
  }
}
