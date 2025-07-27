import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:movieapp/models/details_movie_to_list.dart';
import 'package:movieapp/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LibraryProvider with ChangeNotifier {
  Dio dio = Dio(options);
  String _sessionID = '';

  // Data cho Library Screen
  DetailsMovieToList? _movieList;
  bool _isLoading = false;
  String? _error;

  // Getter để truy cập Session ID
  String get sessionID => _sessionID;

  // Getters cho Library Screen
  DetailsMovieToList? get movieList => _movieList;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Lấy Request Token
  Future<String> getRequestToken() async {
    try {
      Response response = await dio.get('/3/authentication/token/new');
      return response.data['request_token'];
    } catch (e) {
      rethrow;
    }
  }

  // Tạo Session ID
  Future<void> createSessionId(String requestToken) async {
    try {
      Response response = await dio.post(
        '/3/authentication/session/new',
        data: {
          'request_token': requestToken,
        },
      );
      _sessionID = response.data['session_id'];
      notifyListeners();

      // Lưu Session ID vào SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('sessionID', _sessionID);
    } catch (e) {
      rethrow;
    }
  }

  // Tạo danh sách mới
  // Future<int> createList(String name, String description) async {
  //   try {
  //     Response response = await dio.post(
  //       '/3/list',
  //       data: {
  //         'name': name,
  //         'description': description,
  //         'language': 'en',
  //       },
  //       queryParameters: {
  //         'session_id': _sessionID,
  //       },
  //     );
  //     int listId = response.data['id'];
  //     return listId;
  //   } catch (e) {
  //     // print('Error creating list: $e');
  //     rethrow;
  //   }
  // }

  // Thêm phim vào danh sách
  Future<void> addMovieToList(int listId, int? movieId) async {
    try {
      await dio.post(
        '/3/list/$listId/add_item',
        data: {
          'media_id': movieId,
        },
        queryParameters: {
          'session_id': _sessionID,
        },
      );
    } catch (e) {
      // print('Error adding movie to list: $e');
      rethrow;
    }
  }

  // Kiểm tra xem phim có tồn tại trong danh sách không
  Future<bool> getCheckItemStatus(int listId, int movieId) async {
    try {
      Response response = await dio.get(
        '/3/list/$listId/item_status',
        queryParameters: {
          'session_id': _sessionID,
          'movie_id': movieId,
        },
      );
      return response.data['item_present'] ?? false;
    } catch (e) {
      rethrow;
    }
  }

  // Xóa phim khỏi danh sách
  Future<void> removeMovieFromList(int listId, int movieId) async {
    try {
      await dio.post(
        '/3/list/$listId/remove_item',
        data: {
          'media_id': movieId,
        },
        queryParameters: {
          'session_id': sessionID,
        },
      );

      // Reload movie list sau khi xóa
      await loadMovieList(listId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Load movie list
  Future<void> loadMovieList(int listId) async {
    if (_isLoading) return; // Tránh load nhiều lần cùng lúc

    // Nếu đã có data thì không load lại
    if (_movieList != null &&
        _movieList!.items != null &&
        _movieList!.items!.isNotEmpty) {
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _movieList = await api.getDetailsMovieToList(listId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Refresh movie list
  Future<void> refreshMovieList(int listId) async {
    _movieList = null; // Clear cache
    await loadMovieList(listId);
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
