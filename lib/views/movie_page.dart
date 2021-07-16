import 'package:flutter/material.dart';
import 'package:movie_app/controllers/movie_by_genre_controller.dart';
import 'package:movie_app/controllers/movie_genre_controller.dart';
import 'package:movie_app/controllers/movie_pop_controller.dart';
import 'package:movie_app/controllers/movie_trending_controller.dart';
import 'package:movie_app/core/constants.dart';
import 'package:movie_app/utils/text.dart';
import 'package:movie_app/widgets/movie_card_by_genre.dart';
import 'package:movie_app/widgets/movie_message.dart';
import 'package:movie_app/widgets/movie_load_progress.dart';
import 'package:movie_app/widgets/movie_card_pop.dart';
import 'package:movie_app/widgets/movie_card_trending.dart';
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
  final _scrollControlerGenres = ScrollController();
  final _scrollControllerTrending = ScrollController();

  int lastPage = 1;
  int lastPageTrending = 1;
  int lastPageGenre = 1;
  int genreMovie = 16;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initScrollListenner();
    _initialize();
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

  _initialize() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.movie),
                onPressed: () {},
              ),
            ],
          ),
        ),
        body: ListView(
          children: [
            _buildListMovies(context),
          ],
        ));
  }

  _buildAppBar() {
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

  Widget _buildListMovies(context) {
    if (isLoading) {
      return CenteredProgress();
    }

    if (_controller.movieError != null) {
      return CenteredMessage(message: _controller.movieError.message);
    }

    if (_controllerTrending.movieError != null) {
      return CenteredMessage(message: _controller.movieError.message);
    }

    if (_controllerGenres.movieError != null) {
      return CenteredMessage(message: _controllerGenres.movieError.message);
    }

    if (_controllerListGenres.movieError != null) {
      return CenteredMessage(message: _controllerListGenres.movieError.message);
    }

    return Container(
      child: Column(
        children: [
          _buildListPop(),
          _buildListTrending(),
          _buildCaptionGenre(),
          _buildListByGenre(),
        ],
      ),
    );
  }

  Widget _buildListPop() {
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

  Widget _buildListByGenre() {
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
              itemBuilder: (context, index) {
                return _buildMovieCardByGenre(context, index);
              }),
        ),
      ]),
    );
  }

  Widget _buildCaptionGenre() {
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
              padding: EdgeInsets.only(left: 5.0),
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
                        setState(() {
                          _controllerListGenres.movies.clear();
                          genreMovie = _controllerGenres.genres[index].id;
                        });
                      });
                },
                separatorBuilder: (context, index) => SizedBox(width: 5),
              )),
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
