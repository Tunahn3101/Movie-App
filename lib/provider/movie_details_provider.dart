import 'package:flutter/material.dart';
import 'package:movieapp/models/movie_details_model.dart';
import 'package:movieapp/services/api.dart';

class MovieDetailsProvider with ChangeNotifier {
  MovieDetailsModel? movieDetails;

  Future<void> fetchMoviesDetails(int movieId) async {
    movieDetails = null;
    notifyListeners();
    try {
      movieDetails = await api.getMovie(movieId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }
}
