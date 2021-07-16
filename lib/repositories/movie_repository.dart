import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:movie_app/core/constants.dart';
import 'package:movie_app/models/genres_response_model.dart';
import 'package:movie_app/models/movie_by_genre_response_model.dart';
import 'package:movie_app/models/movie_detail_model.dart';
import 'package:movie_app/models/movie_trending_response_model.dart';

import '../errors/movie_error.dart';
import '../models/movie_response_model.dart';

class MovieRepository {
  final Dio _dio = Dio(dioOptions);

  Future<Either<MovieError, GenreRespondeModel>> fetchListGenres() async {
    try {
      final response = await _dio.get('/genre/movie/list');
      final model = GenreRespondeModel.fromMap(response.data);
      return Right(model);
    } on DioError catch (error) {
      if (error.response != null) {
        return Left(
            MovieRepositoryError(error.response.data['status_message']));
      } else {
        return Left(MovieRepositoryError(serverError));
      }
    } on Exception catch (error) {
      return Left(MovieRepositoryError(error.toString()));
    }
  }

  Future<Either<MovieError, MovieTrendingResponseModel>> fetchMoviesTrending(
      int page) async {
    try {
      final response = await _dio.get('/trending/movie/week?page=$page');
      final model = MovieTrendingResponseModel.fromMap(response.data);
      return Right(model);
    } on DioError catch (error) {
      if (error.response != null) {
        return Left(
            MovieRepositoryError(error.response.data['status_message']));
      } else {
        return Left(MovieRepositoryError(serverError));
      }
    } on Exception catch (error) {
      return Left(MovieRepositoryError(error.toString()));
    }
  }

  Future<Either<MovieError, MovieResponseModel>> fetchAllMovies(
      int page) async {
    try {
      final response = await _dio.get('/movie/popular?page=$page');
      final model = MovieResponseModel.fromMap(response.data);
      return Right(model);
    } on DioError catch (error) {
      if (error.response != null) {
        return Left(
            MovieRepositoryError(error.response.data['status_message']));
      } else {
        return Left(MovieRepositoryError(serverError));
      }
    } on Exception catch (error) {
      return Left(MovieRepositoryError(error.toString()));
    }
  }

  Future<Either<MovieError, MovieDetailModel>> fetchMovieById(int id) async {
    try {
      final response = await _dio.get('/movie/$id');
      final model = MovieDetailModel.fromMap(response.data);
      return Right(model);
    } on DioError catch (error) {
      if (error.response != null) {
        return Left(
            MovieRepositoryError(error.response.data['status_message']));
      } else {
        return Left(MovieRepositoryError(serverError));
      }
    } on Exception catch (error) {
      return Left(MovieRepositoryError(error.toString()));
    }
  }

  Future<Either<MovieError, MovieByGenreResponseModel>> fetchMoviesByGenre(
      int page, int genre) async {
    try {
      final response =
          await _dio.get('/discover/movie?page=$page&with_genres=$genre');
      final model = MovieByGenreResponseModel.fromMap(response.data);
      return Right(model);
    } on DioError catch (error) {
      if (error.response != null) {
        return Left(
            MovieRepositoryError(error.response.data['status_message']));
      } else {
        return Left(MovieRepositoryError(serverError));
      }
    } on Exception catch (error) {
      return Left(MovieRepositoryError(error.toString()));
    }
  }
}
