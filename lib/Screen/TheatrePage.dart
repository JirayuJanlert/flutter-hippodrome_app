import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hippodrome_app2/Robot.dart';
import 'package:hippodrome_app2/Widget/BottomNavBar.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';


class TheatrePage extends StatefulWidget {
  @override
  _TheatrePageState createState() => _TheatrePageState();
}

class _TheatrePageState extends State<TheatrePage> {
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> markers = Set();
   LocationData _locationData;

  getLatlnfromRobot() async{
    Robot central = Provider.of<Robot>(context, listen: false);
   _locationData = await central.getLocation();
    print(_locationData);

  }

  @override
   void initState()  {
    // Robot central = Provider.of<Robot>(context, listen: false);

    getLatlnfromRobot();
    _controller.future.then((controller) {
      controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(13.75398, 100.50144),
        // target: LatLng(_locationData.latitude, _locationData.longitude),
        zoom: 10.5,
      )));});


    super.initState();//ef
  }
  @override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var central = Provider.of<Robot>(context);
    CollectionReference theatre =
        FirebaseFirestore.instance.collection('theatres');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 5,
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.deepPurple,
        titleSpacing: 5,

        title: Text(
          "Theatre",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: StreamBuilder(
          stream: theatre.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("error"));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
          int id = 1;
            snapshot.data.docs.forEach((element){
              id += 1;
              markers.add(central.mm(id: id.toString(),title:element.data()['name'], snippet: element.data()['place'],lat:element.data()['latitude'],lon: element.data()['longitude']));
            });

            return Column(
              children: [
                SizedBox(
                  height:MediaQuery.of(context).size.height * 0.5 ,
                  child: Card(
                    elevation: 5,
                    child: GoogleMap(
                      myLocationEnabled: true,
                      markers: this.markers,
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(12.7650836, 100.5379664),
                        zoom: 16,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 1.5,
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (
                          context,
                          index,
                        ) {

                          return buildListTheatre(
                              context, snapshot.data.docs[index],central);
                        }),
                  ),
                ),
              ],
            );
          }),
      bottomNavigationBar: Container(
        child: BottomNavBar(
          isActive1: false,
          isActive2: true,
          isActive3: false,
        ),
      ),
    );
  }

  Card buildListTheatre(BuildContext context, DocumentSnapshot document, Robot central) {

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 5,
      child: ListTile(
        title: Text(document.data()['name']),
        subtitle: Text(document.data()['place']),
        trailing: Container(
          width: 100,
          child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.location_on,
                  color: Colors.red,
                ),
                onPressed: () {
                  central.openOnGoogleMapApp(document.data()['latitude'], document.data()['longitude']);
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.directions,
                  color: Colors.black87,
                ),
                onPressed: () {
                  String dest = document.data()["latitude"].toString()+","+document.data()["latitude"].toString();
                  String origin = _locationData.latitude.toString() +"," + _locationData.longitude.toString();
                  central.openDirGoogleMapApp(origin,dest);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  //ef
} //ec
