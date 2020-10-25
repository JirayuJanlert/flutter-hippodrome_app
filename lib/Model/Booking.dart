import 'package:hippodrome_app2/Model/Types.dart';

class Booking {
  int bookedMovies;
  String bookedDate;
  String bookedTime;
  String bookedTheatre;
  int seatQty;
  double total;
  Types seatType;
  List<String> seatNo;
  String cus_fn;
  String cus_ln;
  String mobile;
  String email;
  String cusId;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['bookedMovies'] = this.bookedMovies;
    data['bookedDate'] = this.bookedDate;
    data['bookedTime'] = this.bookedTime;
    data['bookedTheatre'] = this.bookedTheatre;
    data['seatQty'] = this.seatQty;
    data['seatType'] = this.seatType.toMap();
    data['seatNo'] = this.seatNo;
    data['cus_fn'] = this.cus_fn;
    data['cus_ln'] = this.cus_ln;
    data['mobile'] = this.mobile;
    data['cusId'] = this.cusId;
    data['total'] = this.total;
    data['email'] = this.email;

    return data;
  }

  Booking.fromMap(Map<String, dynamic> data) {
    bookedMovies = data['bookedMovies'];
    bookedDate = data['bookedDate'];
    bookedTime = data['bookedTime'];
    bookedTheatre = data['bookedTheatre'];
    seatQty = data['seatQty'];
    total = data['total'];
    seatType = Types.fromMap(data['seatType']);
    seatNo = data['seatNo'].cast<String>();
    cus_fn = data['cus_fn'];
    cus_ln = data['cus_ln'];
    mobile = data['mobile'];
    email = data['email'];
    cusId = data['cusId'];
  }

  Booking(
      {this.bookedMovies,
      this.bookedDate,
      this.cus_fn,
      this.cus_ln,
      this.mobile,
      this.bookedTime,
      this.bookedTheatre,
      this.total,
      this.seatQty,
      this.seatType,
      this.cusId,
      this.seatNo});
}
