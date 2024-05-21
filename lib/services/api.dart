import 'package:dio/dio.dart';
import 'package:movieapp/models/reviews.dart';

import '../models/cast.dart';
import '../models/movie_details_model.dart';
import '../models/movie_list.dart';
import '../utils/constants.dart';

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

  dynamic _handleResponse(Response response) {
    if (response.statusCode == 200) {
      // OK
      return response.data;
    } else {
      // Lỗi từ phía server
      throw Exception('Lỗi từ server: ${response.statusCode}');
    }
  }

  Future<MoviesList> getPopularMovies({
    String language = 'en-US',
    int page = 1,
    String region = '',
  }) async {
    try {
      var response = await dio.get(
        '/3/movie/popular',
      );
      var data = _handleResponse(response);
      return MoviesList.fromJson(data);
    } on DioException catch (e) {
      // Lỗi từ phía server hoặc lỗi network
      var message = e.response != null
          ? 'Lỗi từ server: ${e.response?.statusCode}'
          : 'Lỗi kết nối mạng.';
      throw Exception(message);
    } on Exception {
      rethrow;
    }
  }

  Future<MoviesList> getTopRatedMovies({
    String language = 'en-US',
    int page = 1,
    String region = '',
  }) async {
    try {
      var response = await dio.get(
        '/3/movie/top_rated',
      );
      var data = _handleResponse(response);

      return MoviesList.fromJson(data);
    } on DioException catch (e) {
      // Lỗi từ phía server hoặc lỗi network
      var message = e.response != null
          ? 'Lỗi từ server: ${e.response?.statusCode}'
          : 'Lỗi kết nối mạng.';
      throw Exception(message);
    } on Exception {
      rethrow;
    }
  }

  Future<MoviesList> getUpComingMovies({
    String language = 'en-US',
    int page = 1,
    String region = '',
  }) async {
    try {
      var response = await dio.get(
        '/3/movie/upcoming',
      );
      var data = _handleResponse(response);

      return MoviesList.fromJson(data);
    } on DioException catch (e) {
      // Lỗi từ phía server hoặc lỗi network
      var message = e.response != null
          ? 'Lỗi từ server: ${e.response?.statusCode}'
          : 'Lỗi kết nối mạng.';
      throw Exception(message);
    } on Exception {
      rethrow;
    }
  }

  Future<MoviesList> searchMovies(
    String query, {
    String language = 'en-US',
    int page = 1,
    String region = '',
    bool includeAdult = false,
    int? year,
    int? primaryReleaseYear,
  }) async {
    try {
      var response = await dio.get(
        '/3/search/movie',
        queryParameters: {
          "query": query,
          "language": language,
          "page": page,
          "region": region,
          "include_adult": includeAdult,
          "year": year,
          "primary_release_year": primaryReleaseYear,
        },
      );
      var data = _handleResponse(response);

      return MoviesList.fromJson(data);
    } on DioException catch (e) {
      // Lỗi từ phía server hoặc lỗi network
      var message = e.response != null
          ? 'Lỗi từ server: ${e.response?.statusCode}'
          : 'Lỗi kết nối mạng.';
      throw Exception(message);
    } on Exception {
      rethrow;
    }
  }

  Future<MoviesList> getNowPlayingList({
    String language = 'en-US',
    int page = 1,
    String region = '',
  }) async {
    try {
      var response = await dio.get(
        '/3/movie/now_playing',
        queryParameters: {
          "language": language,
          "page": page,
          "region": region,
        },
      );
      var data = _handleResponse(response);

      return MoviesList.fromJson(data);
    } on DioException catch (e) {
      // Lỗi từ phía server hoặc lỗi network
      var message = e.response != null
          ? 'Lỗi từ server: ${e.response?.statusCode}'
          : 'Lỗi kết nối mạng.';
      throw Exception(message);
    } on Exception {
      rethrow;
    }
  }

  Future<CastList> getCast(
    int movieId,
  ) async {
    try {
      var response = await dio.get(
        '/3/movie/$movieId/credits',
      );
      var data = _handleResponse(response);

      return CastList.fromJson(data);
    } on DioException catch (e) {
      // Lỗi từ phía server hoặc lỗi network
      var message = e.response != null
          ? 'Lỗi từ server: ${e.response?.statusCode}'
          : 'Lỗi kết nối mạng.';
      throw Exception(message);
    } on Exception {
      rethrow;
    }
  }

  Future<MovieDetailsModel> getMovie(
    int movieId, {
    String? language,
    String appendToResponse = 'videos',
  }) async {
    try {
      var response = await dio.get(
        '/3/movie/$movieId',
        queryParameters: {
          "language": language,
          "append_to_response": appendToResponse,
        },
      );
      var data = _handleResponse(response);

      return MovieDetailsModel.fromJson(data);
    } on DioException catch (e) {
      // Lỗi từ phía server hoặc lỗi network
      var message = e.response != null
          ? 'Lỗi từ server: ${e.response?.statusCode}'
          : 'Lỗi kết nối mạng.';
      throw Exception(message);
    } on Exception {
      rethrow;
    }
  }

  Future<MovieReviews> getMovieReviews(int movieId) async {
    try {
      var response = await dio.get(
        '/3/movie/$movieId/reviews',
      );
      var data = _handleResponse(response);

      return MovieReviews.fromJson(data);
    } on DioException catch (e) {
      // Lỗi từ phía server hoặc lỗi network
      var message = e.response != null
          ? 'Lỗi từ server: ${e.response?.statusCode}'
          : 'Lỗi kết nối mạng.';
      throw Exception(message);
    } on Exception {
      rethrow;
    }
  }

  Future<MoviesList> getTrendingMoviesDay({
    String timewindow = 'day',
    String language = 'en-US',
  }) async {
    try {
      var response = await dio.get(
        '/3/trending/movie/$timewindow',
        queryParameters: {
          "language": language,
        },
      );
      var data = _handleResponse(response);

      return MoviesList.fromJson(data);
    } on DioException catch (e) {
      // Lỗi từ phía server hoặc lỗi network
      var message = e.response != null
          ? 'Lỗi từ server: ${e.response?.statusCode}'
          : 'Lỗi kết nối mạng.';
      throw Exception(message);
    } on Exception {
      rethrow;
    }
  }

  Future<MoviesList> getTrendingMoviesWeek({
    String timewindow = 'week',
    String language = 'en-US',
  }) async {
    try {
      var response = await dio.get(
        '/3/trending/movie/$timewindow',
        queryParameters: {
          "language": language,
        },
      );
      var data = _handleResponse(response);

      return MoviesList.fromJson(data);
    } on DioException catch (e) {
      // Lỗi từ phía server hoặc lỗi network
      var message = e.response != null
          ? 'Lỗi từ server: ${e.response?.statusCode}'
          : 'Lỗi kết nối mạng.';
      throw Exception(message);
    } on Exception {
      rethrow;
    }
  }

  get(String s) {}

  post(String s, {required Map<String, String> data}) {}
}
