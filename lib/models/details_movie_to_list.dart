class DetailsMovieToList {
  String? createdBy;
  String? description;
  int? favoriteCount;
  int? id;
  String? iso6391;
  int? itemCount;
  List<Items>? items;
  String? name;
  int? page;
  Null posterPath;
  int? totalPages;
  int? totalResults;

  DetailsMovieToList(
      {this.createdBy,
      this.description,
      this.favoriteCount,
      this.id,
      this.iso6391,
      this.itemCount,
      this.items,
      this.name,
      this.page,
      this.posterPath,
      this.totalPages,
      this.totalResults});

  DetailsMovieToList.fromJson(Map<String, dynamic> json) {
    createdBy = json['created_by'];
    description = json['description'];
    favoriteCount = json['favorite_count'];
    id = json['id'];
    iso6391 = json['iso_639_1'];
    itemCount = json['item_count'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    name = json['name'];
    page = json['page'];
    posterPath = json['poster_path'];
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['created_by'] = createdBy;
    data['description'] = description;
    data['favorite_count'] = favoriteCount;
    data['id'] = id;
    data['iso_639_1'] = iso6391;
    data['item_count'] = itemCount;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['name'] = name;
    data['page'] = page;
    data['poster_path'] = posterPath;
    data['total_pages'] = totalPages;
    data['total_results'] = totalResults;
    return data;
  }
}

class Items {
  String? backdropPath;
  int? id;
  String? originalTitle;
  String? overview;
  String? posterPath;
  String? mediaType;
  bool? adult;
  String? title;
  String? originalLanguage;
  List<int>? genreIds;
  double? popularity;
  String? releaseDate;
  bool? video;
  double? voteAverage;
  int? voteCount;

  Items(
      {this.backdropPath,
      this.id,
      this.originalTitle,
      this.overview,
      this.posterPath,
      this.mediaType,
      this.adult,
      this.title,
      this.originalLanguage,
      this.genreIds,
      this.popularity,
      this.releaseDate,
      this.video,
      this.voteAverage,
      this.voteCount});

  Items.fromJson(Map<String, dynamic> json) {
    backdropPath = json['backdrop_path'];
    id = json['id'];
    originalTitle = json['original_title'];
    overview = json['overview'];
    posterPath = json['poster_path'];
    mediaType = json['media_type'];
    adult = json['adult'];
    title = json['title'];
    originalLanguage = json['original_language'];
    genreIds = json['genre_ids'].cast<int>();
    popularity = json['popularity'];
    releaseDate = json['release_date'];
    video = json['video'];
    voteAverage = json['vote_average'];
    voteCount = json['vote_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['backdrop_path'] = backdropPath;
    data['id'] = id;
    data['original_title'] = originalTitle;
    data['overview'] = overview;
    data['poster_path'] = posterPath;
    data['media_type'] = mediaType;
    data['adult'] = adult;
    data['title'] = title;
    data['original_language'] = originalLanguage;
    data['genre_ids'] = genreIds;
    data['popularity'] = popularity;
    data['release_date'] = releaseDate;
    data['video'] = video;
    data['vote_average'] = voteAverage;
    data['vote_count'] = voteCount;
    return data;
  }
}
