import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hippodrome_app2/Model/Movies.dart';
import 'package:hippodrome_app2/Robot.dart';
import 'package:icon_shadow/icon_shadow.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class MovieCard2 extends StatefulWidget {
  final Movies movie;

  const MovieCard2({Key key, this.movie}) : super(key: key);

  @override
  _MovieCard2State createState() => _MovieCard2State();
}

class _MovieCard2State extends State<MovieCard2> {
  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController1;
  bool play;

  @override
  void initState() {
    play = false;
    _videoPlayerController1 = VideoPlayerController.network(widget.movie.video);
    _chewieController1 = ChewieController(
        videoPlayerController: _videoPlayerController1,
        aspectRatio: 16 / 9,
        autoPlay: play,
        looping: true,
        allowFullScreen: true,
        fullScreenByDefault: true,
        materialProgressColors: ChewieProgressColors(
            playedColor: Colors.red,
            handleColor: Colors.blue,
            backgroundColor: Colors.grey,
            bufferedColor: Colors.lightGreen),
        placeholder: Container(
          color: Colors.grey,
        ),
        autoInitialize: true);

    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController1.dispose();
    _chewieController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(play);
    var central = Provider.of<Robot>(context);
    if (play == false) {
      _chewieController1.pause();
      return buildMovieCard(central);
    } else {
      play = false;
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          buildChewie(),
          SizedBox(
            height: 20,
          ),
          RaisedButton.icon(
            color: Colors.redAccent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: () {
              setState(() {
                play = false;
                _chewieController1.pause();
              });
            },
            icon: Icon(
              MdiIcons.close,
              color: Colors.white,
            ),
            label: Text(
              "Close Video",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      );
    }
  }

  Padding buildMovieCard(Robot central) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                Positioned(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 250,
                      child: CachedNetworkImage(
                        imageUrl: widget.movie.pics,
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: IconButton(
                      icon: IconShadowWidget(
                        Icon(
                          MdiIcons.playCircle,
                          size: 90,
                          color: Colors.white60,
                        ),
                        shadowColor: Colors.black,
                        showShadow: true,
                      ),
                      onPressed: () {
                        setState(() {
                          play = true;
                          print(play.toString() + "22222");
                        });
                      }),
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              widget.movie.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Colors.deepPurple,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical:8.0),
            child: Text(
              'Released Date | ' + central.getDate(widget.movie.releaseDate.toDate()),
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
            ),
          ),
          SizedBox(
            height: 30,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  widget.movie.rating.toString() + "/5.0 ",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                central.buildRatingBar(widget.movie.rating, 5)
              ],
            ),
          )
        ],
      ),
    );
  }

  Chewie buildChewie() {
    setState(() {
      _chewieController1
          .play()
          .then((value) => _chewieController1.enterFullScreen());
    });
    return Chewie(
      controller: _chewieController1,
    );
  }
}
