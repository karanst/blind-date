/// error : false
/// message : "Date lists"
/// data : [{"table_name":"High Top Table","store_name":"Shosha","address":"Vijay Nagar","id":"5","unique_id":"1234","res_id":"76","table_type":"19","approx_amount":"100","status":"2","created_at":"2023-04-28 22:02:14","booking_date":"2023-04-29","booking_time":"16:00:00","update_at":"2023-04-28 22:02:14"}]

class MyBookingsModel {
  MyBookingsModel({
      bool? error, 
      String? message, 
      List<Bookings>? data,}){
    _error = error;
    _message = message;
    _data = data;
}

  MyBookingsModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Bookings.fromJson(v));
      });
    }
  }
  bool? _error;
  String? _message;
  List<Bookings>? _data;
MyBookingsModel copyWith({  bool? error,
  String? message,
  List<Bookings>? data,
}) => MyBookingsModel(  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get error => _error;
  String? get message => _message;
  List<Bookings>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// table_name : "High Top Table"
/// store_name : "Shosha"
/// address : "Vijay Nagar"
/// id : "5"
/// unique_id : "1234"
/// res_id : "76"
/// table_type : "19"
/// approx_amount : "100"
/// status : "2"
/// created_at : "2023-04-28 22:02:14"
/// booking_date : "2023-04-29"
/// booking_time : "16:00:00"
/// update_at : "2023-04-28 22:02:14"

class Bookings {
  Bookings({
      String? tableName, 
      String? storeName, 
      String? address, 
      String? id, 
      String? uniqueId, 
      String? resId, 
      String? tableType, 
      String? approxAmount, 
      String? status, 
      String? createdAt, 
      String? bookingDate, 
      String? bookingTime, 
      String? updateAt,}){
    _tableName = tableName;
    _storeName = storeName;
    _address = address;
    _id = id;
    _uniqueId = uniqueId;
    _resId = resId;
    _tableType = tableType;
    _approxAmount = approxAmount;
    _status = status;
    _createdAt = createdAt;
    _bookingDate = bookingDate;
    _bookingTime = bookingTime;
    _updateAt = updateAt;
}

  Bookings.fromJson(dynamic json) {
    _tableName = json['table_name'];
    _storeName = json['store_name'];
    _address = json['address'];
    _id = json['id'];
    _uniqueId = json['unique_id'];
    _resId = json['res_id'];
    _tableType = json['table_type'];
    _approxAmount = json['approx_amount'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _bookingDate = json['booking_date'];
    _bookingTime = json['booking_time'];
    _updateAt = json['update_at'];
  }
  String? _tableName;
  String? _storeName;
  String? _address;
  String? _id;
  String? _uniqueId;
  String? _resId;
  String? _tableType;
  String? _approxAmount;
  String? _status;
  String? _createdAt;
  String? _bookingDate;
  String? _bookingTime;
  String? _updateAt;
Bookings copyWith({  String? tableName,
  String? storeName,
  String? address,
  String? id,
  String? uniqueId,
  String? resId,
  String? tableType,
  String? approxAmount,
  String? status,
  String? createdAt,
  String? bookingDate,
  String? bookingTime,
  String? updateAt,
}) => Bookings(  tableName: tableName ?? _tableName,
  storeName: storeName ?? _storeName,
  address: address ?? _address,
  id: id ?? _id,
  uniqueId: uniqueId ?? _uniqueId,
  resId: resId ?? _resId,
  tableType: tableType ?? _tableType,
  approxAmount: approxAmount ?? _approxAmount,
  status: status ?? _status,
  createdAt: createdAt ?? _createdAt,
  bookingDate: bookingDate ?? _bookingDate,
  bookingTime: bookingTime ?? _bookingTime,
  updateAt: updateAt ?? _updateAt,
);
  String? get tableName => _tableName;
  String? get storeName => _storeName;
  String? get address => _address;
  String? get id => _id;
  String? get uniqueId => _uniqueId;
  String? get resId => _resId;
  String? get tableType => _tableType;
  String? get approxAmount => _approxAmount;
  String? get status => _status;
  String? get createdAt => _createdAt;
  String? get bookingDate => _bookingDate;
  String? get bookingTime => _bookingTime;
  String? get updateAt => _updateAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['table_name'] = _tableName;
    map['store_name'] = _storeName;
    map['address'] = _address;
    map['id'] = _id;
    map['unique_id'] = _uniqueId;
    map['res_id'] = _resId;
    map['table_type'] = _tableType;
    map['approx_amount'] = _approxAmount;
    map['status'] = _status;
    map['created_at'] = _createdAt;
    map['booking_date'] = _bookingDate;
    map['booking_time'] = _bookingTime;
    map['update_at'] = _updateAt;
    return map;
  }

}