import 'package:dartz/dartz.dart';
import 'package:movie_app/models/movie_trending_model.dart';
import 'package:movie_app/models/movie_trending_response_model.dart';

import '../errors/movie_error.dart';
import '../repositories/movie_repository.dart';

class TrendingController {
  final _repository = MovieRepository();

  MovieTrendingResponseModel movieTrendingResponseModel;
  MovieError movieError;

  List<TrendingModel> get movies =>
      movieTrendingResponseModel?.movies ?? <TrendingModel>[];
  int get moviesCount => movies.length;
  bool get hasMovies => moviesCount != 0;
  int get totalPages => movieTrendingResponseModel?.totalPages ?? 1;
  int get currentPage => movieTrendingResponseModel?.page ?? 1;

  Future<Either<MovieError, MovieTrendingResponseModel>> fetchMoviesTrending(
      {int page = 1}) async {
    movieError = null;
    final result = await _repository.fetchMoviesTrending(page);
    result.fold(
      (error) => movieError = error,
      (movie) {
        if (movieTrendingResponseModel == null) {
          movieTrendingResponseModel = movie;
        } else {
          movieTrendingResponseModel.page = movie.page;
          movieTrendingResponseModel.movies.addAll(movie.movies);
        }
      },
    );

    return result;
  }
}
