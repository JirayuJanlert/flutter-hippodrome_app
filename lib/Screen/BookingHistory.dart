import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ticket_widget/flutter_ticket_widget.dart';
import 'package:hippodrome_app2/Model/Booking.dart';
import 'package:hippodrome_app2/Model/Movies.dart';
import 'package:hippodrome_app2/Robot.dart';
import 'package:provider/provider.dart';

class BookingHistory extends StatefulWidget {
  @override
  _BookingHistoryState createState() => _BookingHistoryState();
}

class _BookingHistoryState extends State<BookingHistory> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var central = Provider.of<Robot>(context);
    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          elevation: 0,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          title: Text(
            "Booking History",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          ),
        ),
        body: StreamBuilder<List<Booking>>(
            stream: central.getBookingInfoByCustomerId(_auth.currentUser.uid),
            builder: (context, snapshot) {
              print(snapshot.data);
              if (snapshot.hasError) {
                return Center(child: Text("error"));
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    Movies m = central.movies.singleWhere((element) =>
                        element.id == snapshot.data[index].bookedMovies);
                    return buildBookHistoryMethod(m, snapshot, index);
                  });
            }));
  }

  Padding buildBookHistoryMethod(
      Movies m, AsyncSnapshot<List<Booking>> snapshot, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FlutterTicketWidget(
          width: 100,
          height: 200,
          child: Container(
            width: 350,
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(m.pics),
                fit: BoxFit.fill,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 3),
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 100,
                      width: 550,
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                m.title,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                snapshot.data[index].bookedDate +
                                    " -- " +
                                    snapshot.data[index].bookedTime,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300),
                              ),
                              Text(
                                snapshot.data[index].seatQty.toString() +
                                    " " +
                                    snapshot.data[index].seatType.typeName,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w300),
                              )
                            ],
                          ),
                      Text(
                        snapshot.data[index].total.toString()+ " Baht",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize:17,
                            fontWeight: FontWeight.w600),)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Divider(
                        color: Colors.white,
                        thickness: 2,
                      ),
                    ),
                    Container(
                      width: 500,
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            snapshot.data[index].bookedTheatre,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w300),
                          ),
                          Container(
                            height: 50,
                            child: VerticalDivider(
                              thickness: 2,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            snapshot.data[index].seatNo.join(","),
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )),
    );
  }
} //ec
