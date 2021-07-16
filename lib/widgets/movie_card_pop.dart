import 'package:flutter/material.dart';

class MovieCardPop extends StatelessWidget {
  final String posterPath;
  final Function onTap;

  const MovieCardPop({
    Key key,
    this.posterPath,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Image.network(
            'https://image.tmdb.org/t/p/w220_and_h330_face$posterPath',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
