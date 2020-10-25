import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hippodrome_app2/Robot.dart';
import 'package:hippodrome_app2/Screen/BookingHistory.dart';
import 'package:hippodrome_app2/Screen/HomePage.dart';
import 'package:hippodrome_app2/Screen/TheatrePage.dart';
import 'package:provider/provider.dart';




class BottomNavBar extends StatefulWidget {
  final bool isActive1;
  final bool isActive2;
  final bool isActive3;

  const BottomNavBar({
    Key key,
    this.isActive1,
    this.isActive2,
    this.isActive3,
  }) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  @override
  Widget build(BuildContext context) {
    var central = Provider.of<Robot>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 45, vertical: 10),
      height: 78,
      color: Color.fromRGBO(204, 205, 231, 1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          BottomNavItem(
            title: "Home",
            svgScr: "assets/icons/home.png",
            isActive: widget.isActive1,
            press: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
          ),
          BottomNavItem(
            title: "Theatre",
            svgScr: "assets/icons/theater.png",
            isActive: widget.isActive2,
            press: () {
              central.changeSelectedCategories(0);
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => TheatrePage()));
            },
          ),
          BottomNavItem(
            title: "Profile",
            svgScr: "assets/icons/user.png",
            isActive: widget.isActive3,
            press: () {
              central.changeSelectedCategories(0);
              central.changeSelectedCategories(0);
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BookingHistory()));

            },
          ),
        ],
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final String svgScr;
  final String title;
  final Function press;
  final bool isActive;

  const BottomNavItem({
    Key key,
    this.svgScr,
    this.title,
    this.press,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          buildIcon(),
          SizedBox(
            height: 2,
          ),
          Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.deepPurple : Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIcon() {
    FirebaseAuth _auth = FirebaseAuth.instance;
    User user = _auth.currentUser;
    if (user.photoURL != null && title == "Profile") {
      return CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 15,
        child: ClipOval(
            child: FadeInImage.assetNetwork(
          placeholder: "assets/icons/user.png",
          image: user.photoURL,
          fit: BoxFit.fill,
        )),
      );
    } else {
      return Image.asset(
        svgScr,
        width: isActive ? 30 : 25,
        height: isActive ? 30 : 30,
        color: isActive ? Colors.deepPurple : Colors.blueGrey,
      );
    }
  }
}
