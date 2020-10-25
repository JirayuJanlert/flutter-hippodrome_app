import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hippodrome_app2/Model/ItemGridSlot.dart';

class Movies {
  String title;
  double rating;
  String categories;
  String pics;
  List genres;
  List director;
  String desc;
  List casts;
  List theatres;
  int id;
  String video;
  List<ShowDateTime> showDateTime;
  Timestamp releaseDate;
  List<ItemGridSeatSlotVM> items;

  Movies.fromMap(Map<String, dynamic> data){
    title = data['title'];
    categories = data['categories'];
    pics = data['pics'];
    casts = data['casts'];
    director = data['director'];
    video = data['video'];
    rating = double.parse(data['rating'].toString());
    theatres = data['theatres'];
    showDateTime = List<ShowDateTime>.from(data['showInfo']['showDateTime'].map((x) => ShowDateTime.fromMap(x)));
    desc = data['desc'];
    releaseDate = data['release date'];
    genres = data['genres'];
    id = data['id'];
    items = List<ItemGridSeatSlotVM>.from(data['showInfo']['seatGrid'].map((x) => ItemGridSeatSlotVM.fromMap(x))
    );

  }

}

class ShowDateTime{
  String day;
  String month;
  String weekday;
  List<String> showTime;

  ShowDateTime.fromMap(Map<String, dynamic> data){
   day = data['day'];
   month = data['month'];
   weekday = data['weekday'];
   showTime = data['showTime'].cast<String>();

  }
}
