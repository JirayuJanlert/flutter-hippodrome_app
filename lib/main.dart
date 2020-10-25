import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hippodrome_app2/Robot.dart';
import 'package:hippodrome_app2/Screen/HomePage.dart';
import 'package:hippodrome_app2/Screen/LoginPage.dart';
import 'package:hippodrome_app2/Screen/SplashScreen.dart';
import 'package:provider/provider.dart';

var routes = <String, WidgetBuilder>{
  "/login": (BuildContext context) => LoginPage(),
  "/home":(BuildContext context) => HomePage(),
};


void main() {
  return runApp(ChangeNotifierProvider(
      create: (context) {
        return Robot();
      },
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme(
            Theme.of(context).textTheme,
          ),),
      home: SplashScreen(),
      routes: routes,
      debugShowCheckedModeBanner: false,
    );
  }
}