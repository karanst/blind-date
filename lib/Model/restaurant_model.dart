/// error : false
/// message : "Restaurants lists"
/// data : [{"id":"76","store_name":"Shosha","store_description":"Excellent Store ","logo":"https://developmentalphawizz.com/blind_date/uploads/seller/image_picker514298188169310186.jpg","no_of_ratings":"0","status":"1","open_close_status":"1","username":"Shiva","email":"shiva@gmail.com","mobile":"9928494837","address":"Vijay Nagar","pro_pic":"https://developmentalphawizz.com/blind_date/assets/no-image.png","is_date_available":false,"is_favourites":false,"booking_date":"","booking_time":"","booking_amount":"100","tables":[{"id":"2","name":"Roof Toop","res_id":"76","benifits":"AC, POOL, WiFi","price":"100","total_tables":"5","image":"https://developmentalphawizz.com/blind_date/","created_at":"2023-04-26 19:14:52","is_available":true},{"id":"19","name":"High Top Table","res_id":"76","benifits":"AC, POOL, WiFi","price":"100","total_tables":"5","image":"https://developmentalphawizz.com/blind_date/uploads/media/2023/romantic-rooftops-hero.jpg","created_at":"2023-04-28 12:39:36","is_available":true},{"id":"21","name":"High Top Table","res_id":"76","benifits":"AC, Wifi","price":"1000","total_tables":"5","image":"https://developmentalphawizz.com/blind_date/uploads/media/2023/images123.jpg","created_at":"2023-04-28 12:38:21","is_available":true},{"id":"59","name":"Sofas & Coffee Table","res_id":"76","benifits":"wifi","price":"5000","total_tables":"5","image":"https://developmentalphawizz.com/blind_date/uploads/table_images/image_picker4073291124711824934.jpg","created_at":"2023-04-28 20:44:48","is_available":true},{"id":"60","name":"High Top Table","res_id":"76","benifits":"free wifi, deinking","price":"1200","total_tables":"5","image":"https://developmentalphawizz.com/blind_date/uploads/table_images/image_picker4554114207476714663.jpg","created_at":"2023-04-28 22:05:13","is_available":true}]}]

class RestaurantModel {
  RestaurantModel({
      bool? error, 
      String? message, 
      List<Restaurants>? data,}){
    _error = error;
    _message = message;
    _data = data;
}

  RestaurantModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Restaurants.fromJson(v));
      });
    }
  }
  bool? _error;
  String? _message;
  List<Restaurants>? _data;
