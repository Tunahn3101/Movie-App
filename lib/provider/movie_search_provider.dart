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

  // Data cho SliderImage (Top Rated Movies)
  List<Movie> _sliderMovies = [];
  bool _isLoadingSlider = false;

  // Data cho TrendingMoviesWeek
  List<Movie> _trendingWeekMovies = [];
  bool _isLoadingTrendingWeek = false;

  List<Movie>? get movieList => _movieList;
  bool get hasMoreResults =>
      _searchResults != null && _currentPage < _searchResults!.totalPages!;

  // Getters cho SliderImage
  List<Movie> get sliderMovies => _sliderMovies;
  bool get isLoadingSlider => _isLoadingSlider;

  // Getters cho TrendingMoviesWeek
  List<Movie> get trendingWeekMovies => _trendingWeekMovies;
  bool get isLoadingTrendingWeek => _isLoadingTrendingWeek;

  // Getter cho loading chung
  bool get isLoadingInitialData => _isLoadingSlider || _isLoadingTrendingWeek;

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

  // Load data cho SliderImage (Top Rated Movies)
  Future<void> loadSliderMovies() async {
    if (_sliderMovies.isNotEmpty) return; // Nếu đã có data thì không load lại

    _isLoadingSlider = true;
    notifyListeners();

    try {
      final moviesList = await api.getTopRatedMovies();
      _sliderMovies = moviesList.results ?? [];
      _isLoadingSlider = false;
      notifyListeners();
    } catch (e) {
      print('Error loading slider movies: $e');
      _isLoadingSlider = false;
      notifyListeners();
    }
  }

  // Load data cho TrendingMoviesWeek
  Future<void> loadTrendingWeekMovies() async {
    if (_trendingWeekMovies.isNotEmpty)
      return; // Nếu đã có data thì không load lại

    _isLoadingTrendingWeek = true;
    notifyListeners();

    try {
      final moviesList = await api.getTrendingMoviesWeek(1);
      _trendingWeekMovies = moviesList.results ?? [];
      _isLoadingTrendingWeek = false;
      notifyListeners();
    } catch (e) {
      print('Error loading trending week movies: $e');
      _isLoadingTrendingWeek = false;
      notifyListeners();
    }
  }

  // Refresh data cho SliderImage
  Future<void> refreshSliderMovies() async {
    _sliderMovies.clear();
    await loadSliderMovies();
  }

  // Refresh data cho TrendingMoviesWeek
  Future<void> refreshTrendingWeekMovies() async {
    _trendingWeekMovies.clear();
    await loadTrendingWeekMovies();
  }
}
