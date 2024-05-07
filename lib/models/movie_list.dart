import 'movie.dart';

class MoviesList {
  int? page;
  List<Movie>? results;
  int? totalPages;
  int? totalResults;

  MoviesList({
    this.page,
    this.results,
    this.totalPages,
    this.totalResults,
  });

  MoviesList.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    totalResults = json['total_results'];
    totalPages = json['total_pages'];
    if (json['results'] != null) {
      results = <Movie>[];
      json['results'].forEach((v) {
        results?.add(Movie.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['page'] = page;
    data['total_results'] = totalResults;
    data['total_pages'] = totalPages;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