RestaurantModel copyWith({  bool? error,
  String? message,
  List<Restaurants>? data,
}) => RestaurantModel(  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get error => _error;
  String? get message => _message;
  List<Restaurants>? get data => _data;

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

/// id : "76"
/// store_name : "Shosha"
/// store_description : "Excellent Store "
/// logo : "https://developmentalphawizz.com/blind_date/uploads/seller/image_picker514298188169310186.jpg"
/// no_of_ratings : "0"
/// status : "1"
/// open_close_status : "1"
/// username : "Shiva"
/// email : "shiva@gmail.com"
/// mobile : "9928494837"
/// address : "Vijay Nagar"
/// pro_pic : "https://developmentalphawizz.com/blind_date/assets/no-image.png"
/// is_date_available : false
/// is_favourites : false
/// booking_date : ""
/// booking_time : ""
/// booking_amount : "100"
/// tables : [{"id":"2","name":"Roof Toop","res_id":"76","benifits":"AC, POOL, WiFi","price":"100","total_tables":"5","image":"https://developmentalphawizz.com/blind_date/","created_at":"2023-04-26 19:14:52","is_available":true},{"id":"19","name":"High Top Table","res_id":"76","benifits":"AC, POOL, WiFi","price":"100","total_tables":"5","image":"https://developmentalphawizz.com/blind_date/uploads/media/2023/romantic-rooftops-hero.jpg","created_at":"2023-04-28 12:39:36","is_available":true},{"id":"21","name":"High Top Table","res_id":"76","benifits":"AC, Wifi","price":"1000","total_tables":"5","image":"https://developmentalphawizz.com/blind_date/uploads/media/2023/images123.jpg","created_at":"2023-04-28 12:38:21","is_available":true},{"id":"59","name":"Sofas & Coffee Table","res_id":"76","benifits":"wifi","price":"5000","total_tables":"5","image":"https://developmentalphawizz.com/blind_date/uploads/table_images/image_picker4073291124711824934.jpg","created_at":"2023-04-28 20:44:48","is_available":true},{"id":"60","name":"High Top Table","res_id":"76","benifits":"free wifi, deinking","price":"1200","total_tables":"5","image":"https://developmentalphawizz.com/blind_date/uploads/table_images/image_picker4554114207476714663.jpg","created_at":"2023-04-28 22:05:13","is_available":true}]

class Restaurants {
  Restaurants({
      String? id, 
      String? storeName, 
      String? storeDescription, 
      String? logo, 
      String? noOfRatings, 
      String? status, 
      String? openCloseStatus, 
      String? username, 
      String? email, 
      String? mobile, 
      String? address, 
      String? proPic, 
      bool? isDateAvailable, 
      bool? isFavourites, 
      String? bookingDate, 
      String? bookingTime, 
      String? bookingAmount, 
      List<Tables>? tables,}){
    _id = id;
    _storeName = storeName;
    _storeDescription = storeDescription;
    _logo = logo;
    _noOfRatings = noOfRatings;
    _status = status;
    _openCloseStatus = openCloseStatus;
    _username = username;
    _email = email;
    _mobile = mobile;
    _address = address;
    _proPic = proPic;
    _isDateAvailable = isDateAvailable;
    _isFavourites = isFavourites;
    _bookingDate = bookingDate;
    _bookingTime = bookingTime;
    _bookingAmount = bookingAmount;
    _tables = tables;
}

  Restaurants.fromJson(dynamic json) {
    _id = json['id'];
    _storeName = json['store_name'];
    _storeDescription = json['store_description'];
    _logo = json['logo'];
    _noOfRatings = json['no_of_ratings'];
    _status = json['status'];
    _openCloseStatus = json['open_close_status'];
    _username = json['username'];
    _email = json['email'];
    _mobile = json['mobile'];
    _address = json['address'];
    _proPic = json['pro_pic'];
    _isDateAvailable = json['is_date_available'];
    _isFavourites = json['is_favourites'];
    _bookingDate = json['booking_date'];
    _bookingTime = json['booking_time'];
    _bookingAmount = json['booking_amount'];
    if (json['tables'] != null) {
      _tables = [];
      json['tables'].forEach((v) {
        _tables?.add(Tables.fromJson(v));
      });
    }
  }
  String? _id;
  String? _storeName;
  String? _storeDescription;
  String? _logo;
  String? _noOfRatings;
  String? _status;
  String? _openCloseStatus;
  String? _username;
  String? _email;
  String? _mobile;
  String? _address;
  String? _proPic;
  bool? _isDateAvailable;
  bool? _isFavourites;
  String? _bookingDate;
  String? _bookingTime;
  String? _bookingAmount;
  List<Tables>? _tables;
Restaurants copyWith({  String? id,
  String? storeName,
  String? storeDescription,
  String? logo,
  String? noOfRatings,
  String? status,
  String? openCloseStatus,
  String? username,
  String? email,
  String? mobile,
  String? address,
  String? proPic,
  bool? isDateAvailable,
  bool? isFavourites,
  String? bookingDate,
  String? bookingTime,
  String? bookingAmount,
  List<Tables>? tables,
}) => Restaurants(  id: id ?? _id,
  storeName: storeName ?? _storeName,
  storeDescription: storeDescription ?? _storeDescription,
  logo: logo ?? _logo,
  noOfRatings: noOfRatings ?? _noOfRatings,
  status: status ?? _status,
  openCloseStatus: openCloseStatus ?? _openCloseStatus,
  username: username ?? _username,
  email: email ?? _email,
  mobile: mobile ?? _mobile,
  address: address ?? _address,
  proPic: proPic ?? _proPic,
  isDateAvailable: isDateAvailable ?? _isDateAvailable,
  isFavourites: isFavourites ?? _isFavourites,
  bookingDate: bookingDate ?? _bookingDate,
  bookingTime: bookingTime ?? _bookingTime,
  bookingAmount: bookingAmount ?? _bookingAmount,
  tables: tables ?? _tables,
);
  String? get id => _id;
  String? get storeName => _storeName;
  String? get storeDescription => _storeDescription;
  String? get logo => _logo;
  String? get noOfRatings => _noOfRatings;
  String? get status => _status;
  String? get openCloseStatus => _openCloseStatus;
  String? get username => _username;
  String? get email => _email;
  String? get mobile => _mobile;
  String? get address => _address;
  String? get proPic => _proPic;
  bool? get isDateAvailable => _isDateAvailable;
  bool? get isFavourites => _isFavourites;
  String? get bookingDate => _bookingDate;
  String? get bookingTime => _bookingTime;
  String? get bookingAmount => _bookingAmount;
  List<Tables>? get tables => _tables;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['store_name'] = _storeName;
    map['store_description'] = _storeDescription;
    map['logo'] = _logo;
    map['no_of_ratings'] = _noOfRatings;
    map['status'] = _status;
    map['open_close_status'] = _openCloseStatus;
    map['username'] = _username;
    map['email'] = _email;
    map['mobile'] = _mobile;
    map['address'] = _address;
    map['pro_pic'] = _proPic;
    map['is_date_available'] = _isDateAvailable;
    map['is_favourites'] = _isFavourites;
    map['booking_date'] = _bookingDate;
    map['booking_time'] = _bookingTime;
    map['booking_amount'] = _bookingAmount;
    if (_tables != null) {
      map['tables'] = _tables?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "2"
/// name : "Roof Toop"
/// res_id : "76"
/// benifits : "AC, POOL, WiFi"
/// price : "100"
/// total_tables : "5"
/// image : "https://developmentalphawizz.com/blind_date/"
/// created_at : "2023-04-26 19:14:52"
/// is_available : true

class Tables {
  Tables({
      String? id, 
      String? name, 
      String? resId, 
      String? benifits, 
      String? price, 
      String? totalTables, 
      String? image, 
      String? createdAt, 
      bool? isAvailable,}){
    _id = id;
    _name = name;
    _resId = resId;
    _benifits = benifits;
    _price = price;
    _totalTables = totalTables;
    _image = image;
    _createdAt = createdAt;
    _isAvailable = isAvailable;
}

  Tables.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _resId = json['res_id'];
    _benifits = json['benifits'];
    _price = json['price'];
    _totalTables = json['total_tables'];
    _image = json['image'];
    _createdAt = json['created_at'];
    _isAvailable = json['is_available'];
  }
  String? _id;
  String? _name;
  String? _resId;
  String? _benifits;
  String? _price;
  String? _totalTables;
  String? _image;
  String? _createdAt;
  bool? _isAvailable;
Tables copyWith({  String? id,
  String? name,
  String? resId,
  String? benifits,
  String? price,
  String? totalTables,
  String? image,
  String? createdAt,
  bool? isAvailable,
}) => Tables(  id: id ?? _id,
  name: name ?? _name,
  resId: resId ?? _resId,
  benifits: benifits ?? _benifits,
  price: price ?? _price,
  totalTables: totalTables ?? _totalTables,
  image: image ?? _image,
  createdAt: createdAt ?? _createdAt,
  isAvailable: isAvailable ?? _isAvailable,
);
  String? get id => _id;
  String? get name => _name;
  String? get resId => _resId;
  String? get benifits => _benifits;
  String? get price => _price;
  String? get totalTables => _totalTables;
  String? get image => _image;
  String? get createdAt => _createdAt;
  bool? get isAvailable => _isAvailable;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['res_id'] = _resId;
    map['benifits'] = _benifits;
    map['price'] = _price;
    map['total_tables'] = _totalTables;
    map['image'] = _image;
    map['created_at'] = _createdAt;
    map['is_available'] = _isAvailable;
    return map;
  }

}