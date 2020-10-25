class Theater {
  String name;
  String place;

  // Theater({this.name, this.place});

  Theater.fromMap(Map<String, dynamic> data){
    name = data['name'];
    place = data['price'];
  }


}
