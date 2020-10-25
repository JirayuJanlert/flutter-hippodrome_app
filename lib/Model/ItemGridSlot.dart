// ignore: slash_for_doc_comments
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

// /**
//     ItemGridSeatSlotVM
//     --------ItemSeatRowVM
//     ----------ItemSeatSlotVM
//  */
class ItemGridSeatSlotVM extends Equatable {
  int maxColumn;
  String seatTypeName;

  List<ItemSeatRowVM> seatRowVMs;

  ItemGridSeatSlotVM({
    @required this.maxColumn,
    @required this.seatTypeName,
    @required this.seatRowVMs,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    List<Map> seatRowVMsList =
    this.seatRowVMs != null ? this.seatRowVMs.map((i) => i.toMap()).toList() : null;
    data['maxColumn'] = this.maxColumn;
    data['seatTypeName'] = this.seatTypeName;
    data['seatRowVMs'] = seatRowVMsList;

    return data;
  }
  ItemGridSeatSlotVM.fromMap(Map<String, dynamic> data){
    maxColumn =  data['maxColumn'];
    seatTypeName =    data['seatTypeName'];
    seatRowVMs =  List<ItemSeatRowVM>.from(data['seatRowVMs'].map((x) => ItemSeatRowVM.fromMap(x)));
  }

  @override
  List<Object> get props => [maxColumn, seatTypeName, seatRowVMs];
}


class ItemSeatRowVM extends Equatable {
  String itemRowName;

  List<ItemSeatSlotVM> seatSlotVMs;

  ItemSeatRowVM({
    @required this.itemRowName,
    @required this.seatSlotVMs,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    List<Map> seatSlotVMsList =
    this.seatSlotVMs != null ? this.seatSlotVMs.map((i) => i.toMap()).toList() : null;

    data['itemRowName'] = this.itemRowName;
    data['seatSlotVMs'] = seatSlotVMsList;

    return data;
  }
  ItemSeatRowVM.fromMap(Map<String, dynamic> data){
    itemRowName = data['itemRowName'];
    seatSlotVMs = List<ItemSeatSlotVM>.from(data["seatSlotVMs"].map((x) => ItemSeatSlotVM.fromMap(x)));
  }
  @override
  List<Object> get props => [itemRowName, seatSlotVMs];
}

class ItemSeatSlotVM extends Equatable {
  String seatId;
  bool isOff;
  bool isBooked;
  bool isSelected;
  String seatType;

  ItemSeatSlotVM({
    @required this.seatId,
    @required this.isOff,
    @required this.isBooked,
    @required this.isSelected,
    @required this.seatType,
  });

  @override
  List<Object> get props => [seatId, isSelected, seatType];

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['seatId'] = this.seatId;
    data['isOff'] = this.isOff;
    data['isBooked'] = this.isBooked;
    data['isSelected'] = this.isSelected;
    data['seatType'] = this.seatType;

    return data;
  }


  ItemSeatSlotVM.fromMap(Map<String, dynamic> data){
    seatId =   data['seatId'];
    isOff =     data['isOff'];
    isBooked   = data['isBooked'];
    isSelected =   data['isSelected'];
    seatType = data['seatType'];
  }
  @override
  String toString() {
    return 'ItemSeatSlotVM{seatId: $seatId}';
  }
}