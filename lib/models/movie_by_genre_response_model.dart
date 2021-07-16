import 'dart:convert';
import 'movie_by_genre_model.dart';

class MovieByGenreResponseModel {
  int page;
  final int totalResults;
  final int totalPages;
  final List<MovieByGenreModel> movies;

  MovieByGenreResponseModel({
    this.page,
    this.totalResults,
    this.totalPages,
    this.movies,
  });

  factory MovieByGenreResponseModel.fromJson(String str) =>
      MovieByGenreResponseModel.fromMap(json.decode(str));

  factory MovieByGenreResponseModel.fromMap(Map<String, dynamic> json) =>
      MovieByGenreResponseModel(
        page: json["page"],
        totalResults: json["total_results"],
        totalPages: json["total_pages"],
        movies: List<MovieByGenreModel>.from(
            json["results"].map((x) => MovieByGenreModel.fromMap(x))),
      );
}
