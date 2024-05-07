import 'package:flutter/material.dart';
import 'package:movieapp/models/movie_list.dart';

import '../services/api.dart';

class MovieSearchProvider with ChangeNotifier {
  MoviesList? searchResults;
  bool isSearching = false;

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      searchResults = null;
      isSearching = false;
      notifyListeners();
      return;
    }
    try {
      isSearching = true;
      notifyListeners();
      searchResults = await api.searchMovies(query);
    } on Exception catch (e) {
      print('Error searching movies: $e');
    } finally {
      isSearching = false;
      notifyListeners();
    }
  }
}
