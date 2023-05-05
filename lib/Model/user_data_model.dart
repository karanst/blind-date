/// error : false
/// message : "get successfully!"
/// date : [{"id":"66","ip_address":"110.226.56.252","username":"Shiva","password":"$2y$10$3smZu1VgChtbbsESKHQcue/lc1uiCyDU8lST0gS/mj7r8aMnpjutq","confirm_password":"12345678","email":"shivansh234@gmail.com","mobile":"9104698126","image":null,"gender":"male","balance":"0","activation_selector":"0c247915ab57c1c12175","activation_code":"$2y$10$PjAEaW0qnpgdjVj3PlOlHON6pzCqvexopBTX9VoVyfzDr.F9gAbc2","forgotten_password_selector":null,"forgotten_password_code":null,"forgotten_password_time":null,"remember_selector":null,"remember_code":null,"created_on":"1680592049","last_login":"1680592916","active":"1","company":null,"address":"nagaer","latitude":"22.7532848","longitude":"75.8936962","languages":null,"who_you_want_to_date":null,"age_group_from":"0","age_group_to":"10","bonus":null,"cash_received":"0.00","dob":"2023-04-04","country_code":null,"city":null,"area":null,"street":null,"license":"","vehicle":"","friends_code":null,"pincode":null,"serviceable_zipcodes":null,"apikey":null,"referral_code":null,"fcm_id":null,"open_close_status":"0","created_at":"2023-04-04 12:37:29","gst_file":"uploads/seller/download36.png","food_lic":"uploads/seller/download37.png","account_name":"Shiva","pro_pic":"uploads/seller/download38.png","account_number":"29128198291829","bank_code":"238298","bank_name":"sbi","bank_pass":"uploads/seller/download35.png","first_order":"","reffer_earn_status":"0","device_token":"","otp":null,"aadhar_front":null,"aadhar_back":null,"other_profiles":null,"age":null,"describe_yourself":null}]

class UserDataModel {
  UserDataModel({
      bool? error, 
      String? message, 
      List<Date>? date,}){
    _error = error;
    _message = message;
    _date = date;
}

  UserDataModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    if (json['date'] != null) {
      _date = [];
      json['date'].forEach((v) {
        _date?.add(Date.fromJson(v));
      });
    }
  }
  bool? _error;
  String? _message;
  List<Date>? _date;
