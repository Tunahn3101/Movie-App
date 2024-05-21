import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:movieapp/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider with ChangeNotifier {
  Dio dio = Dio(options);
  String _sessionID = '';

  // Getter để truy cập Session ID
  String get sessionID => _sessionID;

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
  Future<int> createList(String name, String description) async {
    try {
      Response response = await dio.post(
        '/3/list',
        data: {
          'name': name,
          'description': description,
          'language': 'en',
        },
        queryParameters: {
          'session_id': _sessionID,
        },
      );
      int listId = response.data['id'];
      return listId;
    } catch (e) {
      // print('Error creating list: $e');
      rethrow;
    }
  }

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
}
