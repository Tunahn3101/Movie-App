import 'package:flutter/material.dart';
import 'package:movieapp/models/movie.dart';

class MoviesProvider with ChangeNotifier {
  List<Movie> _movies = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  Function? currentApi; // Thêm biến này để theo dõi API hiện tại

  List<Movie> get movies => _movies;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;

  Future<void> loadMovies(Function getMoviesApi) async {
    if (currentApi != getMoviesApi) {
      // Nếu API mới khác với API hiện tại, đặt lại trạng thái và danh sách phim
      _resetMovies();
    }
    if (_movies.isNotEmpty) return; // Ngắn tải lại phim nếu phim đã được tải
    _isLoading = true;
    notifyListeners();
    try {
      final movieList = await getMoviesApi(_currentPage);
      _movies = movieList.results!;
      _isLoading = false;
      currentApi = getMoviesApi; // Cập nhật API hiện tại
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreMovies(Function getMoviesApi) async {
    if (_isLoadingMore || currentApi != getMoviesApi) {
      return; // Kiểm tra API đúng và không đang tải thêm
    }
    _isLoadingMore = true;
    notifyListeners();
    try {
      await Future.delayed(const Duration(seconds: 1));
      final movieList = await getMoviesApi(++_currentPage);
      _movies.addAll(movieList.results!);
      _isLoadingMore = false;
      currentApi = getMoviesApi; // Cập nhật API hiện tại
      notifyListeners();
    } catch (e) {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> refreshMovies(Function getMoviesApi) async {
    await Future.delayed(const Duration(seconds: 1));
    _resetMovies();
    await loadMovies(getMoviesApi);
  }

  // Đặt lại danh sách phim và trạng thái liên quan
  void _resetMovies() {
    _currentPage = 1;
    _movies.clear();
    currentApi = null;
    // Không cần gọi notifyListeners() ở đây vì nó sẽ được gọi ở loadMovies() sau khi reset
  }
}
