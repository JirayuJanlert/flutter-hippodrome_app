import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hippodrome_app2/CSS.dart';
import 'package:hippodrome_app2/Robot.dart';
import 'package:hippodrome_app2/Screen/SelectDate.dart';
import 'package:hippodrome_app2/Widget/MovieCard2.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;

class MovieCarousel extends StatefulWidget {
  final int initialpage;

  const MovieCarousel({Key key, this.initialpage}) : super(key: key);

  @override
  _MovieCarouselState createState() => _MovieCarouselState();
}

class _MovieCarouselState extends State<MovieCarousel> {
  int initialpage;


  PageController _pageController;

  @override
  void initState() {
    super.initState();
    initialpage = widget.initialpage;
    _pageController =
        PageController(initialPage: initialpage, viewportFraction: 0.8);
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var central = Provider.of<Robot>(context);
    return ListView(
      shrinkWrap: true,
      children: <Widget>[
        Container(
          child: AspectRatio(
            aspectRatio: 0.82,
            child: PageView.builder(
                onPageChanged: (value) {
                  setState(() {
                    initialpage = value;
                  });
                },
                controller: _pageController,
                physics: ClampingScrollPhysics(),
                allowImplicitScrolling: true,
                itemCount: central.categoriesMovies.length,
                itemBuilder: (context, index) =>
                    buildMovieSlider(central, index)),
          ),
        ), //Movies poster pages slider
        SizedBox(
          height: 10,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 55),
          width: 280,
          height: 45,
          decoration: BoxDecoration(
            boxShadow: [
              defaultBoxShadow
            ],
          ),
          child: RaisedButton(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            color: Colors.deepPurple,
            onPressed: () {
              central.setActiveMovie(central.categoriesMovies[initialpage]);
              central.booking.bookedMovies =
              central.categoriesMovies[initialpage].id;
              Navigator.push(context, MaterialPageRoute(
                  builder: (context) => SelectDate()
              ));
            },
            child: const Text(
              "Buy Ticket",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Genres:",
                      style: headline3,
                    ),
                    SizedBox(
                      width: 31,
                    ),
                    Text(central.buildlStringText(
                        central.categoriesMovies[initialpage].genres)),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Director:",
                      style: headline3,
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Text(central.buildlStringText(
                        central.categoriesMovies[initialpage].director)),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text("Cast:", style: headline3),
              ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: central.categoriesMovies[initialpage].casts
                        .length,
                    itemBuilder: (context, index) {
                      return Container(
                          width: 100,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.deepPurple[300],
                                radius: 35,
                                child: SizedBox(
                                  height: 65,
                                  width: 65,
                                  child: ClipOval(
                                    child: CachedNetworkImage(
                                      imageUrl: central
                                          .categoriesMovies[initialpage]
                                          .casts[index]['pics'],
                                      progressIndicatorBuilder: (context, url,
                                          downloadProgress) =>
                                          CircularProgressIndicator(
                                            value: downloadProgress.progress,
                                            valueColor: AlwaysStoppedAnimation<
                                                Color>(Colors.white),),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                central.categoriesMovies[initialpage]
                                    .casts[index]['name'],
                                style: TextStyle(fontSize: 11),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ));
                    }),
              ),
              SizedBox(
                height: 10,
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text("Description:", style: headline3),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(central.categoriesMovies[initialpage].desc,
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                  ])
            ],
          ),
        )
      ],
    );
  }


  Widget buildMovieSlider(Robot central, int index) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double value = 0;
        if (_pageController.position.haveDimensions) {
          value = index - _pageController.page;
          value = (value * 0.038).clamp(-1, 1);
        }
        return AnimatedOpacity(
          duration: Duration(microseconds: 350),
          opacity: initialpage == index ? 1 : 0.4,
          child: Transform.rotate(
            angle: math.pi * value,
            child: MovieCard2(
              movie: central.categoriesMovies[index],
            ),
          ),
        );
      },
    );
  }
}
