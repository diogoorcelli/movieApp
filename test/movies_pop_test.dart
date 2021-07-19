import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_app/errors/movie_error.dart';
import 'package:movie_app/models/movie_response_model.dart';
import 'package:movie_app/repositories/movie_repository.dart';

void main() {
  final _repository = MovieRepository();

  test('Deve retornar todos os filmes populares', () async {
    final result = await _repository.fetchAllMovies(1);
    expect(result.isRight(), true);
    expect(result.fold(id, id), isA<MovieResponseModel>());
  });

  test('Deve ocorrer um erro ao obter os filmes populares', () async {
    final result = await _repository.fetchAllMovies(1000);
    expect(result.isLeft(), true);
    expect(result.fold(id, id), isA<MovieError>());
  });
}
