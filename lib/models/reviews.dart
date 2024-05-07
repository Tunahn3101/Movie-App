class MovieReviews {
  int? id;
  int? page;
  List<Results>? results;
  int? totalPages;
  int? totalResults;

  MovieReviews(
      {this.id, this.page, this.results, this.totalPages, this.totalResults});

  MovieReviews.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    page = json['page'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(Results.fromJson(v));
      });
    }
    totalPages = json['total_pages'];
    totalResults = json['total_results'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['page'] = page;
    if (results != null) {
      data['results'] = results!.map((v) => v.toJson()).toList();
    }
    data['total_pages'] = totalPages;
    data['total_results'] = totalResults;
    return data;
  }
}

class Results {
  String? author;
  String? content;
  String? createdAt;
  String? updatedAt;
  String? url;

  Results(
      {this.author, this.content, this.createdAt, this.updatedAt, this.url});

  Results.fromJson(Map<String, dynamic> json) {
    author = json['author'];
    content = json['content'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['author'] = author;
    data['content'] = content;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['url'] = url;
    return data;
  }
}
