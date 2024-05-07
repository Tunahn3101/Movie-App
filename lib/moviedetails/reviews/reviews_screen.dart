import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:movieapp/models/reviews.dart';
import 'package:provider/provider.dart';

import '../../provider/movie_details_provider.dart';
import '../../services/api.dart';
import '../../themes/theme_provider.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    //
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    //
    Color selectedColor =
        isDarkMode ? Colors.grey.shade800 : const Color(0xFFFAFAFA);
    //
    MovieDetailsProvider movieDetailsProvider =
        Provider.of<MovieDetailsProvider>(context, listen: false);

    final movieId = movieDetailsProvider.movieDetails!.id!;

    return Scaffold(
      backgroundColor: selectedColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Expanded(
          child: FutureBuilder<MovieReviews>(
            future: api.getMovieReviews(movieId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (!snapshot.hasData || snapshot.data!.results!.isEmpty) {
                return const Text('No reviews available.');
              }

              var reviews = snapshot.data!.results!;
              return ListView.builder(
                itemCount: reviews.length,
                itemBuilder: (context, index) {
                  Results review = reviews[index];
                  return ListTile(
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(IconlyBold.profile,
                            color: isDarkMode ? Colors.white : Colors.black,
                            size: 24),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${review.author}',
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${review.content}',
                                maxLines: 6,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.roboto(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
