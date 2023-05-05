/// error : false
/// message : "Promo Codes"
/// data : [{"id":"2","promo_code":"Dinner_Starts","message":"Discount Get","start_date":"2023-05-01","end_date":"2023-05-10","discount":"99","repeat_usage":"Not Allowed","min_order_amt":"500","no_of_users":"5","discount_type":"amount","max_discount_amt":"200","image":"https://developmentalphawizz.com/blind_date/uploads/media/2023/claire-restaurant-dining-table-faux-marble-round-m1.jpg","no_of_repeat_usage":"0","status":"1","remaining_days":"9"}]

class GetCouponModel {
  GetCouponModel({
      bool? error, 
      String? message, 
      List<Coupons>? data,}){
    _error = error;
    _message = message;
    _data = data;
}

  GetCouponModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Coupons.fromJson(v));
      });
    }
  }
  bool? _error;
  String? _message;
  List<Coupons>? _data;
GetCouponModel copyWith({  bool? error,
  String? message,
  List<Coupons>? data,
}) => GetCouponModel(  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get error => _error;
  String? get message => _message;
  List<Coupons>? get data => _data;

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

/// id : "2"
/// promo_code : "Dinner_Starts"
/// message : "Discount Get"
/// start_date : "2023-05-01"
/// end_date : "2023-05-10"
/// discount : "99"
/// repeat_usage : "Not Allowed"
/// min_order_amt : "500"
/// no_of_users : "5"
/// discount_type : "amount"
/// max_discount_amt : "200"
/// image : "https://developmentalphawizz.com/blind_date/uploads/media/2023/claire-restaurant-dining-table-faux-marble-round-m1.jpg"
/// no_of_repeat_usage : "0"
/// status : "1"
/// remaining_days : "9"

class Coupons {
  Coupons({
      String? id, 
      String? promoCode, 
      String? message, 
      String? startDate, 
      String? endDate, 
      String? discount, 
      String? repeatUsage, 
      String? minOrderAmt, 
      String? noOfUsers, 
      String? discountType, 
      String? maxDiscountAmt, 
      String? image, 
      String? noOfRepeatUsage, 
      String? status, 
      String? remainingDays,}){
    _id = id;
    _promoCode = promoCode;
    _message = message;
    _startDate = startDate;
    _endDate = endDate;
    _discount = discount;
    _repeatUsage = repeatUsage;
    _minOrderAmt = minOrderAmt;
    _noOfUsers = noOfUsers;
    _discountType = discountType;
    _maxDiscountAmt = maxDiscountAmt;
    _image = image;
    _noOfRepeatUsage = noOfRepeatUsage;
    _status = status;
    _remainingDays = remainingDays;
}

  Coupons.fromJson(dynamic json) {
    _id = json['id'];
    _promoCode = json['promo_code'];
    _message = json['message'];
    _startDate = json['start_date'];
    _endDate = json['end_date'];
    _discount = json['discount'];
    _repeatUsage = json['repeat_usage'];
    _minOrderAmt = json['min_order_amt'];
    _noOfUsers = json['no_of_users'];
    _discountType = json['discount_type'];
    _maxDiscountAmt = json['max_discount_amt'];
    _image = json['image'];
    _noOfRepeatUsage = json['no_of_repeat_usage'];
    _status = json['status'];
    _remainingDays = json['remaining_days'];
  }
  String? _id;
  String? _promoCode;
  String? _message;
  String? _startDate;
  String? _endDate;
  String? _discount;
  String? _repeatUsage;
  String? _minOrderAmt;
  String? _noOfUsers;
  String? _discountType;
  String? _maxDiscountAmt;
  String? _image;
  String? _noOfRepeatUsage;
  String? _status;
  String? _remainingDays;
Coupons copyWith({  String? id,
  String? promoCode,
  String? message,
  String? startDate,
  String? endDate,
  String? discount,
  String? repeatUsage,
  String? minOrderAmt,
  String? noOfUsers,
  String? discountType,
  String? maxDiscountAmt,
  String? image,
  String? noOfRepeatUsage,
  String? status,
  String? remainingDays,
}) => Coupons(  id: id ?? _id,
  promoCode: promoCode ?? _promoCode,
  message: message ?? _message,
  startDate: startDate ?? _startDate,
  endDate: endDate ?? _endDate,
  discount: discount ?? _discount,
  repeatUsage: repeatUsage ?? _repeatUsage,
  minOrderAmt: minOrderAmt ?? _minOrderAmt,
  noOfUsers: noOfUsers ?? _noOfUsers,
  discountType: discountType ?? _discountType,
  maxDiscountAmt: maxDiscountAmt ?? _maxDiscountAmt,
  image: image ?? _image,
  noOfRepeatUsage: noOfRepeatUsage ?? _noOfRepeatUsage,
  status: status ?? _status,
  remainingDays: remainingDays ?? _remainingDays,
);
  String? get id => _id;
  String? get promoCode => _promoCode;
  String? get message => _message;
  String? get startDate => _startDate;
  String? get endDate => _endDate;
  String? get discount => _discount;
  String? get repeatUsage => _repeatUsage;
  String? get minOrderAmt => _minOrderAmt;
  String? get noOfUsers => _noOfUsers;
  String? get discountType => _discountType;
  String? get maxDiscountAmt => _maxDiscountAmt;
  String? get image => _image;
  String? get noOfRepeatUsage => _noOfRepeatUsage;
  String? get status => _status;
  String? get remainingDays => _remainingDays;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['promo_code'] = _promoCode;
    map['message'] = _message;
    map['start_date'] = _startDate;
    map['end_date'] = _endDate;
    map['discount'] = _discount;
    map['repeat_usage'] = _repeatUsage;
    map['min_order_amt'] = _minOrderAmt;
    map['no_of_users'] = _noOfUsers;
    map['discount_type'] = _discountType;
    map['max_discount_amt'] = _maxDiscountAmt;
    map['image'] = _image;
    map['no_of_repeat_usage'] = _noOfRepeatUsage;
    map['status'] = _status;
    map['remaining_days'] = _remainingDays;
    return map;
  }

}