import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hippodrome_app2/Robot.dart';
import 'package:hippodrome_app2/Screen/LoginPage.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _agreeCheck = false;
  ScrollController _controller;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _password2Controller = TextEditingController();
  TextEditingController _phoneCon = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var central = Provider.of<Robot>(context);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title: Text("Sign Up"),
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
          },
          icon: Icon(
            Icons.arrow_back,
            size: 20,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        controller: _controller,
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: 40, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Create an account",
                          style:
                              TextStyle(fontSize: 15, color: Colors.grey[700]),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Card(
                          color: Colors.grey[70],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: <Widget>[
                                MakeInput(
                                  label: "E-mail",
                                  textfieldController: _emailController,
                                  validation: (value) {
                                    if (value.isEmpty) {
                                      return "Please input email";
                                    }
                                    return null;
                                  },
                                ),
                                MakeInput(
                                  label: "Phone number",
                                  textfieldController: _phoneCon,
                                  validation: (value) {
                                    if (value.isEmpty) {
                                      return "Please input phone no.";
                                    }
                                    return null;
                                  },
//                                  move: _moveUp(),
                                ),
                                MakeInput(
                                  label: "Password",
                                  obscureText: true,
                                  textfieldController: _passwordController,
//                                    move2: _moveUp(),
//                                  move: _moveDown(),
                                  validation: (value) {
                                    if (value.length < 8) {
                                      return "password must be more than 8 characters";
                                    }
                                    return null;
                                  },
                                ),
                                MakeInput(
                                  label: "Confirm  Password",
                                  obscureText: true,
                                  textfieldController: _password2Controller,
                                  validation: (value) {
                                    // ignore: missing_return
                                    if (_passwordController.text != value) {
                                      return "password is not match";
                                    }
                                    return null;
                                  },
//                                    move2: _moveUp()
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Positioned(
                              left: 15,
                              top: 15,
                              child: Icon(
                                Icons.check,
                                color:
                                    _agreeCheck ? Colors.black : Colors.white,
                                size: 20,
                              ),
                            ),
                            IconButton(
                              iconSize: 30,
                              enableFeedback: false,
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              icon: Icon(
                                Icons.check_box_outline_blank,
                                color: Colors.black,
                                size: 25,
                              ),
                              onPressed: () async {
                                setState(() {
                                  _agreeCheck = !_agreeCheck;
                                });
                              },
                            ),
                          ],
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
                  ]),
            )),
      ),
      bottomNavigationBar: Container(
        height: 100,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 5),
        child: MaterialButton(
          minWidth: double.infinity,
          height: 60,
          highlightElevation: 0,
          splashColor: Colors.transparent,
          onPressed: () async {
            if (_formKey.currentState.validate() && _agreeCheck == true) {
              central.register(
                context,
                email: _emailController.text,
                password: _passwordController.text,
                auth: _auth,
              );
            } else {
              if (_agreeCheck == false) {
                AlertDialog alert = AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  title: Text("Sign up failed"),
                  content: Text(
                      "Please check agree to the terms and policies tick box"),
                  actions: [
                    RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Text("okay"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                );

                // show the dialog
                showDialog(
                  context: context,
                  builder: (BuildContext context2) {
                    return alert;
                  },
                ); //end show dialog
              }
            }
          },
          color: Colors.deepPurple,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            "Sign Up",
            style: TextStyle(
                fontWeight: FontWeight.w600, fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Don't forget to dispose the ScrollController.
    _controller.dispose();
    super.dispose();
  }
}

class MakeInput extends StatefulWidget {
  final String label;
  final bool obscureText;
  final Future move;
  final TextEditingController textfieldController;
  final Function validation;

  const MakeInput({
    Key key,
    this.obscureText,
    this.move,
    this.validation,
    @required this.label,
    @required this.textfieldController,
  }) : super(key: key);

  @override
  _MakeInputState createState() => _MakeInputState();
}

class _MakeInputState extends State<MakeInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 8,
          ),
          Text(
            widget.label,
            style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.black87),
          ),
          SizedBox(
            height: 3,
          ),
          Padding(
            padding: const EdgeInsets.all(10.5),
            child: TextFormField(
              controller: widget.textfieldController,
              validator: widget.validation,
//              onFieldSubmitted: (type) async {
//
//              },
              onTap: () {
//                widget.move;
              },
//                obscureText: widget.obscureText,
              decoration: InputDecoration(
                labelText: widget.label,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400])),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey[400])),
              ),
            ),
          ),
        ],
      ),
    );
  }
} //ec
