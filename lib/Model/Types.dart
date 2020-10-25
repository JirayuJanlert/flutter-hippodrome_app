

class Types {
  String typeName;
  double price;

  Types.fromMap(Map<String, dynamic> data){
    typeName = data['type_name'];
    price = double.parse(data['price'].toString());
  }
Types({this.typeName, this.price});

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type_name'] = this.typeName;
    data['price'] = this.price;


    return data;
  }
}