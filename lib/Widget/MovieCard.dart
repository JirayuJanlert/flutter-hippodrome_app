import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hippodrome_app2/CSS.dart';
import 'package:hippodrome_app2/Model/Movies.dart';
import 'package:hippodrome_app2/Robot.dart';
import 'package:hippodrome_app2/Screen/MovieInfo.dart';
import 'package:hippodrome_app2/Screen/SelectDate.dart';
import 'package:provider/provider.dart';

class MovieCard extends StatefulWidget {
  final String title;
  final String pics;
  final double rating;
  final Movies m;
  final int initialpage;
  final String releasedDate;

  const MovieCard(
      {Key key, this.title, this.pics, this.rating, this.m, this.initialpage,this.releasedDate})
      : super(key: key);

  @override
  _MovieCardState createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  @override
  Widget build(BuildContext context) {
    var central = Provider.of<Robot>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        OpenContainer(
          transitionDuration: Duration(milliseconds: 800),
          closedElevation: 0,
          closedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          openElevation: 0,
          transitionType: ContainerTransitionType.fadeThrough,
          closedBuilder: (context, action) => buildMovieCard(),
          openBuilder: (context, action) => MovieInfo(
            initialpage: widget.initialpage,
          ),
        ),
        new SizedBox(height: 10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 12),
              child: new Text(
                widget.releasedDate,
                style: headline4,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.02,
              width: MediaQuery.of(context).size.height * 0.1,
              padding: EdgeInsets.only(left: 15),
              child: Row(
                children: <Widget>[
                  Text(
                    widget.rating.toString(),
                    style: TextStyle(color: Colors.black54, fontSize: 10,fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: central.buildRatingBar(widget.rating/5,1),
                  )
                ],
              ),
            ),
          ],
        ),
        new SizedBox(height: 10.0),
        Padding(
          padding: const EdgeInsets.only(left:15.0),
          child: new Text(
            widget.title,
            style: TextStyle(fontSize: 12.5,color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          padding: EdgeInsets.only(left: 5),
          width: 160,
          child: RaisedButton(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.deepPurple,
            onPressed: () {
              central.setActiveMovie(widget.m);
              central.booking.bookedMovies = widget.m.id;
              print(central.activeMovies.title);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SelectDate()));
            },
            child: Text(
              "Buy Ticket",
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }



  Container buildMovieCard() {
    return Container(
      height: 200,
      width: 160,

      child: CachedNetworkImage(
        imageUrl: widget.pics,
        fit: BoxFit.fill,
      ),
    );
  }
} //ec
