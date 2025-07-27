import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../provider/movie_details_provider.dart';
import '../../themes/theme_provider.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({super.key});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    Color selectedColor =
        isDarkMode ? Colors.grey.shade800 : const Color(0xFFFAFAFA);

    return Scaffold(
      backgroundColor: selectedColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Consumer<MovieDetailsProvider>(
          builder: (context, provider, child) {
            if (provider.isLoadingReviews) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.reviewsError != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${provider.reviewsError}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        provider.clearReviewsError();
                        if (provider.movieDetails?.id != null) {
                          provider.loadReviewsData(provider.movieDetails!.id!);
                        }
                      },
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            }

            if (provider.reviewsList?.results == null ||
                provider.reviewsList!.results!.isEmpty) {
              return const Center(
                child: Text('No reviews available.'),
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              itemCount: provider.reviewsList!.results!.length,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                final review = provider.reviewsList!.results![index];
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
    );
  }
}
