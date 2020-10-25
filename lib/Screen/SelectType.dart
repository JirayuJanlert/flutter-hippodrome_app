import 'package:flutter/material.dart';
import 'package:hippodrome_app2/CSS.dart';
import 'package:hippodrome_app2/Screen/SelectSeatNumber.dart';
import 'package:hippodrome_app2/Widget/BuyTicketHeaderWidget.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

import '../Robot.dart';

class SelectType extends StatefulWidget {
  final List<String> bookingInfo;

  const SelectType({
    Key key,
    this.bookingInfo
  }) : super(key: key);

  _SelectTypeState createState() => _SelectTypeState();
}

class _SelectTypeState extends State<SelectType> {
  bool click = false;
  List<String> bookinInfo;
  int selectedIndex;
  int _seatQty = 1;

  initState() {
    bookinInfo = widget.bookingInfo;
    bookinInfo.insert(
        3,
        _seatQty.toString() + " tickets");

    super.initState();
  }

  void dispose() {
    bookinInfo.removeLast();
    click = false;
    print(click);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var central = Provider.of<Robot>(context);
    central.handleClearisSelectionSeatState();
    print(selectedIndex);
    bookinInfo[3] = _seatQty.toString() + " tickets";

      if (click == false) {
        if (bookinInfo.length > 5) {
          bookinInfo.removeLast();
        }
      }


    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
            "How Many Tickets",
            style: headline3,
          ),
          SizedBox(
            height: 30,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 42),
            alignment: Alignment.center,
            child: Row(
              children: [
                IconButton(
                  icon: Icon(MdiIcons.minusCircleOutline),
                  iconSize: 80,
                  onPressed: () {
                    setState(() {
                      if (_seatQty > 1) {
                        _seatQty -= 1;
                      }
                    });
                  },
                ),
                Container(
                  width: 75,
                  height: 75,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(15)
                  ),
                  child: Text(_seatQty.toString(), style: TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 50,
                      color: Colors.white
                  ),),
                ), IconButton(
                  icon: Icon(MdiIcons.plusCircleOutline),
                  iconSize: 80,
                  onPressed: () {
                    setState(() {
                      _seatQty += 1;
                    });
                  },
                ),
              ],
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Text(
            "Select Type",
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
                itemCount: central.types.length,
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
                        selectedIndex = index;
                        print(index);
                        print(selectedIndex);
                        click = true;


                        if (bookinInfo.length > 4) {
                          print(bookinInfo.last+ " cl");
                          bookinInfo.removeLast();
                        }

                        bookinInfo.insert(
                            4,
                            central.types[index].typeName);
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
                          Text(central.types[index].typeName,
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
                            central.types[index].price.toString() + " Baht",
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
            margin: EdgeInsets.symmetric(horizontal: 115, vertical: 10),
            child: NextToSeatTypeSelection(bookinInfo: bookinInfo,selectedIndex: selectedIndex,),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          SizedBox(
            height: 50,
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
    @required this.selectedIndex
  }) : super(key: key);

  final List<String> bookinInfo;
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    Robot central = Provider.of<Robot>(context, listen: false);
    return OutlineButton(
        onPressed: () {
          if (bookinInfo.length < 5) {
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
                          'Please select a seat type for your booking!',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    )));
          } else {
            int idx = bookinInfo[3].indexOf(" ");
            String qty = bookinInfo[3].substring(0,idx).trim();
            central.booking.seatType = central.types[selectedIndex];
            central.booking.seatQty = int.parse(qty);
            central.booking.seatNo= List<String>();
            print(central.booking.seatQty);
            Navigator.push(context, MaterialPageRoute(
                builder: (context)
            =>SelectSeatNumber(bookingInfo: bookinInfo,)

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
