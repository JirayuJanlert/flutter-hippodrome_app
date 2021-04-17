import 'package:flutter/material.dart';
import 'package:hippodrome_app2/CSS.dart';
import 'package:hippodrome_app2/Screen/SelectTheather.dart';
import 'package:hippodrome_app2/Widget/BuyTicketHeaderWidget.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../Robot.dart';

class SelectDate extends StatefulWidget {
  const SelectDate({
    Key key,
  }) : super(key: key);

  _SelectDateState createState() => _SelectDateState();
}

class _SelectDateState extends State<SelectDate> {
  bool click = false;
  List<String> bookinInfo = [];
  int selectedIndex ;
  int selectedDate = 0;
  int selectedIndex2;

  initState() {
    Robot central = Provider.of<Robot>(context, listen: false);
    central.getItemGridSeat();
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

    print(bookinInfo.length);
    if (bookinInfo.length > 2) {
      bookinInfo.removeLast();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: central.buildBuyTicketsAppBar("Buy Ticket"),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        scrollDirection: Axis.vertical,
        children: <Widget>[
          Container(
            child: BuyTicketHeaderWidget(
                central: central, bookinInfo: bookinInfo),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Select Date",
            style: headline3,
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            alignment: Alignment.center,
            child: GridView.builder(
                shrinkWrap: true,
                itemCount: central.activeMovies.showDateTime.length,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 20,
                    childAspectRatio: 0.85),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      String bookedDate = central.activeMovies.showDateTime[index].month+ " " +
                          central.activeMovies.showDateTime[index].day + " | " +
                          central.activeMovies.showDateTime[index].weekday;
                      click = true;
                      setState(() {
                        selectedIndex = index;
                        selectedDate = index;

                        if (bookinInfo.length > 0) {
                          bookinInfo.removeAt(0);
                        }
                        if (bookinInfo.length > 2 ) {
                          bookinInfo.removeLast();
                        }
                        if (selectedIndex2 != null) {
                          selectedIndex2 =null;
                          bookinInfo.removeLast();
                        }
                        bookinInfo.insert(0, bookedDate);
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black38),
                          color: index == selectedIndex
                              ? Colors.deepPurple
                              : Colors.white),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(central.activeMovies.showDateTime[index].month,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: index == selectedIndex
                                      ? Colors.white
                                      : Colors.black)),
                          Text(
                            central.activeMovies.showDateTime[index].day,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: index == selectedIndex
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          Text(
                            central.activeMovies.showDateTime[index].weekday,
                            style: TextStyle(
                                fontSize: 10,
                                color: index == selectedIndex
                                    ? Colors.white
                                    : Colors.black),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Select Time",
            style: headline3,
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: central.activeMovies.showDateTime[selectedDate].showTime.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 15,
                    childAspectRatio: 1.5),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        click = true;


                        if (bookinInfo.length > 1) {

                          bookinInfo.removeAt(1);

                        } else if (bookinInfo.isEmpty) {
                          AlertDialog alert = AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)
                            ),
                            backgroundColor: Colors.transparent,
                            content: Text("Please select date",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                          );

                          // show the dialog
                          showDialog(
                              context: context,
                              builder: (context) {
                                Future.delayed(Duration(seconds: 1), () {
                                  Navigator.of(context).pop(true);
                                });
                                return alert;
                              });
                        }else if(selectedIndex != null){
                          selectedIndex2 = index;
                          bookinInfo.insert(
                              1,   central.activeMovies.showDateTime[selectedDate].showTime[index]);
                        }


                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: index == selectedIndex2
                            ? Colors.deepPurple
                            : Colors.white,
                        border: Border.all(color: Colors.black38),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        central.activeMovies.showDateTime[selectedDate].showTime[index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: index == selectedIndex2
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Container(
            decoration: BoxDecoration(),
            margin: EdgeInsets.symmetric(horizontal: 115, vertical: 5),
            child: NextButton(bookinInfo: bookinInfo, selectedDate: selectedDate,),
            padding: const EdgeInsets.symmetric(vertical: 30),
          )
        ],
      ),
    );
  }
}




class NextButton extends StatelessWidget {
  const NextButton({
    Key key,
    @required this.bookinInfo,
    this.selectedDate
  }) : super(key: key);

  final List<String> bookinInfo;
  final int selectedDate;

  @override
  Widget build(BuildContext context) {
    Robot central = Provider.of<Robot>(context, listen: false);
    return OutlineButton(
        onPressed: () {
          if (bookinInfo.length > 1 ) {
            central.booking.bookedDate = bookinInfo[0];
            central.booking.bookedTime = bookinInfo[1];


            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SelectTheater(
                          bookingInfo: bookinInfo,
                        )));
          } else {
            Scaffold.of(context).showSnackBar(SnackBar(
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
                      'Please select date and time for your booking!',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ],
                )));
          }
        },
        borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        splashColor: Colors.deepPurple,
        highlightedBorderColor: Colors.black12,
        textColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
