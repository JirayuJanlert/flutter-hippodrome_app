import 'package:flutter/material.dart';
import 'package:hippodrome_app2/CSS.dart';
import 'package:hippodrome_app2/Robot.dart';
import 'package:hippodrome_app2/Screen/ConfirmPage.dart';
import 'package:hippodrome_app2/Widget/BuyTicketHeaderWidget.dart';
import 'package:hippodrome_app2/Widget/ScreenWidget.dart';
import 'package:hippodrome_app2/Widget/widget_item_grid_seat_slot.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class SelectSeatNumber extends StatefulWidget {
  final List<String> bookingInfo;
  const SelectSeatNumber({
    Key key,
    this.bookingInfo
  }) : super(key: key);

  @override
  _SelectSeatNumberState createState() => _SelectSeatNumberState();
}

class _SelectSeatNumberState extends State<SelectSeatNumber> {
  List<String> bookinInfo;
  double totalAmount;
  bool click;

  initState() {
    bookinInfo = widget.bookingInfo;

    super.initState();
  }
  @override
  void dispose() {
    click = false;
    if (bookinInfo.length > 4) {
      bookinInfo.removeLast();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {



    var central = Provider.of<Robot>(context, listen: true );
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;




    setState(() {

      totalAmount = central.booking.seatType.price*central.booking.seatQty;
    });

    return Scaffold(
        appBar: central.buildBuyTicketsAppBar("Buy Ticket"),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          scrollDirection: Axis.vertical,
          children: [
            Container(
              child:  BuyTicketHeaderWidget(central: central, bookinInfo: bookinInfo),
            ),
            SizedBox(
              height: h*0.15,
              child: ScreenWidget(),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
                    child: _buildListItemGridSeatSlot(central),
                  ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(10),
                width: w*0.45,
                height: h*0.12,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueGrey,width: 2,style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text((totalAmount).toString()+" Baht",style: text3,),
                    Text("Total Amount Payable",textAlign: TextAlign.center,style: headline5,),
                  ],
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(),
              margin: EdgeInsets.symmetric(horizontal: 115, vertical: 30),
              child: NextToSeatTypeSelection(bookinInfo: bookinInfo),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
          ],
        ));
  } } //ec

class NextToSeatTypeSelection extends StatelessWidget {
  const NextToSeatTypeSelection({
    Key key,
    @required this.bookinInfo,
  }) : super(key: key);

  final List<String> bookinInfo;

  @override
  Widget build(BuildContext context) {
    var central = Provider.of<Robot>(context);
    return OutlineButton(
        onPressed: () {
          if(central.selectedQty < central.booking.seatQty ){
            Scaffold.of(context).showSnackBar(
                SnackBar(
                    backgroundColor: Colors.deepPurple,
                    duration: Duration(seconds: 2),
                    content: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.alertCircle,
                          color: Colors.redAccent,
                          size: 25,
                        ),
                        Text(
                          'Please select ' + central.booking.seatQty.toString() + ' seats!',
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ],
                    )));
          } else{
            Navigator.push(context, MaterialPageRoute(
                builder: (context) => ConfirmPage(bookingInfo: bookinInfo,)
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
Widget _buildListItemGridSeatSlot(Robot central) {
  List<Widget> widgets = [];

  central.itemGridSeatSlotVMs.forEach(
        (itemGridSeatSlotVM) {
      widgets.add(
        WidgetItemGridSeatSlot(itemGridSeatSlotVM: itemGridSeatSlotVM),
      );
      widgets.add(
        SizedBox(height: 14,),
      );
    },
  );

  return Column(
    mainAxisSize: MainAxisSize.min,
    children: widgets,
  );
}
