import 'package:dio/dio.dart';

const appName = 'Movies App';
const detailName = 'Detalhes do filme';
const trendingMovies = 'Filmes populares da semana';
const topRatedMovies = 'Filmes com melhor classificação';
const popularMovies = 'Filmes mais populares';
const genreMoviesSearch = 'O que você procura?';
const genreSubDetail = 'Busque filmes por gênero';

const cDateFormat = 'dd/MM/yyyy';

const baseUrl = 'https://api.themoviedb.org/3';
const apiToken_v4 =
    'eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI0NzdlNTJiNDRhNTJmZDBjYmNmMjk1YWFjN2Y3NDVlNiIsInN1YiI6IjYwZGRmNDkxOTk3OWQyMDAyOTQ1MjEyZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.ShsB3KlxvFunu8Bqj1JPMjvrCFKrVJi7949GS8rYc5U';
const apiKey_v3 = '477e52b44a52fd0cbcf295aac7f745e6';

const serverError = 'Failed to connect to the server.';

final dioOptions = BaseOptions(
  baseUrl: baseUrl,
  connectTimeout: 5000,
  receiveTimeout: 3000,
  contentType: 'application/json;charset=utf-8',
  headers: {'Authorization': 'Bearer $apiToken_v4'},
);
