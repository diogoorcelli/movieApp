import 'package:flutter/material.dart';
import 'package:movie_app/core/constants.dart';
import 'package:movie_app/core/theme_app.dart';
import 'package:movie_app/views/movie_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appName,
      theme: themeApp,
      home: MoviePage(),
    );
  }
}
