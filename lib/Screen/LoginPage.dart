import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hippodrome_app2/Robot.dart';
import 'package:hippodrome_app2/Screen/SignupPage.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
GoogleSignIn _googleSignIn ;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();

  }


  Widget build(BuildContext context) {
    _googleSignIn = GoogleSignIn(
      scopes: [
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: h * 0.9,
        padding: EdgeInsets.only(top: h * 0.1, left: w * 0.1, right: w * 0.1),
        child: LoginForm(
          w: w,
          h: h,
          googleSignIn: _googleSignIn
        ),
      ),
      persistentFooterButtons: <Widget>[
        Container(
            height: h * 0.05,
            width: w * 1.2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Don't Have an Account?"),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignupPage()));
                  },
                  child: Text(
                    "  SignUp",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.redAccent),
                  ),
                )
              ],
            ))
      ],
      resizeToAvoidBottomPadding: false,
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key key,
    @required this.w,
    @required this.h,
    @required this.googleSignIn,
  }) : super(key: key);

  final double w;
  final double h;
  final GoogleSignIn googleSignIn;

//
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool success;
  String userEmail;
  String password;
//  bool google_login;


  @override
  Widget build(BuildContext context) {
    var central = Provider.of<Robot>(context);
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              width: widget.w,
              alignment: Alignment.center,
              child: Image.asset('assets/icons/Logo.png'),
            ),
            SizedBox(
              height: widget.h * 0.05,
            ),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "This is required field";
                }
                return null;
              },
              controller: _usernameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  hintText: "email address"),
            ),
            SizedBox(
              height: widget.h * 0.03,
            ),
            PasswordFormField(
              controller: _passwordController,
            ),
            Container(
                padding: EdgeInsets.only(
                    top: widget.h * 0.04, left: widget.w * 0.45),
                child: GestureDetector(
                    onTap: () {},
                    child: Text(
                      "Forget Password?",
                      style: TextStyle(color: Colors.blue),
                    ))),
            SizedBox(
              height: widget.h * 0.05,
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: widget.w ,
              height: widget.h * 0.11,
              child: RaisedButton(
                onPressed: () async {
                  setState(() {
                    userEmail = _usernameController.text;
                    password = _passwordController.text;
                  });
                  if (_formKey.currentState.validate()) {
                    print(userEmail + password);
                    central.signInWithEmail(context,
                        email: userEmail,
                        password: password,
                        auth: _auth);
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40)),
                child: Text(
                  "Log-in with Email",
                  style: TextStyle(
                      color: Colors.white, letterSpacing: 2, fontSize: 18),
                ),
                color: Colors.deepPurple,
                highlightElevation: 0,
              ),
            ),
            SizedBox(
              height: widget.h * 0.01,
            ),
            Container(
              padding: EdgeInsets.all(10),
              width: widget.w * 1,
              height: widget.h * 0.11,
              child: OutlineButton(
                highlightElevation: 0,
                onPressed: () async {
                    central.loginWithGoogle(context, widget.googleSignIn,_auth);
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                color: Colors.white,
                borderSide: BorderSide(color: Colors.grey),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image(
                        image: AssetImage("assets/icons/google_logo.png"),
                        height: 35.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class PasswordFormField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordFormField({Key key, @required this.controller})
      : assert(controller != null),
        super(key: key);

  @override
  _PasswordFormFieldState createState() => _PasswordFormFieldState();
}

class _PasswordFormFieldState extends State<PasswordFormField> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return "This is required field";
        }
        return null;
      },
      controller: widget.controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        hintText: "password",
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _showPassword = !_showPassword;
            });
          },
          child: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
        ),
        focusedBorder:
        OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
      ),
      obscureText: !_showPassword,
    );
  }
} //ec