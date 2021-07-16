import 'dart:convert';

import 'package:movie_app/models/movie_genre_model.dart';

class GenreRespondeModel {
  final List<MovieGenre> genres;

  GenreRespondeModel({this.genres});

  factory GenreRespondeModel.fromJson(String str) =>
      GenreRespondeModel.fromMap(json.decode(str));

  factory GenreRespondeModel.fromMap(Map<String, dynamic> json) =>
      GenreRespondeModel(
        genres: List<MovieGenre>.from(
            json["genres"].map((x) => MovieGenre.fromMap(x))),
      );
}
