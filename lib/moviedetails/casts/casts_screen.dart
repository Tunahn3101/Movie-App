import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../models/cast.dart';
import '../../provider/movie_details_provider.dart';
import '../../services/api.dart';
import '../../themes/theme_provider.dart';

class CastsScreen extends StatefulWidget {
  const CastsScreen({super.key});

  @override
  State<CastsScreen> createState() => _CastsScreenState();
}

class _CastsScreenState extends State<CastsScreen> {
  @override
  Widget build(BuildContext context) {
    //
    MovieDetailsProvider movieDetailsProvider =
        Provider.of<MovieDetailsProvider>(context, listen: false);
    //
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    //
    Color selectedColor =
        isDarkMode ? Colors.grey.shade800 : const Color(0xFFFAFAFA);
    return Scaffold(
      backgroundColor: selectedColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Casts',
              style: GoogleFonts.roboto(
                textStyle:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            FutureBuilder<CastList>(
              future: api.getCast(movieDetailsProvider.movieDetails!.id!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (!snapshot.hasData || snapshot.data!.cast!.isEmpty) {
                  return const Text('No cast members available.');
                }
                var castList = snapshot.data!.cast!;
                return Expanded(
                  child: SizedBox(
                    height: 210, // Chiều cao tổng của danh sách
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: castList.length,
                      itemBuilder: (context, index) {
                        Cast cast = castList[index];
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
