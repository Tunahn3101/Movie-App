import 'package:flutter/material.dart';
import 'package:movieapp/models/movie.dart';
import 'package:movieapp/services/api.dart';

class MoviesProvider with ChangeNotifier {
  // 4 list riêng cho 4 tab
  List<Movie> _forYouMovies = [];
  List<Movie> _trendingMovies = [];
  List<Movie> _upcomingMovies = [];
  List<Movie> _nowPlayingMovies = [];

  // List riêng cho DetailsTrendingMovieWeek
  List<Movie> _detailsTrendingWeekMovies = [];

  // Loading states cho từng tab
  bool _isLoadingForYou = false;
  bool _isLoadingTrending = false;
  bool _isLoadingUpcoming = false;
  bool _isLoadingNowPlaying = false;

  // Loading states cho DetailsTrendingMovieWeek
  bool _isLoadingDetailsTrendingWeek = false;
  bool _isLoadingMoreDetailsTrendingWeek = false;

  // Loading more states cho từng tab
  bool _isLoadingMoreForYou = false;
  bool _isLoadingMoreTrending = false;
  bool _isLoadingMoreUpcoming = false;
  bool _isLoadingMoreNowPlaying = false;

  // Current page cho từng tab
  int _currentPageForYou = 1;
  int _currentPageTrending = 1;
  int _currentPageUpcoming = 1;
  int _currentPageNowPlaying = 1;

  // Current page cho DetailsTrendingMovieWeek
  int _currentPageDetailsTrendingWeek = 1;

  // Getters cho movies
  List<Movie> get forYouMovies => _forYouMovies;
  List<Movie> get trendingMovies => _trendingMovies;
  List<Movie> get upcomingMovies => _upcomingMovies;
  List<Movie> get nowPlayingMovies => _nowPlayingMovies;

  // Getters cho DetailsTrendingMovieWeek
  List<Movie> get detailsTrendingWeekMovies => _detailsTrendingWeekMovies;
  bool get isLoadingDetailsTrendingWeek => _isLoadingDetailsTrendingWeek;
  bool get isLoadingMoreDetailsTrendingWeek =>
      _isLoadingMoreDetailsTrendingWeek;

  // Getters cho loading states
  bool get isLoadingForYou => _isLoadingForYou;
  bool get isLoadingTrending => _isLoadingTrending;
  bool get isLoadingUpcoming => _isLoadingUpcoming;
  bool get isLoadingNowPlaying => _isLoadingNowPlaying;

  // Getters cho loading more states
  bool get isLoadingMoreForYou => _isLoadingMoreForYou;
  bool get isLoadingMoreTrending => _isLoadingMoreTrending;
  bool get isLoadingMoreUpcoming => _isLoadingMoreUpcoming;
  bool get isLoadingMoreNowPlaying => _isLoadingMoreNowPlaying;

  // Hàm load movies cho For You tab
  Future<void> loadForYouMovies() async {
    if (_forYouMovies.isNotEmpty) return; // Nếu đã có data thì không load lại
    _isLoadingForYou = true;
    notifyListeners();
    try {
      final movieList = await api.getPopularMovies(_currentPageForYou);
      _forYouMovies = movieList.results!;
      _isLoadingForYou = false;
      notifyListeners();
    } catch (e) {
      _isLoadingForYou = false;
      notifyListeners();
    }
  }

