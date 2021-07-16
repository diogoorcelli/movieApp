import 'package:dartz/dartz.dart';
import 'package:movie_app/errors/movie_error.dart';
import 'package:movie_app/models/genres_response_model.dart';
import 'package:movie_app/models/movie_genre_model.dart';
import 'package:movie_app/repositories/movie_repository.dart';

class GenreController {
  final _repository = MovieRepository();

  GenreRespondeModel genreResponseModel;
  MovieError movieError;

  List<MovieGenre> get genres => genreResponseModel?.genres ?? <MovieGenre>[];
  int get genresCount => genres.length;

  Future<Either<MovieError, GenreRespondeModel>> fetchListGenres() async {
    movieError = null;
    final result = await _repository.fetchListGenres();
    result.fold(
      (error) => movieError = error,
      (genre) {
        if (genreResponseModel == null) {
          genreResponseModel = genre;
        } else {}
      },
    );

    return result;
  }
}
