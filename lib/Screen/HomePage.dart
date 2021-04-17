import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hippodrome_app2/CSS.dart';
import 'package:hippodrome_app2/Model/Movies.dart';
import 'package:hippodrome_app2/Robot.dart';
import 'package:hippodrome_app2/Screen/BookingHistory.dart';
import 'package:hippodrome_app2/Widget/BottomNavBar.dart';
import 'package:hippodrome_app2/Widget/Categorylist.dart';
import 'package:hippodrome_app2/Widget/MovieCard.dart';
import 'package:hippodrome_app2/Widget/PopUpMenu.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;
GoogleSignIn _googleSignIn;

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  User user = _auth.currentUser;

  TextEditingController searchTxt = TextEditingController();
  FocusNode searchNode = FocusNode();
  PageController _pageController;
  bool search = false;
  int selectedPosition = 0;
  var currentPageValue = 0.0;
  Widget cusSearchBar = Text(
    "Hippodrome",
    style: TextStyle(color: Colors.white),
  );
  Icon cusIcon = Icon(
    Icons.search,
    color: Colors.white,
  );
  bool searchIsExpanded = false;
  Icon cusIcons2 = Icon(MdiIcons.menu);

  @override
  initState() {
    Robot central = Provider.of<Robot>(context, listen: false);
    central.getTypesFromCloudFireStore();
    central.getBookingInfoByCustomerId(user.uid);
    _googleSignIn = GoogleSignIn();
    print(user.email);
    print(user.displayName);
    _pageController =
        PageController(initialPage: selectedPosition, keepPage: true);
    _pageController.addListener(() {
      setState(() {
        currentPageValue = _pageController.page;
        selectedPosition = 0;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  void changePageViewPostion(int whichPage) {
    if (_pageController != null) {
      if (whichPage == 2 && currentPageValue == 0.0) {
        _pageController.jumpToPage(whichPage + 1);
      } else if (whichPage == 0 && currentPageValue == 2.0) {
        _pageController.jumpToPage(whichPage - 1);
      }

      _pageController.animateToPage(whichPage,
          curve: Curves.decelerate, duration: Duration(milliseconds: 350));
    }
  }

  @override
  Widget build(BuildContext context) {

    var central = Provider.of<Robot>(context);
    print(central.movies.length);
    print(central.categoriesMovies.length);

//    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    // double w = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 5,
        centerTitle: true,
        brightness: Brightness.light,
        backgroundColor: Colors.deepPurple,
        titleSpacing: 5,
        title: cusSearchBar,
        actions: <Widget>[
          IconButton(
            splashColor: Colors.transparent,
            color: Colors.black,
            highlightColor: Colors.transparent,
            onPressed: () {
              setState(() {
                if (this.cusIcon.icon == Icons.search) {
                  searchIsExpanded = true;
                  cusIcon = Icon(
                    MdiIcons.close,
                    color: Colors.white,
                  );
                  this.cusSearchBar = buildSearchBar(central);
                } else {
                  searchIsExpanded = false;
                  this.cusIcon = Icon(
                    Icons.search,
                    color: Colors.white,
                  );
                  this.cusSearchBar =
                      Text("Hippodrome", style: TextStyle(color: Colors.white));
                  this.searchTxt.text = "";
                  central.createMoviesList(central.selectedCategories);
                }
              });
              buildSearchBar(central);
            },
            icon: cusIcon,
          ),
          Visibility(
            visible: !searchIsExpanded,
            child: myPopMenu(context, _googleSignIn,_auth, central),
          ),
        ],
        bottomOpacity: 2,
      ),
      drawer: buildDrawer(),
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }

        },
        child: Container(
          child: Column(
            children: <Widget>[
              SizedBox(
                  height: h * 0.07,
                  child: CategoryList(
                    categories: central.categories,
                    changePage: changePageViewPostion,
                  )),
              Expanded(
                child: FutureBuilder(
                  initialData: true,
                  future: central.getDataFromCloudFireStore(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if(search != true){
                          central.createMoviesList(central.selectedCategories);
                        }
                        return buildMoviePageView(
                            central, central.categoriesMovies);
                      } else {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SpinKitWave(
                                  color: Colors.blueGrey, type: SpinKitWaveType.start),
                              Text("Loading")
                            ],
                          )
                        );
                      }
                    }

                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: BottomNavBar(
          isActive1: true,
          isActive2: false,
          isActive3: false,
        ),
      ),
    );
  }

  Drawer buildDrawer() {
    if (user.photoURL != null) {
      return Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.symmetric(horizontal: 70),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 48,
                    child: ClipOval(
                        child: FadeInImage.assetNetwork(
                      placeholder: "assets/icons/user.png",
                      image: user.photoURL,
                      fit: BoxFit.fill,
                    )),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    user.displayName,
                    style: headline3,
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => BookingHistory()
                ));
              },
              child: ListTile(
                leading: Icon(MdiIcons.history),
                title: Text("Booking History"),
              ),
            ),
          ],
        ),
      );
    } else {
      return Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.symmetric(horizontal: 70),
              child: Column(
                children: <Widget>[
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: AssetImage("assets/icons/user.png"),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    user.email,
                    style: headline3,
                  )
                ],
              ),
            ),
            GestureDetector(
              onTap: (){
                Navigator.of(context).pop();
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => BookingHistory()
                ));
              },
              child: ListTile(
                leading: Icon(MdiIcons.history),
                title: Text("Booking History"),
              ),
            ),
          ],
        ),
      );
    }
  }

  TextField buildSearchBar(Robot central) {
    return TextField(
      cursorColor: Colors.black,
      autofocus: true,
      focusNode: searchNode,
      controller: searchTxt,
      onChanged: (text) {
        setState(() {
          if (text.isNotEmpty) {
            changePageViewPostion(0);
            search = true;
            central.setSearchKey(text, selectedPosition,central);
          } else {
            search = false;
            central.setSearchKey(text, selectedPosition, central);
          }
        });
      },
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: Colors.transparent,
            style: BorderStyle.solid,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: Colors.transparent,
            style: BorderStyle.solid,
          ),
        ),
        hintStyle: TextStyle(color: Colors.white30),
        contentPadding:
            EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
        hintText: "Search Movies",
        filled: true,
        fillColor: Colors.black38,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide(
            color: Colors.white,
            style: BorderStyle.solid,
          ),
        ),
      ),
    );
  }

  PageView buildMoviePageView(Robot central, List<Movies> _movieList) {
    return PageView.builder(
      controller: _pageController,
      itemCount: central.categories.length,
      scrollDirection: Axis.horizontal,
      allowImplicitScrolling: true,
      physics: BouncingScrollPhysics(),
      onPageChanged: (value) {
        setState(() {
          central.changeSelectedCategories(value);
          central.createMoviesList(central.selectedCategories);
        });
      },
      itemBuilder: (context, index) {
        return buildMovieListPage(_movieList, central);
      },
    );
  }

  Container buildMovieListPage(List<Movies> _movieList, Robot central) {
    return Container(
      child: new GridView.builder(

        itemCount: _movieList.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: MediaQuery.of(context).size.height * 0.00001,
          crossAxisSpacing: MediaQuery.of(context).size.width * 0.042,
          childAspectRatio: MediaQuery.of(context).size.height * 0.00068,
          crossAxisCount: 2,
        ),
        itemBuilder: (BuildContext context, int index) {
          return MovieCard(
            title: _movieList[index].title,
            pics: _movieList[index].pics,
            rating: _movieList[index].rating,
            m: _movieList[index],
            initialpage: index,
            releasedDate: central.getDate(_movieList[index].releaseDate.toDate()),
          );
        },
      ),
    );
  }



}
