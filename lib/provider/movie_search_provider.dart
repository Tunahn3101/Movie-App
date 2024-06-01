import 'package:flutter/material.dart';
import 'package:movieapp/models/movie_list.dart';
import '../models/movie.dart';
import '../services/api.dart';

class MovieSearchProvider with ChangeNotifier {
  MoviesList? _searchResults;
  List<Movie>? _movieList = [];
  bool isSearching = false;
  bool isLoadingMore = false;
  int _currentPage = 1;
  String _currentQuery = '';

  List<Movie>? get movieList => _movieList;
  bool get hasMoreResults =>
      _searchResults != null && _currentPage < _searchResults!.totalPages!;

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      _movieList = [];
      isSearching = false;
      notifyListeners();
      return;
    }
    try {
      isSearching = true;
      _currentPage = 1;
      _currentQuery = query;
      notifyListeners();
      _searchResults = await api.searchMovies(query, page: _currentPage);
      _movieList = _searchResults!.results;
    } on Exception catch (e) {
      print('Error searching movies: $e');
    } finally {
      isSearching = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreMovies() async {
    if (_currentQuery.isEmpty || !hasMoreResults) return;
    try {
      isLoadingMore = true;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 1));
      final newResults =
          await api.searchMovies(_currentQuery, page: ++_currentPage);
      _movieList!.addAll(newResults.results!);
      _searchResults = newResults;
      notifyListeners();
    } on Exception catch (e) {
      print('Error loading more movies: $e');
    } finally {
      isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> refreshMovies() async {
    if (_currentQuery.isEmpty) return;
    try {
      isSearching = true;
      _currentPage = 1;
      notifyListeners();
      await Future.delayed(const Duration(seconds: 1));
      _searchResults =
          await api.searchMovies(_currentQuery, page: _currentPage);
      _movieList = _searchResults!.results;
    } on Exception catch (e) {
      print('Error refreshing movies: $e');
    } finally {
      isSearching = false;
      notifyListeners();
    }
  }
}
