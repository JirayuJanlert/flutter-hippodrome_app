import 'package:flutter/material.dart';
import 'package:hippodrome_app2/Widget/MovieCarousel.dart';


class MovieInfo extends StatefulWidget {
  final int initialpage;

  const MovieInfo({Key key, this.initialpage}) : super(key: key);

  @override
  _MovieInfoState createState() => _MovieInfoState();
}

class _MovieInfoState extends State<MovieInfo> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          elevation: 0,

          brightness: Brightness.light,
          backgroundColor: Colors.white,
          title: Text(
            "Hippodrome",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          ),
        ),
        body: MovieCarousel(
            initialpage: widget.initialpage,
          ));

  }
}



