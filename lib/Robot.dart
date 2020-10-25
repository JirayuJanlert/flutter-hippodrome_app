import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hippodrome_app2/Model/Booking.dart';
import 'package:hippodrome_app2/Model/ItemGridSlot.dart';
import 'package:hippodrome_app2/Model/Movies.dart';
import 'package:hippodrome_app2/Screen/HomePage.dart';
import 'package:hippodrome_app2/Screen/LoginPage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hippodrome_app2/Model/Types.dart';
import 'package:intl/intl.dart';
import 'package:location/location.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

final databaseReference = FirebaseFirestore.instance;

class Robot extends ChangeNotifier {
  List<Movies> _movies = [];
  List<Movies> _categoriesMovies = [];
  List<Types> _types = [];
  bool _videoplay;
  int _selectedQty = 0;

  List<ItemGridSeatSlotVM> _itemGridSeatSlotVMs;

  List<ItemGridSeatSlotVM> get itemGridSeatSlotVMs => _itemGridSeatSlotVMs;

  int get selectedQty => _selectedQty;

  Movies _activeMovies;
  Booking _booking;

  List<String> _categories = [];

  List<List<Movies>> _pages = [];

  int _selectedCategories;

  // List<Movies> get movies => _movies;
  UnmodifiableListView<Movies> get movies => UnmodifiableListView(_movies);

  List<Movies> get categoriesMovies => _categoriesMovies;

  UnmodifiableListView<Types> get types => UnmodifiableListView(_types);

  Movies get activeMovies => _activeMovies;

  Booking get booking => _booking;

  bool get videoplay => _videoplay;

  List<List<Movies>> get pages => _pages;

  List<String> get categories => _categories;

  int get selectedCategories => _selectedCategories;


  set movies(List<Movies> movies) {
    _movies = movies;
    notifyListeners();
  }

  set categoriesMovies(List<Movies> movies) {
    _categoriesMovies = movies;
    notifyListeners();
  }

  set booking(Booking booking) {
    _booking = booking;
    notifyListeners();
  }

