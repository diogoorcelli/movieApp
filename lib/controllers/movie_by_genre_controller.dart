import 'package:dartz/dartz.dart';
import 'package:movie_app/models/movie_by_genre_model.dart';
import 'package:movie_app/models/movie_by_genre_response_model.dart';

import '../errors/movie_error.dart';
import '../repositories/movie_repository.dart';

class MovieByGenreController {
  final _repository = MovieRepository();

  MovieByGenreResponseModel movieByGenreResponseModel;
  MovieError movieError;

  List<MovieByGenreModel> get movies =>
      movieByGenreResponseModel?.movies ?? <MovieByGenreModel>[];
  int get moviesCount => movies.length;
  bool get hasMovies => moviesCount != 0;
  int get totalPages => movieByGenreResponseModel?.totalPages ?? 1;
  int get currentPage => movieByGenreResponseModel?.page ?? 1;

  Future<Either<MovieError, MovieByGenreResponseModel>> fetchMoviesByGenre(
      {int page = 1, int genre}) async {
    movieError = null;
    final result = await _repository.fetchMoviesByGenre(page, genre);
    result.fold(
      (error) => movieError = error,
      (movie) {
        if (movieByGenreResponseModel == null) {
          movieByGenreResponseModel = movie;
        } else {
          movieByGenreResponseModel.page = movie.page;
          movieByGenreResponseModel.movies.addAll(movie.movies);
        }
      },
    );

    return result;
  }
}
