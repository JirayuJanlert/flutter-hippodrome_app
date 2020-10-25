import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ticket_widget/flutter_ticket_widget.dart';
import 'package:hippodrome_app2/CSS.dart';
import 'package:hippodrome_app2/Robot.dart';
import 'package:hippodrome_app2/Screen/HomePage.dart';
import 'package:hippodrome_app2/Widget/BuyTicketHeaderWidget.dart';
import 'package:provider/provider.dart';
final FirebaseAuth _auth = FirebaseAuth.instance;

class ConfirmPage extends StatefulWidget {
  final List<String> bookingInfo;

  const ConfirmPage({Key key, this.bookingInfo}) : super(key: key);

  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {

  TextEditingController _emailController = TextEditingController();
  TextEditingController _fnC = TextEditingController();
  TextEditingController _snC = TextEditingController();
  TextEditingController _phoneCon = TextEditingController();
  List<String> bookinInfo;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String seatnos = "";
  bool click = false;
  User user = _auth.currentUser;
  double totalAmount = 0;
  bool _validate = true;

  bool _agreeCheck = false;
  initState() {
    Robot central = Provider.of<Robot>(context, listen: false);
    bookinInfo = widget.bookingInfo;



        setState(() {
          _emailController.text =user.email;
              seatnos = central.booking.seatNo.join(",");
      print(seatnos);

      if(user.phoneNumber!= null){
        _phoneCon.text = user.phoneNumber;
      }
    });



    super.initState();
  }

  @override
  void dispose() {
    click = false;

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var central = Provider.of<Robot>(context);
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;


    totalAmount = central.booking.seatQty*central.booking.seatType.price;

    setState(() {
      if (click == false) {
        if (bookinInfo.length > 5) {
          bookinInfo.removeLast();
        }
      }
      bookinInfo.add(seatnos);
    });
    return Scaffold(
      resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,

        appBar: central.buildBuyTicketsAppBar("Confirm & Pay"),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            child: Center(
              child: FlutterTicketWidget(
                  color: Colors.blueGrey[100],
                  width: w,
                  height: _validate? h * 1.28: h*1.35,
                  isCornerRounded: true,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Column(
                                children: [
                                  Container(
                                    height: h * 0.05,
                                    child: Row(
                                      children: [
                                        Text(
                                          "First Name",
                                          style: text2,
                                        ),
                                        SizedBox(
                                          width: w * 0.33,
                                        ),
                                        Text(
                                          "Last Name",
                                          style: text2,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(

                                          controller: _fnC,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return "This is required field";
                                            }
                                            return null;
                                          },
                                          // controller: _usernameController,
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(top: 10, left: 10),
                                              hintStyle: TextStyle(
                                                color: Colors.black26,
                                              ),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black)),
                                              focusedBorder:
                                                  OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide(
                                                              color: Colors
                                                                  .black)),
                                              hintText: "First Name"),
                                        ),
                                      ),
                                      SizedBox(
                                        width: w * 0.1,
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          controller: _snC,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return "This is required field";
                                            }
                                            return null;
                                          },
                                          // controller: _usernameController,
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(top: 10, left: 10),
                                              hintStyle: TextStyle(
                                                color: Colors.black26,
                                              ),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black)),
                                              focusedBorder:
                                                  OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide(
                                                              color: Colors
                                                                  .black)),
                                              hintText: "Last Name"),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: h * 0.05,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: h * 0.05,
                                    child: Text(
                                      "Mobile No.",
                                      style: text2,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _phoneCon,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return "This is required field";
                                            }
                                            return null;
                                          },
                                          // controller: _usernameController,
                                          decoration: InputDecoration(
                                              contentPadding: EdgeInsets.only(top: 10, left: 10),
                                              hintStyle: TextStyle(
                                                color: Colors.black26,
                                              ),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black)),
                                              focusedBorder:
                                                  OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide(
                                                              color: Colors
                                                                  .black)),
                                              hintText: "Mobile No."),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(
                                height: h * 0.05,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: h * 0.05,
                                    child: Text(
                                      "E-mail Address",
                                      style: text2,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          controller: _emailController,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return "This is required field";
                                            }
                                            return null;
                                          },
                                          autofocus: false,
                                          // controller: _usernameController,
                                          decoration: InputDecoration(
                                            contentPadding: EdgeInsets.only(top: 10, left: 10),
                                              hintStyle: TextStyle(
                                                color: Colors.black26,
                                              ),
                                              border: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: Colors.black)),
                                              focusedBorder:
                                                  OutlineInputBorder(
                                                      borderSide:
                                                          BorderSide(
                                                              color: Colors
                                                                  .black)),
                                              hintText: "E-mail Address"),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    IconButton(
                                      iconSize: 30,
                                      enableFeedback: false,
                                      highlightColor: Colors.transparent,
                                      splashColor: Colors.transparent,
                                      icon: Icon(
                                        Icons.check_circle,
                                        color: _agreeCheck == false
                                            ? Colors.grey
                                            : Colors.lightGreenAccent,
                                        size: 25,
                                      ),
                                      onPressed: () async {
                                        setState(() {
                                          _agreeCheck = !_agreeCheck;
                                        });
                                      },
                                    ),
                                    Text("I agree with:  "),
                                    Text(
                                      "Terms & Policies",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Divider(
                        thickness: 5,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              "Booking Details",
                              style: headline3,
                            ),
                          ),
                          Transform.scale(
                            scale: 0.8,
                            child: BuyTicketHeaderWidget(
                                central: central, bookinInfo: bookinInfo),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [

                            Text("Total Amount Payable: ",textAlign: TextAlign.center,style: headline5,),
                            SizedBox(
                              width: 20,
                            ),
                            Text((totalAmount).toString()+" Baht",style: text3,),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        width: w,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(

                              width: 150,
                              height: 50,
                              child: RaisedButton(
                                elevation: 5,
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                onPressed: () {


                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                                    builder: (context) => HomePage()
                                  ), (route) => false);
                                },
                                child: Text("Cancel",style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18
                                )),
                              ),
                            ) ,
                            Container(
                              width: 150,
                              height: 50,
                              child: RaisedButton(
                                elevation: 5,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                color: Colors.deepPurple,
                                onPressed: () {
                                  setState(() {
                                    _validate= _formKey.currentState.validate();
                                  });
                                  if(_formKey.currentState.validate()){
                                    if(_agreeCheck ==true){
                                      central.booking.cusId = user.uid;
                                      central.booking.cus_fn= _fnC.text;
                                      central.booking.cus_ln= _snC.text;
                                      central.booking.mobile= _phoneCon.text;
                                      central.booking.email = _emailController.text;
                                      central.booking.total = totalAmount;
                                      central.createbookingRecord(context);
                                    }else{
                                     AlertDialog alert = central.buildAlert("Please agree to the term and condition");
                                     showDialog(
                                         context: context,
                                         builder: (context) {
                                           Future.delayed(Duration(seconds: 1), () {
                                             Navigator.of(context).pop(true);
                                           });
                                           return alert;
                                         });
                                    }
                                
                                  }
                                },
                                child: Text("Book", style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18
                                ),),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  )
              ),
            ),
          ),
        ));
  }
} //ec