  Robot() {
    _itemGridSeatSlotVMs = [];

    _booking = Booking();

    _pages = [];
    _types = [];

    _selectedCategories = 0;

    _categories = ["All", "In Theatre", "Coming Soon"];

    _videoplay = false;
    notifyListeners();
  }

// sign in with email method from firebase auth
  signInWithEmail(BuildContext context,
      {@required String email,
      @required String password,
      @required FirebaseAuth auth}) async {
    await auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((result) {
      // print("Welcome " + result.user.uid);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
      return true;
    }).catchError((e) {
      print(e);
      switch (e.code) {
        case "ERROR_WRONG_PASSWORD":
          print("Wrong Password! Try again.");
          break;
        case "ERROR_INVALID_EMAIL":
          print("Invalid email");
          break;
        case "ERROR_USER_NOT_FOUND":
          print("User not found! Register first!");
          break;
        case "ERROR_USER_DISABLED":
          print("User has been disabled!, Try again");
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          print(
              "Sign in disabled due to too many requests from this user!, Try again");
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          print(
              "Operation not allowed!, Please enable it in the firebase console");
          break;
        default:
          print("Unknown error");
          CupertinoAlertDialog alert = CupertinoAlertDialog(
            title: Text("Login failed"),
            content: Text(e.message),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );

          // show the dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            },
          ); //end show dialog
      }
      return false;
    });
  }

  register(
    BuildContext context, {
    @required String email,
    @required String password,
    @required FirebaseAuth auth,
  }) async {
    await auth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((user) {
      auth.signOut();
      print("Sign up user successful.");
      AlertDialog alert = AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: Text("Sign-up user succesful"),
        content: Text("Please login"),
        actions: [
          RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Text("okay"),
              onPressed: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoginPage()));
              })
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      ); //end show dialog
    }).catchError((error) {
      print(error.message);
      CupertinoAlertDialog alert = CupertinoAlertDialog(
        title: Text("Sign up failed"),
        content: Text(error.message),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: new Text("Close"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context2) {
          return alert;
        },
      );
    });
  }

  void signOut(BuildContext context, FirebaseAuth auth) async {
    await auth.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
        ModalRoute.withName('/'));
  }

  void setActiveMovie(Movies m) {
    _activeMovies = m;
  }

  void changeSelectedCategories(var value) {
    _selectedCategories = value;
  }

  void createMoviesList(int selectedCate) {
    List<Movies> list = _movies;
    List<String> list2 = _categories;
    List<Movies> list3 = [];

    if (selectedCate == 0) {
      list3.addAll(_movies);
    } else {
      list.forEach((fruit) {
        if (fruit.categories == list2[selectedCate]) {
          list3.add(fruit);
        }
      });
    }
    _categoriesMovies = list3;
  }

  void setSearchKey(String query, int selectedCate, Robot central) {
    print("1");
    if (query != "") {
      _categoriesMovies.clear();
      _categoriesMovies.addAll(_movies
          .where((element) =>
              element.title.toLowerCase().contains(query.toLowerCase()))
          .toList());
    } else {
      createMoviesList(selectedCate);
    }
    notifyListeners();
    print(_categoriesMovies.length);
  }

  Future loginWithGoogle(BuildContext context, GoogleSignIn _googleSignIn,
      FirebaseAuth _auth) async {
    try {
      GoogleSignInAccount user = await _googleSignIn.signIn();

      GoogleSignInAuthentication userAuth = await user.authentication;
      print(user.email);
      print(user.displayName);
      print(user.id);
      print("sign in success");
      bool isSignedIn = await _googleSignIn.isSignedIn();
      await _auth.signInWithCredential(GoogleAuthProvider.credential(
          idToken: userAuth.idToken, accessToken: userAuth.accessToken));

      if (isSignedIn) {
        //move to new window
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } //end if
    } //end try
    catch (error) {
      print(error);
    }
  } //ef

  void moveTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  } //ef

  String buildlStringText(List sList) {
    String _output = "";
    int l = sList.length;
    sList.forEach((element) {
      _output += element;

      if (l > 1) {
        _output += " | ";
      }
      l -= 1;
    });
    return _output;
  } //ef

  String getDate(DateTime datetime) {
    String _releasedate = "";
    final df = new DateFormat('dd MMM yyyy');

    _releasedate = df.format(datetime).toString();

    return _releasedate;
  } //ef

  AppBar buildBuyTicketsAppBar(String title) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      elevation: 1,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: TextStyle(
            color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.more_horiz),
        )
      ],
    );
  }

  RatingBar buildRatingBar(double rating, int stars) {
    return RatingBar(
        glowRadius: 5,
        onRatingUpdate: null,
        initialRating: rating,
        minRating: 0,
        direction: Axis.horizontal,
        allowHalfRating: true,
        unratedColor: Colors.blueGrey,
        itemCount: stars,
        itemSize: 15,
        itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
        itemBuilder: (context, index) {
          if (stars == 1) {
            if (rating > 4 / 5) {
              return Icon(
                MdiIcons.emoticonExcited,
                color: Colors.greenAccent,
              );
            }
            if (rating > 2 / 5) {
              return Icon(
                MdiIcons.emoticonNeutral,
                color: Colors.blueGrey,
              );
            } else {
              return Icon(
                MdiIcons.emoticonPoop,
                color: Colors.brown,
              );
            }
          } else {
            switch (index) {
              case 0:
                return Icon(
                  Icons.sentiment_very_dissatisfied,
                  color: Colors.red,
                );
              case 1:
                return Icon(
                  Icons.sentiment_dissatisfied,
                  color: Colors.redAccent,
                );
              case 2:
                return Icon(
                  Icons.sentiment_neutral,
                  color: Colors.amber,
                );
              case 3:
                return Icon(
                  Icons.sentiment_satisfied,
                  color: Colors.lightGreen,
                );
              case 4:
                return Icon(
                  Icons.sentiment_very_satisfied,
                  color: Colors.green,
                );
            }
            return null;
          }
        });
  }

  Future<bool> getDataFromCloudFireStore() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('movies').get();

      List<Movies> _moviesList = [];

      snapshot.docs.forEach((element) {
        // print(element.data());
        Movies movie = Movies.fromMap(element.data());
        _moviesList.add(movie);
      });

      _movies = _moviesList;

      return true;
    } catch (e) {
      print(e);
    }
  }

  Future<bool> getTypesFromCloudFireStore() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('allSeatTypes').get();

      List<Types> _typesList = [];

      snapshot.docs.forEach((element) {
        print(element.data());
        Types _type = Types.fromMap(element.data());
        _typesList.add(_type);
      });
      _typesList.sort((a, b) => a.price.compareTo(b.price));
      _types = _typesList;

      return true;
    } catch (e) {
      print(e);
    }
  }

  getItemGridSeat() {
    _itemGridSeatSlotVMs = _activeMovies.items;
  }

  Stream<List<Booking>> getBookingInfoByCustomerId(String userId) {
    try {
      CollectionReference bookingRef = databaseReference.collection("booking");
      Query query = bookingRef.where("cusId", isEqualTo: userId);
      Stream<QuerySnapshot> querySnapshot = query.snapshots();

      return querySnapshot.map(
          (event) => event.docs.map((e) => Booking.fromMap(e.data())).toList());

      //   querySnapshot.docs.forEach((element) {
      //   print(element.data());
      //   Booking _b = Booking.fromMap(element.data());
      //   print(_b);
      //   _bookHistory.add(_b);
      // });

    } catch (e) {
      print(e);
    }
    // print(_bookHistory.iterator);
  }

