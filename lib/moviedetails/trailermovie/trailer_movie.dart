import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../provider/movie_details_provider.dart';

class TrailerMovie extends StatefulWidget {
  const TrailerMovie({super.key});

  @override
  State<TrailerMovie> createState() => _TrailerMovieState();
}

class _TrailerMovieState extends State<TrailerMovie> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    final movieDetailsProvider =
        Provider.of<MovieDetailsProvider>(context, listen: false);
    // Kết quả API cung cấp 'key' cho video
    String videoKey =
        movieDetailsProvider.movieDetails!.videos!.results![0].key!;

    // Khởi tạo YoutubePlayerController
    _controller = YoutubePlayerController(
      initialVideoId: videoKey,
      flags: const YoutubePlayerFlags(autoPlay: true),
    );

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // Đảm bảo dispose controller khi widget bị loại bỏ
    _controller.dispose();
    super.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      // Người dùng YoutubePlayer và controller đã được khởi tạo trong initState
      body: Center(
        child: YoutubePlayer(
          controller: _controller,
          // showVideoProgressIndicator: true,
          // progressIndicatorColor: Colors.amber,
          progressColors: const ProgressBarColors(
            playedColor: Colors.red,
            handleColor: Colors.red,
          ),
          onReady: () {
            // Hành động cần thiết khi player sẵn sàng, nếu có
          },
        ),
      ),
    );
  }
}
