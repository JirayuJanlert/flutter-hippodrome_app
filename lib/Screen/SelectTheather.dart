import 'package:flutter/material.dart';
import 'package:hippodrome_app2/CSS.dart';
import 'package:hippodrome_app2/Screen/SelectType.dart';
import 'package:hippodrome_app2/Widget/BuyTicketHeaderWidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../Robot.dart';

class SelectTheater extends StatefulWidget {
  final List<String> bookingInfo;
  const SelectTheater({
    Key key,
    this.bookingInfo
  }) : super(key: key);

  _SelectTheaterState createState() => _SelectTheaterState();
}

class _SelectTheaterState extends State<SelectTheater> {
  bool click = false;
  List<String> bookinInfo;
  int selectedIndex;

  initState() {
    bookinInfo = widget.bookingInfo;

    super.initState();
  }

  void dispose() {
    click = false;
    print(click);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var central = Provider.of<Robot>(context);

    if (click == false) {
      if(bookinInfo.length > 2){
        bookinInfo.removeLast();
      }
    }
    print(bookinInfo.length);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar:central.buildBuyTicketsAppBar("Buy Ticket"),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        scrollDirection: Axis.vertical,
        children: <Widget>[
          BuyTicketHeaderWidget(central: central, bookinInfo: bookinInfo),
          SizedBox(
            height: 30,
          ),
          Text(
            "Select Theater",
            style: headline3,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            alignment: Alignment.center,
            child: GridView.builder(
                shrinkWrap: true,
                itemCount: central.activeMovies.theatres.length,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 20,
                    childAspectRatio: 2),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {

                        click = true;
                      selectedIndex = index;
          print(bookinInfo.length);

                        print(central.activeMovies.theatres[index]['name'] + " | "+ central.activeMovies.theatres[index]['place']);

                        if (bookinInfo.length > 3) {
                          bookinInfo.removeAt(3);
                        }
                        if (bookinInfo.length > 2) {
                          bookinInfo.removeAt(2);

                        }


                        bookinInfo.insert(
                            2,
                            central.activeMovies.theatres[index]['name'] + "\n"+ central.activeMovies.theatres[index]['place']);
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black38),
                          color: index == selectedIndex
                              ? Colors.deepPurple
                              : Colors.white),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(central.activeMovies.theatres[index]['name'],
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: index == selectedIndex
                                      ? Colors.white
                                      : Colors.black)),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            central.activeMovies.theatres[index]['place'],
                            style: TextStyle(
                                fontSize: 15,
                                color: index == selectedIndex
                                    ? Colors.white
                                    : Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          Container(
            decoration: BoxDecoration(),
            margin: EdgeInsets.symmetric(horizontal: 115, vertical: 30),
            child: NextToSeatTypeSelection(bookinInfo: bookinInfo),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }
}



class NextToSeatTypeSelection extends StatelessWidget {
  const NextToSeatTypeSelection({
    Key key,
    @required this.bookinInfo,
  }) : super(key: key);

  final List<String> bookinInfo;

  @override
  Widget build(BuildContext context) {
    Robot central = Provider.of<Robot>(context, listen: false);
    return OutlineButton(
        onPressed: () {
          if(bookinInfo.length < 3 ){
            Scaffold.of(context).showSnackBar(
                SnackBar(
                    backgroundColor: Colors.deepPurple,
                    duration: Duration(seconds: 2),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.alertCircle,
                          color: Colors.redAccent,
                          size: 25,
                        ),
                        Text(
                          'Please select a theatre for your booking!',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    )));
          } else{
            central.booking.bookedTheatre = bookinInfo[2];
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => SelectType(bookingInfo: bookinInfo,)
            ));
          }
        },
        borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        splashColor: Colors.deepPurple,
        highlightedBorderColor: Colors.black12,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Next",
              style: headline1,
            ),
            SizedBox(
              width: 5,
            ),
            Icon(
              MdiIcons.arrowRight,
              color: Colors.deepPurple,
              size: 25,
            ),
          ],
        ));
  }
} //ec