//  google map function

  Future<LocationData> getLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  } //ef

  Marker mm({String id, String title, String snippet, double lat, double lon}) {
    Marker m1 = Marker(
      markerId: MarkerId(id),
      infoWindow: InfoWindow(title: title, snippet: snippet),
      position: LatLng(lat, lon),
    );
    return m1;
  } //ef

  openOnGoogleMapApp(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw Exception("could not open");
    }
  }

  openDirGoogleMapApp(String origin, String destination) async {
    String googleUrl = "https://www.google.com/maps/dir/?api=1&origin=" +
        origin +
        "&destination=" +
        destination +
        "&travelmode=driving&dir_action=navigate";

    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw Exception("could not open");
    }
  }

  Future<void> signOutfromApp(GoogleSignIn _googleSignIn, FirebaseAuth _auth,
      BuildContext context) async {
    try {
      bool isSigned = await _googleSignIn.isSignedIn();
      if (isSigned) {
        await _googleSignIn.signOut();
        print("you have log out");
      }
    } catch (error) {
      print(error);
    }
    signOut(
      context,
      _auth,
    );
  }

  AlertDialog buildAlert(String content) {
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      backgroundColor: Colors.transparent,
      content: Text(
        content,
        style: TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
    return alert;
  }

  // show the dialog

  void handleSeatNumberSelection(ItemSeatSlotVM itemSeatSlotVM,
      ItemSeatRowVM itemSeatRowVM, BuildContext context) {
    int idx = _booking.seatType.typeName.indexOf(" ");
    String type = _booking.seatType.typeName.substring(0, idx).trim();

    if (!itemSeatSlotVM.isOff) {
      if (!itemSeatSlotVM.isBooked) {
        if (itemSeatSlotVM.seatType == type) {
          if (!itemSeatSlotVM.isSelected) {
            if (_selectedQty < _booking.seatQty) {
              _selectedQty += 1;
              _booking.seatNo
                  .add(itemSeatRowVM.itemRowName + itemSeatSlotVM.seatId);
              print(_selectedQty.toString() + "sel");
              itemSeatSlotVM.isSelected = true;
              print(itemSeatSlotVM.isBooked);
            } else {
              AlertDialog alert = buildAlert("You have selected all seats");
              showDialog(
                  context: context,
                  builder: (context) {
                    Future.delayed(Duration(seconds: 1), () {
                      Navigator.of(context).pop(true);
                    });
                    return alert;
                  });
            }
          } else {
            _selectedQty -= 1;
            _booking.seatNo.removeWhere((element) =>
                element == itemSeatRowVM.itemRowName + itemSeatSlotVM.seatId);
            itemSeatSlotVM.isSelected = false;
          }
        } else {
          AlertDialog alert = buildAlert("This seat is not your selected type");
          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 1), () {
                  Navigator.of(context).pop(true);
                });
                return alert;
              });
        }
      } else {
        AlertDialog alert = buildAlert("This seat is booked");
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
  }

  void handleClearisSelectionSeatState() {
    _selectedQty = 0;
    itemGridSeatSlotVMs.forEach((element) {
      element.seatRowVMs.forEach((element) {
        element.seatSlotVMs.forEach((element) {
          element.isSelected = false;
        });
      });
    });
  }

  Future<void> createbookingRecord(BuildContext context) async {
    var docData = _booking.toMap();
    final ProgressDialog pr = new ProgressDialog(context);
    pr.style(
      message: 'Completing booking',
      progressWidget:
          SpinKitWave(color: Colors.blueGrey, type: SpinKitWaveType.start),
      elevation: 10.0,
    );
    try {
      await pr.show();
      await databaseReference
          .collection("booking")
          .add(docData)
          .whenComplete(() {
        _itemGridSeatSlotVMs.forEach((element) {
          element.seatRowVMs.forEach((element) {
            element.seatSlotVMs.forEach((element) {
              if (element.isSelected == true) {
                element.isBooked = true;
              }
            });
          });
        });

        List<Map> seatItems =
            _itemGridSeatSlotVMs.map((i) => i.toMap()).toList();

        databaseReference
            .collection('movies')
            .doc(_booking.bookedMovies.toString())
            .update({'showInfo.seatGrid': seatItems});
      }).whenComplete(() {
        _booking = new Booking();
        Future.delayed(Duration(seconds: 2)).then((value) async {
          pr.update(message: "Booking is completed");
        });
      });

      Future.delayed(Duration(seconds: 3)).then((value) async {
        pr.hide().whenComplete(() {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
              (route) => false);
        });
      });
    } catch (e) {
      print(e);
    }
  }
} //ec