UserDataModel copyWith({  bool? error,
  String? message,
  List<Date>? date,
}) => UserDataModel(  error: error ?? _error,
  message: message ?? _message,
  date: date ?? _date,
);
  bool? get error => _error;
  String? get message => _message;
  List<Date>? get date => _date;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['message'] = _message;
    if (_date != null) {
      map['date'] = _date?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "66"
/// ip_address : "110.226.56.252"
/// username : "Shiva"
/// password : "$2y$10$3smZu1VgChtbbsESKHQcue/lc1uiCyDU8lST0gS/mj7r8aMnpjutq"
/// confirm_password : "12345678"
/// email : "shivansh234@gmail.com"
/// mobile : "9104698126"
/// image : null
/// gender : "male"
/// balance : "0"
/// activation_selector : "0c247915ab57c1c12175"
/// activation_code : "$2y$10$PjAEaW0qnpgdjVj3PlOlHON6pzCqvexopBTX9VoVyfzDr.F9gAbc2"
/// forgotten_password_selector : null
/// forgotten_password_code : null
/// forgotten_password_time : null
/// remember_selector : null
/// remember_code : null
/// created_on : "1680592049"
/// last_login : "1680592916"
/// active : "1"
/// company : null
/// address : "nagaer"
/// latitude : "22.7532848"
/// longitude : "75.8936962"
/// languages : null
/// who_you_want_to_date : null
/// age_group_from : "0"
/// age_group_to : "10"
/// bonus : null
/// cash_received : "0.00"
/// dob : "2023-04-04"
/// country_code : null
/// city : null
/// area : null
/// street : null
/// license : ""
/// vehicle : ""
/// friends_code : null
/// pincode : null
/// serviceable_zipcodes : null
/// apikey : null
/// referral_code : null
/// fcm_id : null
/// open_close_status : "0"
/// created_at : "2023-04-04 12:37:29"
/// gst_file : "uploads/seller/download36.png"
/// food_lic : "uploads/seller/download37.png"
/// account_name : "Shiva"
/// pro_pic : "uploads/seller/download38.png"
/// account_number : "29128198291829"
/// bank_code : "238298"
/// bank_name : "sbi"
/// bank_pass : "uploads/seller/download35.png"
/// first_order : ""
/// reffer_earn_status : "0"
/// device_token : ""
/// otp : null
/// aadhar_front : null
/// aadhar_back : null
/// other_profiles : null
/// age : null
/// describe_yourself : null

class Date {
  Date({
      String? id, 
      String? ipAddress, 
      String? username, 
      String? password, 
      String? confirmPassword, 
      String? email, 
      String? mobile, 
      dynamic image, 
      String? gender, 
      String? balance, 
      String? activationSelector, 
      String? activationCode, 
      dynamic forgottenPasswordSelector, 
      dynamic forgottenPasswordCode, 
      dynamic forgottenPasswordTime, 
      dynamic rememberSelector, 
      dynamic rememberCode, 
      String? createdOn, 
      String? lastLogin, 
      String? active, 
      dynamic company, 
      String? address, 
      String? latitude, 
      String? longitude, 
      dynamic languages, 
      dynamic whoYouWantToDate, 
      String? ageGroupFrom, 
      String? ageGroupTo, 
      dynamic bonus, 
      String? cashReceived, 
      String? dob, 
      dynamic countryCode, 
      dynamic city, 
      dynamic area, 
      dynamic street, 
      String? license, 
      String? vehicle, 
      dynamic friendsCode, 
      dynamic pincode, 
      dynamic serviceableZipcodes, 
      dynamic apikey, 
      dynamic referralCode, 
      dynamic fcmId, 
      String? openCloseStatus, 
      String? createdAt, 
      String? gstFile, 
      String? foodLic, 
      String? accountName, 
      String? proPic, 
      String? accountNumber, 
      String? bankCode, 
      String? bankName, 
      String? bankPass, 
      String? firstOrder, 
      String? refferEarnStatus, 
      String? deviceToken, 
      dynamic otp, 
      dynamic aadharFront, 
      dynamic aadharBack, 
      dynamic otherProfiles, 
      dynamic age, 
      dynamic describeYourself,}){
    _id = id;
    _ipAddress = ipAddress;
    _username = username;
    _password = password;
    _confirmPassword = confirmPassword;
    _email = email;
    _mobile = mobile;
    _image = image;
    _gender = gender;
    _balance = balance;
    _activationSelector = activationSelector;
    _activationCode = activationCode;
    _forgottenPasswordSelector = forgottenPasswordSelector;
    _forgottenPasswordCode = forgottenPasswordCode;
    _forgottenPasswordTime = forgottenPasswordTime;
    _rememberSelector = rememberSelector;
    _rememberCode = rememberCode;
    _createdOn = createdOn;
    _lastLogin = lastLogin;
    _active = active;
    _company = company;
    _address = address;
    _latitude = latitude;
    _longitude = longitude;
    _languages = languages;
    _whoYouWantToDate = whoYouWantToDate;
    _ageGroupFrom = ageGroupFrom;
    _ageGroupTo = ageGroupTo;
    _bonus = bonus;
    _cashReceived = cashReceived;
    _dob = dob;
    _countryCode = countryCode;
    _city = city;
    _area = area;
    _street = street;
    _license = license;
    _vehicle = vehicle;
    _friendsCode = friendsCode;
    _pincode = pincode;
    _serviceableZipcodes = serviceableZipcodes;
    _apikey = apikey;
    _referralCode = referralCode;
    _fcmId = fcmId;
    _openCloseStatus = openCloseStatus;
    _createdAt = createdAt;
    _gstFile = gstFile;
    _foodLic = foodLic;
    _accountName = accountName;
    _proPic = proPic;
    _accountNumber = accountNumber;
    _bankCode = bankCode;
    _bankName = bankName;
    _bankPass = bankPass;
    _firstOrder = firstOrder;
    _refferEarnStatus = refferEarnStatus;
    _deviceToken = deviceToken;
    _otp = otp;
    _aadharFront = aadharFront;
    _aadharBack = aadharBack;
    _otherProfiles = otherProfiles;
    _age = age;
    _describeYourself = describeYourself;
}

  Date.fromJson(dynamic json) {
    _id = json['id'];
    _ipAddress = json['ip_address'];
    _username = json['username'];
    _password = json['password'];
    _confirmPassword = json['confirm_password'];
    _email = json['email'];
    _mobile = json['mobile'];
    _image = json['image'];
    _gender = json['gender'];
    _balance = json['balance'];
    _activationSelector = json['activation_selector'];
    _activationCode = json['activation_code'];
    _forgottenPasswordSelector = json['forgotten_password_selector'];
    _forgottenPasswordCode = json['forgotten_password_code'];
    _forgottenPasswordTime = json['forgotten_password_time'];
    _rememberSelector = json['remember_selector'];
    _rememberCode = json['remember_code'];
    _createdOn = json['created_on'];
    _lastLogin = json['last_login'];
    _active = json['active'];
    _company = json['company'];
    _address = json['address'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _languages = json['languages'];
    _whoYouWantToDate = json['who_you_want_to_date'];
    _ageGroupFrom = json['age_group_from'];
    _ageGroupTo = json['age_group_to'];
    _bonus = json['bonus'];
    _cashReceived = json['cash_received'];
    _dob = json['dob'];
    _countryCode = json['country_code'];
    _city = json['city'];
    _area = json['area'];
    _street = json['street'];
    _license = json['license'];
    _vehicle = json['vehicle'];
    _friendsCode = json['friends_code'];
    _pincode = json['pincode'];
    _serviceableZipcodes = json['serviceable_zipcodes'];
    _apikey = json['apikey'];
    _referralCode = json['referral_code'];
    _fcmId = json['fcm_id'];
    _openCloseStatus = json['open_close_status'];
    _createdAt = json['created_at'];
    _gstFile = json['gst_file'];
    _foodLic = json['food_lic'];
    _accountName = json['account_name'];
    _proPic = json['pro_pic'];
    _accountNumber = json['account_number'];
    _bankCode = json['bank_code'];
    _bankName = json['bank_name'];
    _bankPass = json['bank_pass'];
    _firstOrder = json['first_order'];
    _refferEarnStatus = json['reffer_earn_status'];
    _deviceToken = json['device_token'];
    _otp = json['otp'];
    _aadharFront = json['aadhar_front'];
    _aadharBack = json['aadhar_back'];
    _otherProfiles = json['other_profiles'];
    _age = json['age'];
    _describeYourself = json['describe_yourself'];
  }
  String? _id;
  String? _ipAddress;
  String? _username;
  String? _password;
  String? _confirmPassword;
  String? _email;
  String? _mobile;
  dynamic _image;
  String? _gender;
  String? _balance;
  String? _activationSelector;
  String? _activationCode;
  dynamic _forgottenPasswordSelector;
  dynamic _forgottenPasswordCode;
  dynamic _forgottenPasswordTime;
  dynamic _rememberSelector;
  dynamic _rememberCode;
  String? _createdOn;
  String? _lastLogin;
  String? _active;
  dynamic _company;
  String? _address;
  String? _latitude;
  String? _longitude;
  dynamic _languages;
  dynamic _whoYouWantToDate;
  String? _ageGroupFrom;
  String? _ageGroupTo;
  dynamic _bonus;
  String? _cashReceived;
  String? _dob;
  dynamic _countryCode;
  dynamic _city;
  dynamic _area;
  dynamic _street;
  String? _license;
  String? _vehicle;
  dynamic _friendsCode;
  dynamic _pincode;
  dynamic _serviceableZipcodes;
  dynamic _apikey;
  dynamic _referralCode;
  dynamic _fcmId;
  String? _openCloseStatus;
  String? _createdAt;
  String? _gstFile;
  String? _foodLic;
  String? _accountName;
  String? _proPic;
  String? _accountNumber;
  String? _bankCode;
  String? _bankName;
  String? _bankPass;
  String? _firstOrder;
  String? _refferEarnStatus;
  String? _deviceToken;
  dynamic _otp;
  dynamic _aadharFront;
  dynamic _aadharBack;
  dynamic _otherProfiles;
  dynamic _age;
  dynamic _describeYourself;
Date copyWith({  String? id,
  String? ipAddress,
  String? username,
  String? password,
  String? confirmPassword,
  String? email,
  String? mobile,
  dynamic image,
  String? gender,
  String? balance,
  String? activationSelector,
  String? activationCode,
  dynamic forgottenPasswordSelector,
  dynamic forgottenPasswordCode,
  dynamic forgottenPasswordTime,
  dynamic rememberSelector,
  dynamic rememberCode,
  String? createdOn,
  String? lastLogin,
  String? active,
  dynamic company,
  String? address,
  String? latitude,
  String? longitude,
  dynamic languages,
  dynamic whoYouWantToDate,
  String? ageGroupFrom,
  String? ageGroupTo,
  dynamic bonus,
  String? cashReceived,
  String? dob,
  dynamic countryCode,
  dynamic city,
  dynamic area,
  dynamic street,
  String? license,
  String? vehicle,
  dynamic friendsCode,
  dynamic pincode,
  dynamic serviceableZipcodes,
  dynamic apikey,
  dynamic referralCode,
  dynamic fcmId,
  String? openCloseStatus,
  String? createdAt,
  String? gstFile,
  String? foodLic,
  String? accountName,
  String? proPic,
  String? accountNumber,
  String? bankCode,
  String? bankName,
  String? bankPass,
  String? firstOrder,
  String? refferEarnStatus,
  String? deviceToken,
  dynamic otp,
  dynamic aadharFront,
  dynamic aadharBack,
  dynamic otherProfiles,
  dynamic age,
  dynamic describeYourself,
}) => Date(  id: id ?? _id,
  ipAddress: ipAddress ?? _ipAddress,
  username: username ?? _username,
  password: password ?? _password,
  confirmPassword: confirmPassword ?? _confirmPassword,
  email: email ?? _email,
  mobile: mobile ?? _mobile,
  image: image ?? _image,
  gender: gender ?? _gender,
  balance: balance ?? _balance,
  activationSelector: activationSelector ?? _activationSelector,
  activationCode: activationCode ?? _activationCode,
  forgottenPasswordSelector: forgottenPasswordSelector ?? _forgottenPasswordSelector,
  forgottenPasswordCode: forgottenPasswordCode ?? _forgottenPasswordCode,
  forgottenPasswordTime: forgottenPasswordTime ?? _forgottenPasswordTime,
  rememberSelector: rememberSelector ?? _rememberSelector,
  rememberCode: rememberCode ?? _rememberCode,
  createdOn: createdOn ?? _createdOn,
  lastLogin: lastLogin ?? _lastLogin,
  active: active ?? _active,
  company: company ?? _company,
  address: address ?? _address,
  latitude: latitude ?? _latitude,
  longitude: longitude ?? _longitude,
  languages: languages ?? _languages,
  whoYouWantToDate: whoYouWantToDate ?? _whoYouWantToDate,
  ageGroupFrom: ageGroupFrom ?? _ageGroupFrom,
  ageGroupTo: ageGroupTo ?? _ageGroupTo,
  bonus: bonus ?? _bonus,
  cashReceived: cashReceived ?? _cashReceived,
  dob: dob ?? _dob,
  countryCode: countryCode ?? _countryCode,
  city: city ?? _city,
  area: area ?? _area,
  street: street ?? _street,
  license: license ?? _license,
  vehicle: vehicle ?? _vehicle,
  friendsCode: friendsCode ?? _friendsCode,
  pincode: pincode ?? _pincode,
  serviceableZipcodes: serviceableZipcodes ?? _serviceableZipcodes,
  apikey: apikey ?? _apikey,
  referralCode: referralCode ?? _referralCode,
  fcmId: fcmId ?? _fcmId,
  openCloseStatus: openCloseStatus ?? _openCloseStatus,
  createdAt: createdAt ?? _createdAt,
  gstFile: gstFile ?? _gstFile,
  foodLic: foodLic ?? _foodLic,
  accountName: accountName ?? _accountName,
  proPic: proPic ?? _proPic,
  accountNumber: accountNumber ?? _accountNumber,
  bankCode: bankCode ?? _bankCode,
  bankName: bankName ?? _bankName,
  bankPass: bankPass ?? _bankPass,
  firstOrder: firstOrder ?? _firstOrder,
  refferEarnStatus: refferEarnStatus ?? _refferEarnStatus,
  deviceToken: deviceToken ?? _deviceToken,
  otp: otp ?? _otp,
  aadharFront: aadharFront ?? _aadharFront,
  aadharBack: aadharBack ?? _aadharBack,
  otherProfiles: otherProfiles ?? _otherProfiles,
  age: age ?? _age,
  describeYourself: describeYourself ?? _describeYourself,
);
  String? get id => _id;
  String? get ipAddress => _ipAddress;
  String? get username => _username;
  String? get password => _password;
  String? get confirmPassword => _confirmPassword;
  String? get email => _email;
  String? get mobile => _mobile;
  dynamic get image => _image;
  String? get gender => _gender;
  String? get balance => _balance;
  String? get activationSelector => _activationSelector;
  String? get activationCode => _activationCode;
  dynamic get forgottenPasswordSelector => _forgottenPasswordSelector;
  dynamic get forgottenPasswordCode => _forgottenPasswordCode;
  dynamic get forgottenPasswordTime => _forgottenPasswordTime;
  dynamic get rememberSelector => _rememberSelector;
  dynamic get rememberCode => _rememberCode;
  String? get createdOn => _createdOn;
  String? get lastLogin => _lastLogin;
  String? get active => _active;
  dynamic get company => _company;
  String? get address => _address;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  dynamic get languages => _languages;
  dynamic get whoYouWantToDate => _whoYouWantToDate;
  String? get ageGroupFrom => _ageGroupFrom;
  String? get ageGroupTo => _ageGroupTo;
  dynamic get bonus => _bonus;
  String? get cashReceived => _cashReceived;
  String? get dob => _dob;
  dynamic get countryCode => _countryCode;
  dynamic get city => _city;
  dynamic get area => _area;
  dynamic get street => _street;
  String? get license => _license;
  String? get vehicle => _vehicle;
  dynamic get friendsCode => _friendsCode;
  dynamic get pincode => _pincode;
  dynamic get serviceableZipcodes => _serviceableZipcodes;
  dynamic get apikey => _apikey;
  dynamic get referralCode => _referralCode;
  dynamic get fcmId => _fcmId;
  String? get openCloseStatus => _openCloseStatus;
  String? get createdAt => _createdAt;
  String? get gstFile => _gstFile;
  String? get foodLic => _foodLic;
  String? get accountName => _accountName;
  String? get proPic => _proPic;
  String? get accountNumber => _accountNumber;
  String? get bankCode => _bankCode;
  String? get bankName => _bankName;
  String? get bankPass => _bankPass;
  String? get firstOrder => _firstOrder;
  String? get refferEarnStatus => _refferEarnStatus;
  String? get deviceToken => _deviceToken;
  dynamic get otp => _otp;
  dynamic get aadharFront => _aadharFront;
  dynamic get aadharBack => _aadharBack;
  dynamic get otherProfiles => _otherProfiles;
  dynamic get age => _age;
  dynamic get describeYourself => _describeYourself;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['ip_address'] = _ipAddress;
    map['username'] = _username;
    map['password'] = _password;
    map['confirm_password'] = _confirmPassword;
    map['email'] = _email;
    map['mobile'] = _mobile;
    map['image'] = _image;
    map['gender'] = _gender;
    map['balance'] = _balance;
    map['activation_selector'] = _activationSelector;
    map['activation_code'] = _activationCode;
    map['forgotten_password_selector'] = _forgottenPasswordSelector;
    map['forgotten_password_code'] = _forgottenPasswordCode;
    map['forgotten_password_time'] = _forgottenPasswordTime;
    map['remember_selector'] = _rememberSelector;
    map['remember_code'] = _rememberCode;
    map['created_on'] = _createdOn;
    map['last_login'] = _lastLogin;
    map['active'] = _active;
    map['company'] = _company;
    map['address'] = _address;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['languages'] = _languages;
    map['who_you_want_to_date'] = _whoYouWantToDate;
    map['age_group_from'] = _ageGroupFrom;
    map['age_group_to'] = _ageGroupTo;
    map['bonus'] = _bonus;
    map['cash_received'] = _cashReceived;
    map['dob'] = _dob;
    map['country_code'] = _countryCode;
    map['city'] = _city;
    map['area'] = _area;
    map['street'] = _street;
    map['license'] = _license;
    map['vehicle'] = _vehicle;
    map['friends_code'] = _friendsCode;
    map['pincode'] = _pincode;
    map['serviceable_zipcodes'] = _serviceableZipcodes;
    map['apikey'] = _apikey;
    map['referral_code'] = _referralCode;
    map['fcm_id'] = _fcmId;
    map['open_close_status'] = _openCloseStatus;
    map['created_at'] = _createdAt;
    map['gst_file'] = _gstFile;
    map['food_lic'] = _foodLic;
    map['account_name'] = _accountName;
    map['pro_pic'] = _proPic;
    map['account_number'] = _accountNumber;
    map['bank_code'] = _bankCode;
    map['bank_name'] = _bankName;
    map['bank_pass'] = _bankPass;
    map['first_order'] = _firstOrder;
    map['reffer_earn_status'] = _refferEarnStatus;
    map['device_token'] = _deviceToken;
    map['otp'] = _otp;
    map['aadhar_front'] = _aadharFront;
    map['aadhar_back'] = _aadharBack;
    map['other_profiles'] = _otherProfiles;
    map['age'] = _age;
    map['describe_yourself'] = _describeYourself;
    return map;
  }

}