  // Hàm load more movies cho For You tab
  Future<void> loadMoreForYouMovies() async {
    if (_isLoadingMoreForYou) return;
    _isLoadingMoreForYou = true;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 1));
      final movieList = await api.getPopularMovies(++_currentPageForYou);
      _forYouMovies.addAll(movieList.results!);
      _isLoadingMoreForYou = false;
      notifyListeners();
    } catch (e) {
      _isLoadingMoreForYou = false;
      notifyListeners();
    }
  }

  // Hàm refresh movies cho For You tab
  Future<void> refreshForYouMovies() async {
    _currentPageForYou = 1;
    _forYouMovies.clear();
    await loadForYouMovies();
  }

  // Hàm load movies cho Trending tab
  Future<void> loadTrendingMovies() async {
    if (_trendingMovies.isNotEmpty) return;
    _isLoadingTrending = true;
    notifyListeners();
    try {
      final movieList = await api.getTrendingMoviesDay(_currentPageTrending);
      _trendingMovies = movieList.results!;
      _isLoadingTrending = false;
      notifyListeners();
    } catch (e) {
      _isLoadingTrending = false;
      notifyListeners();
    }
  }

  // Hàm load more movies cho Trending tab
  Future<void> loadMoreTrendingMovies() async {
    if (_isLoadingMoreTrending) return;
    _isLoadingMoreTrending = true;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 1));
      final movieList = await api.getTrendingMoviesDay(++_currentPageTrending);
      _trendingMovies.addAll(movieList.results!);
      _isLoadingMoreTrending = false;
      notifyListeners();
    } catch (e) {
      _isLoadingMoreTrending = false;
      notifyListeners();
    }
  }

  // Hàm refresh movies cho Trending tab
  Future<void> refreshTrendingMovies() async {
    _currentPageTrending = 1;
    _trendingMovies.clear();
    await loadTrendingMovies();
  }

  // Hàm load movies cho Upcoming tab
  Future<void> loadUpcomingMovies() async {
    if (_upcomingMovies.isNotEmpty) return;
    _isLoadingUpcoming = true;
    notifyListeners();
    try {
      final movieList = await api.getUpComingMovies(_currentPageUpcoming);
      _upcomingMovies = movieList.results!;
      _isLoadingUpcoming = false;
      notifyListeners();
    } catch (e) {
      _isLoadingUpcoming = false;
      notifyListeners();
    }
  }

  // Hàm load more movies cho Upcoming tab
  Future<void> loadMoreUpcomingMovies() async {
    if (_isLoadingMoreUpcoming) return;
    _isLoadingMoreUpcoming = true;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 1));
      final movieList = await api.getUpComingMovies(++_currentPageUpcoming);
      _upcomingMovies.addAll(movieList.results!);
      _isLoadingMoreUpcoming = false;
      notifyListeners();
    } catch (e) {
      _isLoadingMoreUpcoming = false;
      notifyListeners();
    }
  }

  // Hàm refresh movies cho Upcoming tab
  Future<void> refreshUpcomingMovies() async {
    _currentPageUpcoming = 1;
    _upcomingMovies.clear();
    await loadUpcomingMovies();
  }

  // Hàm load movies cho Now Playing tab
  Future<void> loadNowPlayingMovies() async {
    if (_nowPlayingMovies.isNotEmpty) return;
    _isLoadingNowPlaying = true;
    notifyListeners();
    try {
      final movieList = await api.getNowPlayingList(_currentPageNowPlaying);
      _nowPlayingMovies = movieList.results!;
      _isLoadingNowPlaying = false;
      notifyListeners();
    } catch (e) {
      _isLoadingNowPlaying = false;
      notifyListeners();
    }
  }

  // Hàm load more movies cho Now Playing tab
  Future<void> loadMoreNowPlayingMovies() async {
    if (_isLoadingMoreNowPlaying) return;
    _isLoadingMoreNowPlaying = true;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 1));
      final movieList = await api.getNowPlayingList(++_currentPageNowPlaying);
      _nowPlayingMovies.addAll(movieList.results!);
      _isLoadingMoreNowPlaying = false;
      notifyListeners();
    } catch (e) {
      _isLoadingMoreNowPlaying = false;
      notifyListeners();
    }
  }

  // Hàm refresh movies cho Now Playing tab
  Future<void> refreshNowPlayingMovies() async {
    _currentPageNowPlaying = 1;
    _nowPlayingMovies.clear();
    await loadNowPlayingMovies();
  }

  // Hàm load movies cho DetailsTrendingMovieWeek
  Future<void> loadDetailsTrendingWeekMovies() async {
    if (_detailsTrendingWeekMovies.isNotEmpty) {
      return; // Nếu đã có data thì không load lại
    }

    _isLoadingDetailsTrendingWeek = true;
    notifyListeners();
    try {
      final movieList =
          await api.getTrendingMoviesWeek(_currentPageDetailsTrendingWeek);
      _detailsTrendingWeekMovies = movieList.results!;
      _isLoadingDetailsTrendingWeek = false;
      notifyListeners();
    } catch (e) {
      _isLoadingDetailsTrendingWeek = false;
      notifyListeners();
    }
  }

  // Hàm load more movies cho DetailsTrendingMovieWeek
  Future<void> loadMoreDetailsTrendingWeekMovies() async {
    if (_isLoadingMoreDetailsTrendingWeek) return;
    _isLoadingMoreDetailsTrendingWeek = true;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 1));
      final movieList =
          await api.getTrendingMoviesWeek(++_currentPageDetailsTrendingWeek);
      _detailsTrendingWeekMovies.addAll(movieList.results!);
      _isLoadingMoreDetailsTrendingWeek = false;
      notifyListeners();
    } catch (e) {
      _isLoadingMoreDetailsTrendingWeek = false;
      notifyListeners();
    }
  }

  // Hàm refresh movies cho DetailsTrendingMovieWeek
  Future<void> refreshDetailsTrendingWeekMovies() async {
    _currentPageDetailsTrendingWeek = 1;
    _detailsTrendingWeekMovies.clear();
    await loadDetailsTrendingWeekMovies();
  }

  // Legacy methods để backward compatibility (nếu cần)
  List<Movie> get movies => _forYouMovies; // Default to For You movies
  bool get isLoading => _isLoadingForYou;
  bool get isLoadingMore => _isLoadingMoreForYou;

  Future<void> loadMovies(Function getMoviesApi) async {
    await loadForYouMovies();
  }

  Future<void> loadMoreMovies(Function getMoviesApi) async {
    await loadMoreForYouMovies();
  }

  Future<void> refreshMovies(Function getMoviesApi) async {
    await refreshForYouMovies();
  }
}
