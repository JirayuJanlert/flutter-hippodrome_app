import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hippodrome_app2/CSS.dart';
import 'package:hippodrome_app2/Robot.dart';

class BuyTicketHeaderWidget extends StatelessWidget {
  const BuyTicketHeaderWidget({
    Key key,
    @required this.central,
    @required this.bookinInfo,
  }) : super(key: key);

  final Robot central;
  final List<String> bookinInfo;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),

          child: Container(
            height: 190,
            width: 133,
            child: CachedNetworkImage(
              imageUrl: central.activeMovies.pics,
              fit: BoxFit.fill,
            ),
          ),
        ),
        SizedBox(
          width: 7,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                central.activeMovies.title,
                style: headline2,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                central.buildlStringText(central.activeMovies.genres),
                style: text2,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 140,
                width: 210,
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: bookinInfo.length,
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2.78,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 5),
                  itemBuilder: (context, index) {
                    return Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 2, horizontal: 2),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(color: Colors.black38),
                          color: Colors.white),
                      child: Text(
                        bookinInfo[index],
                        overflow: TextOverflow.ellipsis,
                        style:
                        TextStyle(fontSize: index == 1 ?  12:9),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}