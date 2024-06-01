import 'package:dio/dio.dart';
import 'package:movieapp/models/details_movie_to_list.dart';
import 'package:movieapp/models/reviews.dart';

import '../models/cast.dart';
import '../models/movie_details_model.dart';
import '../models/movie_list.dart';
import '../utils/constants.dart';

/// Đặt cấu hình cơ bản cho Dio
BaseOptions options = BaseOptions(
  baseUrl: "https://api.themoviedb.org",
  headers: {
    'Authorization': 'Bearer ${MoviesApi.apiKey}',
  },
);

MoviesApi api = MoviesApi();

class MoviesApi {
  Dio dio = Dio(options);
  static const String apiKey = movieDbKey;

  /// Xử lý phản hồi từ API
  dynamic _handleResponse(Response response) {
    if (response.statusCode == 200) {
      // OK
      return response.data;
    } else {
      throw Exception('Lỗi từ server: ${response.statusCode}');
    }
  }

  /// Xử lý lỗi từ Dio
  Exception _handleDioError(DioException e) {
    var message = e.response != null
        ? 'Lỗi từ server: ${e.response?.statusCode}'
        : 'Lỗi kết nối mạng.';
    return Exception(message);
  }

  Future<MoviesList> getPopularMovies(
    int? page, {
    String language = 'en-US',
    // int page = 1,
    String region = '',
  }) async {
    return _getMoviesList('/3/movie/popular?page=$page');
  }

  Future<MoviesList> getTopRatedMovies({
    String language = 'en-US',
    int page = 1,
    String region = '',
  }) async {
    return _getMoviesList('/3/movie/top_rated');
  }

  Future<MoviesList> getUpComingMovies(
    int? page, {
    String language = 'en-US',
    String region = '',
  }) async {
    return _getMoviesList('/3/movie/upcoming?page=$page');
  }

  Future<MoviesList> getNowPlayingList(
    int? page, {
    String language = 'en-US',
    String region = '',
  }) async {
    return _getMoviesList('/3/movie/now_playing?page=$page');
  }

  /// Tạo hàm chung để lấy danh sách phim
  Future<MoviesList> _getMoviesList(String endpoint,
      {Map<String, dynamic>? params}) async {
    try {
      var response = await dio.get(endpoint, queryParameters: params);
      var data = _handleResponse(response);
      return MoviesList.fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on Exception {
      rethrow;
    }
  }

  Future<CastList> getCast(int movieId) async {
    return _getData(
        '/3/movie/$movieId/credits', (data) => CastList.fromJson(data));
  }

  Future<MovieDetailsModel> getMovie(
    int movieId, {
    String? language,
    String appendToResponse = 'videos',
  }) async {
    return _getData(
        '/3/movie/$movieId', (data) => MovieDetailsModel.fromJson(data),
        params: {
          'language': language,
          'append_to_response': appendToResponse,
        });
  }

  Future<MovieReviews> getMovieReviews(int movieId) async {
    return _getData(
        '/3/movie/$movieId/reviews', (data) => MovieReviews.fromJson(data));
  }

  Future<MoviesList> searchMovies(
    String query, {
    String language = 'en-US',
    int? page,
    String region = '',
    bool includeAdult = false,
    int? year,
    int? primaryReleaseYear,
  }) async {
    return _getData(
        '/3/search/movie?page=$page', (data) => MoviesList.fromJson(data),
        params: {
          'query': query,
          'language': language,
          'region': region,
          'include_adult': includeAdult,
          'year': year,
          'primary_release_year': primaryReleaseYear,
        });
  }

  Future<MoviesList> getTrendingMoviesDay(
    int? page, {
    String timewindow = 'day',
    String language = 'en-US',
  }) async {
    return _getTrendingMovies(
        timewindow: timewindow, language: language, page: page);
  }

  Future<MoviesList> getTrendingMoviesWeek(
    int? page, {
    String timewindow = 'week',
    String language = 'en-US',
  }) async {
    return _getTrendingMovies(
        timewindow: timewindow, language: language, page: page);
  }

  Future<MoviesList> _getTrendingMovies({
    required String timewindow,
    required String language,
    required int? page,
  }) async {
    return _getData('/3/trending/movie/$timewindow?page=$page',
        (data) => MoviesList.fromJson(data),
        params: {
          'language': language,
        });
  }

  // Lấy danh sách phim được thêm vào List
  Future<DetailsMovieToList> getDetailsMovieToList(
    int listId, {
    String language = 'en-US',
    int page = 1,
  }) async {
    return _getData(
        '/3/list/$listId', (data) => DetailsMovieToList.fromJson(data),
        params: {
          'language': language,
          'page': page,
        });
  }

  /// Hàm chung để lấy và xử lý dữ liệu
  Future<T> _getData<T>(String endpoint, T Function(dynamic data) fromJson,
      {Map<String, dynamic>? params}) async {
    try {
      var response = await dio.get(endpoint, queryParameters: params);
      var data = _handleResponse(response);
      return fromJson(data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    } on Exception {
      rethrow;
    }
  }
}
