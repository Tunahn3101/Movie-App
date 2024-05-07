import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:movieapp/provider/movie_details_provider.dart';
import 'package:provider/provider.dart';

import '../../themes/theme_provider.dart';

class InfoScreen extends StatefulWidget {
  const InfoScreen({
    super.key,
  });

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  String formatNumber(num number) {
    final format = NumberFormat('#,##0', 'en_US');
    return format.format(number);
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    Color selectedColor =
        isDarkMode ? Colors.grey.shade800 : const Color(0xFFFAFAFA);

    return Scaffold(
        backgroundColor: selectedColor,
        body: Consumer<MovieDetailsProvider>(
          builder: (context, provider, child) {
            final movieDetails = provider.movieDetails;
            if (movieDetails == null) {
              return const CircularProgressIndicator();
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overviews',
                      style: GoogleFonts.roboto(
                        textStyle: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('${movieDetails.overview}'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Budget:',
                          style: GoogleFonts.roboto(),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '💲${formatNumber(movieDetails.budget as num)}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Revenue:',
                          style: GoogleFonts.roboto(),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '💲${formatNumber(movieDetails.revenue as num)}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          'Status:',
                          style: GoogleFonts.roboto(),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${movieDetails.status}',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Available on:',
                      style: GoogleFonts.roboto(),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const SizedBox(width: 4),
                          SizedBox(
                            height: 34,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black),
                                onPressed: () {},
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/netflix.png',
                                      fit: BoxFit.cover,
                                    ),
                                    const Text(
                                      'Netflix',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                )),
                          ),
                          // const SizedBox(width: 11),
                          // SizedBox(
                          //   height: 34,
                          //   child: ElevatedButton(
                          //       style: ElevatedButton.styleFrom(
                          //           backgroundColor: Colors.blue),
                          //       onPressed: () {},
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           Image.asset(
                          //             'assets/images/disney.png',
                          //             fit: BoxFit.cover,
                          //           ),
                          //           const Text(
                          //             'Hotstart+',
                          //             style: TextStyle(
                          //               color: Colors.white,
                          //             ),
                          //           )
                          //         ],
                          //       )),
                          // ),
                          const SizedBox(width: 11),
                          SizedBox(
                            height: 34,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red),
                                onPressed: () {},
                                child: Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/youtobe.png',
                                      fit: BoxFit.cover,
                                    ),
                                    const Text(
                                      'Youtube',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                )),
                          ),
                          const SizedBox(width: 4),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
