import 'package:flutter/material.dart';
import 'package:hippodrome_app2/Model/ItemGridSlot.dart';
import 'package:hippodrome_app2/Robot.dart';
import 'package:provider/provider.dart';

class WidgetItemGridSeatSlot extends StatefulWidget {
  ItemGridSeatSlotVM itemGridSeatSlotVM;

  WidgetItemGridSeatSlot({@required this.itemGridSeatSlotVM});


  @override
  _WidgetItemGridSeatSlotState createState() => _WidgetItemGridSeatSlotState();
}

class _WidgetItemGridSeatSlotState extends State<WidgetItemGridSeatSlot> {
  ItemGridSeatSlotVM itemGridSeatSlotVM;

  @override
  void initState() {
    super.initState();
  }



  @override
  Widget build(BuildContext context) {

    var central = Provider.of<Robot>(context);
    itemGridSeatSlotVM = widget.itemGridSeatSlotVM;

    return Container(
      color: Colors.white12,
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(itemGridSeatSlotVM.seatTypeName,),
          _buildSlotGrid(central),
        ],
      ),
    );
  }

  _buildSlotGrid(Robot central) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 40,
        maxHeight: 200,
      ),
      child: GridView.count(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        crossAxisCount: itemGridSeatSlotVM.maxColumn,
        scrollDirection: Axis.vertical,
        childAspectRatio: 1,
        crossAxisSpacing: 7,
        mainAxisSpacing: 7,
        children: _generatedGrid(central),
      ),
    );
  }

  List<Widget> _generatedGrid(Robot central) {
    List<Widget> widgets = [];

    itemGridSeatSlotVM.seatRowVMs.forEach((itemSeatRowVM) {
      //ITEM ROW NAME
      var itemRowName = Container(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            itemSeatRowVM.itemRowName,
          ),
        ),
      );

      widgets.add(itemRowName);



      //ITEM SEAT SLOT
      List<Widget> widgetSeatSlots = itemSeatRowVM.seatSlotVMs.map(
            (itemSeatSlotVM) {
          var itemBgColor = Colors.white;
          var itemBorderColor = Colors.black54;


          if (itemSeatSlotVM.isBooked) {
            itemBgColor = Colors.black54;
          }
          else{

            if (itemSeatSlotVM.isSelected) {
              itemBgColor = Colors.deepPurple;
              itemBorderColor = Colors.transparent;
            }else{
              if(itemSeatSlotVM.seatType == "Deluxe"){
                itemBgColor = Colors.purple[100];
              }
              if(itemSeatSlotVM.seatType == "Normal"){
                itemBgColor = Colors.white;
              }
              if(itemSeatSlotVM.seatType == "Sofa"){
                itemBgColor = Colors.red[100];
              }

            }
          }


          var itemAvailable = GestureDetector(
            onTap: () {
              setState(() {
                  central.handleSeatNumberSelection(itemSeatSlotVM, itemSeatRowVM, context);
              });
            },
            child: Container(
              decoration: BoxDecoration(
                color: itemBgColor,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: itemBorderColor,
                  width: 1,
                ),
              ),
           child: Center(child: Text('${itemSeatRowVM.itemRowName}${itemSeatSlotVM.seatId}',style: TextStyle(
             fontSize: 8,
              color: itemSeatSlotVM.isSelected? Colors.white : Colors.black
           ),)),
            ),
          );

          var itemEmpty = Container();

          return itemSeatSlotVM.isOff ? itemEmpty : itemAvailable;
        },
      ).toList();

      widgets.addAll(widgetSeatSlots);
    });

    return widgets;
  }


}