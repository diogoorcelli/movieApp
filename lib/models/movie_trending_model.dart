import 'dart:convert';

class TrendingModel {
  final List<int> genreIds;
  final String title;
  final String originalTitle;
  final String posterPath;
  final int id;
  final bool video;
  final double voteAverage;
  final String overview;
  final DateTime releaseDate;
  final int voteCount;
  final bool adult;
  final String backdropPath;
  final double popularity;

  const TrendingModel({
    this.genreIds,
    this.title,
    this.originalTitle,
    this.posterPath,
    this.id,
    this.video,
    this.voteAverage,
    this.overview,
    this.releaseDate,
    this.voteCount,
    this.adult,
    this.backdropPath,
    this.popularity,
  });

  factory TrendingModel.fromJson(String str) =>
      TrendingModel.fromMap(json.decode(str));

  factory TrendingModel.fromMap(Map<String, dynamic> json) => TrendingModel(
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        title: json["title"],
        originalTitle: json["original_title"],
        posterPath: json["poster_path"],
        id: json["id"],
        video: json["video"],
        voteAverage: json["vote_average"].toDouble(),
        overview: json["overview"],
        releaseDate: DateTime.parse(json["release_date"]),
        voteCount: json["vote_count"],
        adult: json["adult"],
        backdropPath: json["backdrop_path"],
        popularity: json["popularity"].toDouble(),
      );
}
