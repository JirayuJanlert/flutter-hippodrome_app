import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const headline3 = TextStyle(
    fontSize: 15, fontWeight: FontWeight.w700, color: Colors.blueGrey

);

const headline4 = TextStyle(
    fontSize: 10, fontWeight: FontWeight.w500, color: Colors.blueGrey,);
const headline5 = TextStyle(
    fontSize: 13, fontWeight: FontWeight.w700, color: Colors.grey,);

const headline2 = TextStyle(
    fontSize: 14, fontWeight: FontWeight.w800, color: Colors.deepPurple);
const headline1 = TextStyle(
    fontSize: 18, fontWeight: FontWeight.w800, color: Colors.deepPurple);
const text2 = TextStyle(fontSize: 12, color: Colors.black);
const text3 = TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black,);

BoxShadow defaultBoxShadow =  BoxShadow(
color: Colors.grey.withOpacity(0.5),
spreadRadius: 4,
blurRadius: 6,
offset: Offset(2, 2), // changes position of shadow
);