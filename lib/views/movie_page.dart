import 'package:flutter/material.dart';
import 'package:movie_app/controllers/movie_by_genre_controller.dart';
import 'package:movie_app/controllers/movie_genre_controller.dart';
import 'package:movie_app/controllers/movie_pop_controller.dart';
import 'package:movie_app/controllers/movie_trending_controller.dart';
import 'package:movie_app/core/constants.dart';
import 'package:movie_app/utils/text.dart';
import 'package:movie_app/widgets/movie_card_by_genre.dart';
import 'package:movie_app/widgets/movie_card_pop.dart';
import 'package:movie_app/widgets/movie_card_trending.dart';
import 'package:movie_app/widgets/movie_load_progress.dart';
import 'package:movie_app/widgets/movie_message.dart';
import 'movie_detail_page.dart';

class MoviePage extends StatefulWidget {
  @override
  _MoviePageState createState() => _MoviePageState();
}

class _MoviePageState extends State<MoviePage> {
  final _controller = MovieController();
  final _controllerTrending = TrendingController();
  final _controllerGenres = GenreController();
  final _controllerListGenres = MovieByGenreController();
  final _scrollController = ScrollController();
  final _scrollControllerTrending = ScrollController();
  final _scrollControlerGenres = ScrollController();

  int lastPage = 1;
  int lastPageTrending = 1;
  int lastPageGenre = 1;
  int genreMovie = 28;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _initScrollListenner();
    _initializeMovies();
  }

  _initScrollListenner() {
    _scrollController.addListener(() async {
      if (_scrollController.offset >=
          _scrollController.position.maxScrollExtent) {
        if (_controller.currentPage == lastPage) {
          lastPage++;
          await _controller.fetchAllMovies(page: lastPage);
          setState(() {});
        }
      }
    });

    _scrollControllerTrending.addListener(() async {
      if (_scrollControllerTrending.offset >=
          _scrollControllerTrending.position.maxScrollExtent) {
        if (_controllerTrending.currentPage == lastPageTrending) {
          lastPageTrending++;
          await _controllerTrending.fetchMoviesTrending(page: lastPageTrending);
          setState(() {});
        }
      }
    });

    _scrollControlerGenres.addListener(() async {
      if (_scrollControlerGenres.offset >=
          _scrollControlerGenres.position.maxScrollExtent) {
        if (_controllerListGenres.currentPage == lastPageGenre) {
          lastPageGenre++;
          await _controllerListGenres.fetchMoviesByGenre(
              page: lastPageGenre, genre: genreMovie);
          setState(() {});
        }
      }
    });
  }

  _initializeMovies() async {
    setState(() {
      isLoading = true;
    });

    await _controller.fetchAllMovies(page: lastPage);
    await _controllerTrending.fetchMoviesTrending(page: lastPageTrending);
    await _controllerGenres.fetchListGenres();
    await _controllerListGenres.fetchMoviesByGenre(
        page: lastPageGenre, genre: genreMovie);

    setState(() {
      isLoading = false;
    });
  }

  _initializeListByGenre() async {
    await _controllerListGenres.fetchMoviesByGenre(
        page: lastPageGenre, genre: genreMovie);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildAppBottomBar(),
      body: ListView(
        children: [
          _buildListPop(),
          _buildListTrending(),
          _buildCaptionGenre(),
          _buildListByGenre(context),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: ModifiedText(text: appName),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildAppBottomBar() {
    return BottomAppBar(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.movie),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildListPop() {
    if (isLoading) {
      return CenteredProgress();
    }

    if (_controller.movieError != null) {
      CenteredMessage(message: _controller.movieError.message);
    }

    return Container(
      padding: EdgeInsets.all(5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ModifiedText(
          text: popularMovies,
          size: 18,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0, 0, 10, 20),
          height: 200,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              itemCount: _controller.moviesCount,
              itemBuilder: (context, index) {
                return _buildMovieCard(context, index);
              }),
        ),
      ]),
    );
  }

  Widget _buildListTrending() {
    if (isLoading) {
      return CenteredProgress();
    }

    if (_controllerTrending.movieError != null) {
      CenteredMessage(message: _controllerTrending.movieError.message);
    }

    return Container(
      padding: EdgeInsets.all(5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ModifiedText(
          text: trendingMovies,
          size: 18,
        ),
        Container(
          padding: EdgeInsets.fromLTRB(0, 0, 10, 20),
          height: 200,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: _scrollControllerTrending,
              itemCount: _controllerTrending.moviesCount,
              itemBuilder: (context, index) {
                return _buildMovieCardTrending(context, index);
              }),
        ),
      ]),
    );
  }

  Widget _buildCaptionGenre() {
    if (_controllerGenres.movieError != null) {
      CenteredMessage(message: _controllerGenres.movieError.message);
    }

    return Container(
      padding: EdgeInsets.all(5),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ModifiedText(
          text: genreMoviesSearch,
          size: 18,
        ),
        ModifiedText(
          text: genreSubDetail,
          size: 12,
        ),
        Container(
            //padding: EdgeInsets.only(left: 5.0),
            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
            height: 40,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _controllerGenres.genresCount,
              itemBuilder: (context, index) {
                return ActionChip(
                    label: ModifiedText(
                      text: _controllerGenres.genres[index].name,
                      size: 12,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      genreMovie = _controllerGenres.genres[index].id;
                      _controllerListGenres.movies.clear();
                      _initializeListByGenre();
                    });
              },
              separatorBuilder: (context, index) => SizedBox(width: 5),
            )),
      ]),
    );
  }

  Widget _buildListByGenre(context) {
    if (isLoading) {
      return CenteredProgress();
    }

    if (_controllerTrending.movieError != null) {
      CenteredMessage(message: _controllerTrending.movieError.message);
    }

    return Container(
        padding: EdgeInsets.all(5),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: EdgeInsets.fromLTRB(0, 0, 10, 20),
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              controller: _scrollControlerGenres,
              itemCount: _controllerListGenres.moviesCount,
              itemBuilder: (context, index) =>
                  _buildMovieCardByGenre(context, index),
            ),
          ),
        ]));
  }

  Widget _buildMovieCard(context, index) {
    final movie = _controller.movies[index];
    return MovieCardPop(
      posterPath: movie.posterPath,
      onTap: () => _openDetailPage(movie.id),
    );
  }

  Widget _buildMovieCardTrending(context, index) {
    final movieTrending = _controllerTrending.movies[index];
    return MovieCardTrending(
      posterPath: movieTrending.posterPath,
      onTap: () => _openDetailPage(movieTrending.id),
    );
  }

  Widget _buildMovieCardByGenre(context, index) {
    final movieByGenre = _controllerListGenres.movies[index];
    return MovieCardByGenre(
      posterPath: movieByGenre.posterPath,
      onTap: () => _openDetailPage(movieByGenre.id),
    );
  }

  _openDetailPage(movieId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MovieDetailPage(movieId),
      ),
    );
  }
}
