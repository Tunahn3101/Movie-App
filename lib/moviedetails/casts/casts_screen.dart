import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../provider/movie_details_provider.dart';
import '../../themes/theme_provider.dart';

class CastsScreen extends StatefulWidget {
  const CastsScreen({super.key});

  @override
  State<CastsScreen> createState() => _CastsScreenState();
}

class _CastsScreenState extends State<CastsScreen> {
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
            if (provider.isLoadingCast) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.castError != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${provider.castError}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        provider.clearCastError();
                        if (provider.movieDetails?.id != null) {
                          provider.loadCastData(provider.movieDetails!.id!);
                        }
                      },
                      child: const Text('Thử lại'),
                    ),
                  ],
                ),
              );
            }

            if (provider.castList?.cast == null ||
                provider.castList!.cast!.isEmpty) {
              return const Center(
                child: Text('No cast members available.'),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Casts',
                  style: GoogleFonts.roboto(
                    textStyle: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: SizedBox(
                    height: 210, // Chiều cao tổng của danh sách
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: provider.castList!.cast!.length,
                      itemBuilder: (context, index) {
                        final cast = provider.castList!.cast![index];
                        return Container(
                          width: 115, // Chiều rộng cố định cho ảnh
                          margin: const EdgeInsets.only(right: 8),
                          child: Column(
                            children: [
                              Container(
                                width: 115, // Chiều rộng ảnh cố định
                                height: 156, // Chiều cao ảnh cố định
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                      'https://image.tmdb.org/t/p/w500/${cast.profilePath}',
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                cast.name ?? 'Unnamed actor',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
