import 'dart:convert';

import 'package:movie_app/models/movie_trending_model.dart';

class MovieTrendingResponseModel {
  int page;
  final int totalResults;
  final int totalPages;
  final List<TrendingModel> movies;

  MovieTrendingResponseModel({
    this.page,
    this.totalResults,
    this.totalPages,
    this.movies,
  });

  factory MovieTrendingResponseModel.fromJson(String str) =>
      MovieTrendingResponseModel.fromMap(json.decode(str));

  factory MovieTrendingResponseModel.fromMap(Map<String, dynamic> json) =>
      MovieTrendingResponseModel(
        page: json["page"],
        totalResults: json["total_results"],
        totalPages: json["total_pages"],
        movies: List<TrendingModel>.from(
            json["results"].map((x) => TrendingModel.fromMap(x))),
      );
}
