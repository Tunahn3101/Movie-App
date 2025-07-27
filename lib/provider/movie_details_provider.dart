import 'package:flutter/material.dart';
import 'package:movieapp/models/movie_details_model.dart';
import 'package:movieapp/models/cast.dart';
import 'package:movieapp/models/reviews.dart';
import 'package:movieapp/services/api.dart';

class MovieDetailsProvider with ChangeNotifier {
  MovieDetailsModel? movieDetails;
  
  // Data cho CastsScreen
  CastList? _castList;
  bool _isLoadingCast = false;
  String? _castError;
  
  // Data cho ReviewsScreen
  MovieReviews? _reviewsList;
  bool _isLoadingReviews = false;
  String? _reviewsError;

  // Getters cho CastsScreen
  CastList? get castList => _castList;
  bool get isLoadingCast => _isLoadingCast;
  String? get castError => _castError;

  // Getters cho ReviewsScreen
  MovieReviews? get reviewsList => _reviewsList;
  bool get isLoadingReviews => _isLoadingReviews;
  String? get reviewsError => _reviewsError;

  Future<void> fetchMoviesDetails(int movieId) async {
    movieDetails = null;
    try {
      movieDetails = await api.getMovie(movieId);
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  // Load cast data
  Future<void> loadCastData(int movieId) async {
    if (_isLoadingCast) return; // Tránh load nhiều lần cùng lúc
    
    // Nếu đã có data thì không load lại
    if (_castList != null && _castList!.cast != null && _castList!.cast!.isNotEmpty) {
      return;
    }
    
    _isLoadingCast = true;
    _castError = null;
    notifyListeners();
    
    try {
      _castList = await api.getCast(movieId);
      _isLoadingCast = false;
      notifyListeners();
    } catch (e) {
      _castError = e.toString();
      _isLoadingCast = false;
      notifyListeners();
      rethrow;
    }
  }

  // Load reviews data
  Future<void> loadReviewsData(int movieId) async {
    if (_isLoadingReviews) return; // Tránh load nhiều lần cùng lúc
    
    // Nếu đã có data thì không load lại
    if (_reviewsList != null && _reviewsList!.results != null && _reviewsList!.results!.isNotEmpty) {
      return;
    }
    
    _isLoadingReviews = true;
    _reviewsError = null;
    notifyListeners();
    
    try {
      _reviewsList = await api.getMovieReviews(movieId);
      _isLoadingReviews = false;
      notifyListeners();
    } catch (e) {
      _reviewsError = e.toString();
      _isLoadingReviews = false;
      notifyListeners();
      rethrow;
    }
  }

  // Refresh cast data
  Future<void> refreshCastData(int movieId) async {
    _castList = null; // Clear cache
    await loadCastData(movieId);
  }

  // Refresh reviews data
  Future<void> refreshReviewsData(int movieId) async {
    _reviewsList = null; // Clear cache
    await loadReviewsData(movieId);
  }

  // Clear cast error
  void clearCastError() {
    _castError = null;
    notifyListeners();
  }

  // Clear reviews error
  void clearReviewsError() {
    _reviewsError = null;
    notifyListeners();
  }
}
