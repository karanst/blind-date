import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:blind_date/Helper/AppBtn.dart';
import 'package:blind_date/Helper/Color.dart';
import 'package:blind_date/Helper/Constant.dart';
import 'package:blind_date/Helper/Session.dart';
import 'package:blind_date/Helper/String.dart';
import 'package:blind_date/Helper/cropped_container.dart';
import 'package:blind_date/Helper/custom_fields.dart';
import 'package:blind_date/Model/user_data_model.dart';
import 'package:blind_date/Provider/SettingProvider.dart';
import 'package:blind_date/Provider/UserProvider.dart';
import 'package:blind_date/Screen/NewScreens/complete_profile_screen.dart';
import 'package:blind_date/Screen/SendOtp.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class UpdateCompleteProfile extends StatefulWidget {
  @override
  _UpdateCompleteProfilePageState createState() => _UpdateCompleteProfilePageState();
}

class _UpdateCompleteProfilePageState extends State<UpdateCompleteProfile> with TickerProviderStateMixin {

  bool? _showPassword = false;
  bool visible = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController ccodeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController referController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  String? selectedDate;
  String? adharFront;
  String? adharBack;

  int count = 1;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? name,
      email,
      password,
      mobile,
      username,
      id,
      countrycode,
      city,
      area,
      pincode,
      address,
      latitude,
      image,
      longitude,
      referCode,
      friendCode;

  int? _value3 = 1;
  String gender = 'Male';

  FocusNode? nameFocus,
      emailFocus,
      passFocus = FocusNode(),
      referFocus = FocusNode();
  bool _isNetworkAvail = true;
  Animation? buttonSqueezeanimation;

  AnimationController? buttonController;
  File? aadhaarFront;
  File? aadhaarBack;
  File? profileImage;
  String? imageProfile;

  selectImage(int index) async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      if (index == 1) {
        setState(() {
          aadhaarFront = File(pickedFile.path);
        });
      } else if (index == 2) {
        setState(() {
          aadhaarBack = File(pickedFile.path);
        });
      } else {
        setState(() {
          profileImage = File(pickedFile.path);
        });
      }
    }
  }

  _selectImage(BuildContext context, int index) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Add Table Image'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Click Image from Camera'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  PickedFile? pickedFile = await ImagePicker().getImage(
                    source: ImageSource.camera,
                    maxHeight: 240.0,
                    maxWidth: 240.0,
                  );
                  if (pickedFile != null) {
                    if (index == 1) {
                      setState(() {
                        aadhaarFront = File(pickedFile.path);
                      });
                    } else if(index == 2){
                      setState(() {
                        aadhaarBack = File(pickedFile.path);
                      });
                    }else{
                      setState(() {
                        profileImage = File(pickedFile.path);
                      });
                    }
                  }
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose image from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  selectImage(index);
                  // getFromGallery();
                  // setState(() {
                  //   // _file = file;Start
                  // });
                },
              ),
              // SimpleDialogOption(
              //   padding: const EdgeInsets.all(20),
              //   child: const Text('Choose Video from gallery'),
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //   },
              // ),

              // SimpleDialogOption(
              //   padding: const EdgeInsets.all(20),
              //   child: const Text('Cancel'),
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //   },
              // ),
            ],
          );
        });
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      _playAnimation();
      checkNetwork();
    }
  }

  getUserDetails() async {
    SettingProvider settingsProvider =
    Provider.of<SettingProvider>(context, listen: false);

    mobile = await settingsProvider.getPrefrence(MOBILE);
    countrycode = await settingsProvider.getPrefrence(COUNTRY_CODE);
    if (mounted) setState(() {});
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  Future<void> checkNetwork() async {
    bool avail = await isNetworkAvailable();
    if (avail) {
      if (aadhaarFront != null) {
        registerUser();
      } else {
        setSnackbar("Please select aadhaar image first");
      }
    } else {
      Future.delayed(Duration(seconds: 2)).then((_) async {
        if (mounted)
          setState(() {
            _isNetworkAvail = false;
          });
        await buttonController!.reverse();
      });
    }
  }

  bool validateAndSave() {
    final form = _formkey.currentState!;
    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    buttonController!.dispose();
    super.dispose();
  }

  _fieldFocusChange(
      BuildContext context, FocusNode currentFocus, FocusNode? nextFocus) {
    currentFocus.unfocus();
    FocusScope.of(context).requestFocus(nextFocus);
  }

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: Theme.of(context).colorScheme.fontColor),
      ),
      elevation: 1.0,
      backgroundColor: Theme.of(context).colorScheme.lightWhite,
    ));
  }

  Widget noInternet(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsetsDirectional.only(top: kToolbarHeight),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          noIntImage(),
          noIntText(context),
          noIntDec(context),
          AppBtn(
            title: getTranslated(context, 'TRY_AGAIN_INT_LBL'),
            btnAnim: buttonSqueezeanimation,
            btnCntrl: buttonController,
            onBtnSelected: () async {
              _playAnimation();

              Future.delayed(Duration(seconds: 2)).then((_) async {
                _isNetworkAvail = await isNetworkAvailable();
                if (_isNetworkAvail) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => super.widget));
                } else {
                  await buttonController!.reverse();
                  if (mounted) setState(() {});
                }
              });
            },
          )
        ]),
      ),
    );
  }

  Future<void> getRegisterUser() async {
    try {
      var data = {
        MOBILE: mobileController.text.toString(),
        NAME: nameController.text.toString(),
        EMAIL: emailController.text.toString(),
        'gender': gender.toString(),
        'age': ageController.text.toString(),
        'dob': selectedDate != null ? selectedDate.toString() : '',
        'describe_yourself': aboutController.text.toString()

        // FRNDCODE: friendCode
      };

      Response response = await post(signUpApi, body: data, headers: headers)
          .timeout(Duration(seconds: timeOut));

      var getdata = json.decode(response.body);
      bool error = getdata["error"];
      String? msg = getdata["message"];
      await buttonController!.reverse();
      if (!error) {
        setSnackbar(getTranslated(context, 'REGISTER_SUCCESS_MSG')!);
        var i = getdata["data"][0];

        id = i[ID];
        name = i[USERNAME];
        email = i[EMAIL];
        mobile = i[MOBILE];
        //countrycode=i[COUNTRY_CODE];
        CUR_USERID = id;

        // CUR_USERNAME = name;

        UserProvider userProvider = context.read<UserProvider>();
        userProvider.setName(name ?? "");

        // SettingProvider settingProvider = context.read<SettingProvider>();
        // settingProvider.saveUserDetail(id!, name, email, mobile, city, area,
        //     address, pincode, latitude, longitude, "", context);

        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));

        // Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
      } else {
        setSnackbar(msg!);
      }
      if (mounted) setState(() {});
    } on TimeoutException catch (_) {
      setSnackbar(getTranslated(context, 'somethingMSg')!);
      await buttonController!.reverse();
    }
  }

  registerUser() async {
    // CUR_USERID = await getPrefrence(Id);
    var headers = {
      'Cookie': 'ci_session=aa83f4f9d3335df625437992bb79565d0973f564'
    };
    var request =
    http.MultipartRequest('POST', Uri.parse(updateSignUpApi.toString()));
    request.fields.addAll({
      MOBILE: mobileController.text.toString(),
      NAME: nameController.text.toString(),
      EMAIL: emailController.text.toString(),
      'gender': gender.toString(),
      'age': ageController.text.toString(),
      'dob': selectedDate != null ? selectedDate.toString() : '',
      'describe_yourself': aboutController.text.toString()
    });
    if (aadhaarFront != null) {
      request.files.add(
          await http.MultipartFile.fromPath('aadhar_card', aadhaarFront!.path));
    }
    if (aadhaarBack != null) {
      request.files.add(await http.MultipartFile.fromPath(
          'aadhar_card_back', aadhaarBack!.path));
    }

    print(
        "this is signUp request ====>>>> ${request.fields.toString()} and ${request.files.toString()}");
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String str = await response.stream.bytesToString();
      var result = json.decode(str);
      bool error = result['error'];
      String msg = result['message'];
      print("this is result response $error and $msg");
      if (!error) {
        setSnackbar(msg);
        Navigator.pop(context);

      } else {
        setSnackbar(msg);
      }

    } else {
      print(response.reasonPhrase);
    }
  }

  Date? userData;

  getUserData() async {
    // CUR_USERID = await getPrefrence(Id);
    var headers = {
      'Cookie': 'ci_session=aa83f4f9d3335df625437992bb79565d0973f564'
    };
    var request =
    http.MultipartRequest('POST', Uri.parse(getUserDetailsApi.toString()));
    request.fields.addAll({
      'user_id': CUR_USERID.toString()
    });

    http.StreamedResponse response = await request.send();
    request.headers.addAll(headers);

    print("this is user profile request ====>>>> ${request.fields.toString()}");

    if (response.statusCode == 200) {
      String str = await response.stream.bytesToString();
      var result = json.decode(str);
      final fResponse = UserDataModel.fromJson(result);

      bool error = result['error'];

      if (!error) {
        userData = fResponse.date![0];
        print("this is user Data ${userData!.username}");
        if(userData != null) {
          if(userData!.username != null) {
            nameController =
                TextEditingController(text: userData!.username.toString());
          }
          if(userData!.age != null) {
            ageController =
                TextEditingController(text: userData!.age.toString());
          }
          if(userData!.mobile != null) {
            mobileController =
                TextEditingController(text: userData!.username.toString());
          }
          if(userData!.email != null) {
            emailController =
                TextEditingController(text: userData!.email.toString());
          }
          if(userData!.describeYourself != null) {
            aboutController =
                TextEditingController(text: userData!.describeYourself.toString());
          }
          if(userData!.dob != null) {
            selectedDate = userData!.dob;
          }
          if(userData!.aadharFront != null) {
            adharFront = userData!.aadharFront;
          }
          if(userData!.aadharBack != null) {
            adharBack = userData!.aadharBack;
          }
          if(userData!.image != null) {
            imageProfile = userData!.image;
          }
          if (userData!.gender.toString() == "male" || userData!.gender.toString() == "Male") {
            setState(() {
              _value3 = 1;
            });
          } else {
            setState(() {
              _value3 = 2;
            });
          }
        }

      } else {
        // setSnackbar(msg);
      }

    } else {
      print(response.reasonPhrase);
    }
  }

  Widget registerTxt() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Align(
        alignment: Alignment.center,
        child: Text(getTranslated(context, 'UPDATE_PROFILE_LBL')!,
            style: Theme.of(context).textTheme.subtitle1!.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 25)),
      ),
    );
  }

  setUserName() {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: 15.0,
        end: 15.0,
      ),
      child: TextFormField(
        keyboardType: TextInputType.text,
        textCapitalization: TextCapitalization.words,
        controller: nameController,
        focusNode: nameFocus,
        textInputAction: TextInputAction.next,
        style: TextStyle(
            color: Theme.of(context).colorScheme.fontColor,
            fontWeight: FontWeight.normal),
        validator: (val) => validateUserName(
            val!,
            getTranslated(context, 'USER_REQUIRED'),
            getTranslated(context, 'USER_LENGTH')),
        onSaved: (String? value) {
          name = value;
        },
        onFieldSubmitted: (v) {
          _fieldFocusChange(context, nameFocus!, emailFocus);
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colors.primary),
            borderRadius: BorderRadius.circular(7.0),
          ),
          prefixIcon: Icon(
            Icons.account_circle_outlined,
            color: Theme.of(context).colorScheme.fontColor,
            size: 17,
          ),
          hintText: getTranslated(context, 'NAMEHINT_LBL'),
          hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
              color: Theme.of(context).colorScheme.fontColor,
              fontWeight: FontWeight.normal),
          // filled: true,
          // fillColor: Theme.of(context).colorScheme.lightWhite,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          prefixIconConstraints: BoxConstraints(minWidth: 40, maxHeight: 25),
          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Theme.of(context).colorScheme.fontColor),
          //   borderRadius: BorderRadius.circular(10.0),
          // ),
          enabledBorder: UnderlineInputBorder(
            borderSide:
            BorderSide(color: Theme.of(context).colorScheme.fontColor),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  setEmail() {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        top: 10.0,
        start: 15.0,
        end: 15.0,
      ),
      child: TextFormField(
        keyboardType: TextInputType.emailAddress,
        focusNode: emailFocus,
        textInputAction: TextInputAction.next,
        controller: emailController,
        style: TextStyle(
            color: Theme.of(context).colorScheme.fontColor,
            fontWeight: FontWeight.normal),
        validator: (val) => validateEmail(
            val!,
            getTranslated(context, 'EMAIL_REQUIRED'),
            getTranslated(context, 'VALID_EMAIL')),
        onSaved: (String? value) {
          email = value;
        },
        onFieldSubmitted: (v) {
          _fieldFocusChange(context, emailFocus!, passFocus);
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colors.primary),
            borderRadius: BorderRadius.circular(7.0),
          ),
          prefixIcon: Icon(
            Icons.alternate_email_outlined,
            color: Theme.of(context).colorScheme.fontColor,
            size: 17,
          ),
          hintText: getTranslated(context, 'EMAILHINT_LBL'),
          hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
              color: Theme.of(context).colorScheme.fontColor,
              fontWeight: FontWeight.normal),
          // filled: true,
          // fillColor: Theme.of(context).colorScheme.lightWhite,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          prefixIconConstraints: BoxConstraints(minWidth: 40, maxHeight: 25),
          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Theme.of(context).colorScheme.fontColor),
          //   borderRadius: BorderRadius.circular(10.0),
          // ),
          enabledBorder: UnderlineInputBorder(
            borderSide:
            BorderSide(color: Theme.of(context).colorScheme.fontColor),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget setMono() {
    return Padding(
        padding: EdgeInsetsDirectional.only(
          top: 10.0,
          start: 15.0,
          end: 15.0,
        ),
        child: TextFormField(
            keyboardType: TextInputType.number,
            maxLength: 10,
            controller: mobileController,
            style: Theme.of(context).textTheme.subtitle2!.copyWith(
                color: Theme.of(context).colorScheme.fontColor,
                fontWeight: FontWeight.normal),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (val) => validateMob(
                val!,
                getTranslated(context, 'MOB_REQUIRED'),
                getTranslated(context, 'VALID_MOB')),
            onSaved: (String? value) {
              mobile = value;
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              prefixIconConstraints:
              BoxConstraints(minWidth: 40, maxHeight: 25),
              counterText: "",
              hintText: getTranslated(context, 'MOBILEHINT_LBL'),
              prefixIcon: Icon(
                Icons.call,
                color: Theme.of(context).colorScheme.fontColor,
                size: 17,
              ),
              hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
                  color: Theme.of(context).colorScheme.fontColor,
                  fontWeight: FontWeight.normal),
              // contentPadding:
              // const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              // focusedBorder: OutlineInputBorder(
              //   borderSide: BorderSide(color: Theme.of(context).colorScheme.lightWhite),
              // ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: colors.primary),
                borderRadius: BorderRadius.circular(7.0),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide:
                BorderSide(color: Theme.of(context).colorScheme.lightWhite),
              ),
            )));
  }

  setRefer() {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        top: 10.0,
        start: 15.0,
        end: 15.0,
      ),
      child: TextFormField(
        keyboardType: TextInputType.text,
        focusNode: referFocus,
        controller: referController,
        style: TextStyle(
            color: Theme.of(context).colorScheme.fontColor,
            fontWeight: FontWeight.normal),
        onSaved: (String? value) {
          friendCode = value;
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: colors.primary),
            borderRadius: BorderRadius.circular(7.0),
          ),
          prefixIcon: Icon(
            Icons.card_giftcard_outlined,
            color: Theme.of(context).colorScheme.fontColor,
            size: 17,
          ),
          hintText: getTranslated(context, 'REFER'),
          hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
              color: Theme.of(context).colorScheme.fontColor,
              fontWeight: FontWeight.normal),
          // filled: true,
          // fillColor: Theme.of(context).colorScheme.lightWhite,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          prefixIconConstraints: BoxConstraints(minWidth: 40, maxHeight: 25),
          // focusedBorder: OutlineInputBorder(
          //   borderSide: BorderSide(color: Theme.of(context).colorScheme.fontColor),
          //   borderRadius: BorderRadius.circular(10.0),
          // ),
          enabledBorder: UnderlineInputBorder(
            borderSide:
            BorderSide(color: Theme.of(context).colorScheme.fontColor),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  setPass() {
    return Padding(
        padding: EdgeInsetsDirectional.only(start: 15.0, end: 15.0, top: 10.0),
        child: TextFormField(
          keyboardType: TextInputType.text,
          obscureText: !_showPassword!,
          focusNode: passFocus,
          onFieldSubmitted: (v) {
            _fieldFocusChange(context, passFocus!, referFocus);
          },
          textInputAction: TextInputAction.next,
          style: TextStyle(
              color: Theme.of(context).colorScheme.fontColor,
              fontWeight: FontWeight.normal),
          controller: passwordController,
          validator: (val) => validatePass(
              val!,
              getTranslated(context, 'PWD_REQUIRED'),
              getTranslated(context, 'PWD_LENGTH')),
          onSaved: (String? value) {
            password = value;
          },
          decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: colors.primary),
              borderRadius: BorderRadius.circular(7.0),
            ),
            prefixIcon: SvgPicture.asset(
              "assets/images/password.svg",
              height: 17,
              width: 17,
              color: Theme.of(context).colorScheme.fontColor,
            ),
            // Icon(
            //   Icons.lock_outline,
            //   color: Theme.of(context).colorScheme.lightBlack2,
            //   size: 17,
            // ),
            hintText: getTranslated(context, 'PASSHINT_LBL'),
            hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
                color: Theme.of(context).colorScheme.fontColor,
                fontWeight: FontWeight.normal),
            // filled: true,
            // fillColor: Theme.of(context).colorScheme.lightWhite,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            prefixIconConstraints: BoxConstraints(minWidth: 40, maxHeight: 25),
            // focusedBorder: OutlineInputBorder(
            //   borderSide: BorderSide(color: Theme.of(context).colorScheme.fontColor),
            //   borderRadius: BorderRadius.circular(10.0),
            // ),
            enabledBorder: UnderlineInputBorder(
              borderSide:
              BorderSide(color: Theme.of(context).colorScheme.fontColor),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ));
  }

  showPass() {
    return Padding(
        padding: EdgeInsetsDirectional.only(
          start: 30.0,
          end: 30.0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Checkbox(
              value: _showPassword,
              checkColor: Theme.of(context).colorScheme.fontColor,
              activeColor: Theme.of(context).colorScheme.lightWhite,
              onChanged: (bool? value) {
                if (mounted)
                  setState(() {
                    _showPassword = value;
                  });
              },
            ),
            Text(getTranslated(context, 'SHOW_PASSWORD')!,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.fontColor,
                    fontWeight: FontWeight.normal))
          ],
        ));
  }

  verifyBtn() {
    return AppBtn(
      title: getTranslated(context, 'UPDATE_PROFILE_LBL'),
      btnAnim: buttonSqueezeanimation,
      btnCntrl: buttonController,
      onBtnSelected: () async {
        validateAndSubmit();
      },
    );
  }

  loginTxt() {
    return Padding(
      padding: EdgeInsetsDirectional.only(start: 25.0, end: 25.0, bottom: 60),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(getTranslated(context, 'ALREADY_A_CUSTOMER')!,
              style: Theme.of(context).textTheme.caption!.copyWith(
                  color: Theme.of(context).colorScheme.fontColor,
                  fontWeight: FontWeight.normal)),
          InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Login(),
                ));
              },
              child: Text(
                getTranslated(context, 'LOG_IN_LBL')!,
                style: Theme.of(context).textTheme.caption!.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.underline,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }

  backBtn() {
    return Platform.isIOS
        ? Container(
        padding: EdgeInsetsDirectional.only(top: 20.0, start: 10.0),
        alignment: AlignmentDirectional.topStart,
        child: Card(
          elevation: 0,
          child: Padding(
            padding: const EdgeInsetsDirectional.only(end: 4.0),
            child: InkWell(
              child: Icon(Icons.keyboard_arrow_left, color: colors.primary),
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
        ))
        : Container();
  }

  // expandedBottomView() {
  //   return Expanded(
  //       flex: 8,
  //       child: Container(
  //         alignment: Alignment.bottomCenter,
  //         child: ScrollConfiguration(
  //           behavior: MyBehavior(),
  //           child: SingleChildScrollView(
  //               child: Form(
  //             key: _formkey,
  //             child: Card(
  //               elevation: 0.5,
  //               shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(10)),
  //               margin: const EdgeInsetsDirectional.only(
  //                   start: 20.0, end: 20.0, top: 20.0),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: <Widget>[
  //                   registerTxt(),
  //                   setUserName(),
  //                   setEmail(),
  //                   setPass(),
  //                   setRefer(),
  //                   showPass(),
  //                   verifyBtn(),
  //                   loginTxt(),
  //                 ],
  //               ),
  //             ),
  //           )),
  //         ),
  //       ));
  // }

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    super.initState();
    getUserDetails();
    getUserData();
    buttonController = AnimationController(
        duration: Duration(milliseconds: 2000), vsync: this);

    buttonSqueezeanimation = Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(CurvedAnimation(
      parent: buttonController!,
      curve: Interval(
        0.0,
        0.150,
      ),
    ));

    generateReferral();
  }

  _subLogo() {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 30.0),
      child: Image.asset(
        'assets/images/splashlogo.png',
        width: 100,
        height: 100,
      ),
    );
  }

  fieldsWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 10, bottom: 5),
            child: Text(
              "Name",
              style:
              TextStyle(color: colors.primary, fontWeight: FontWeight.w600),
            ),
          ),
          CustomFields(
            controller: nameController,
            title: "Full Name",
            keyboard: TextInputType.name,
            validate: (val) => validateUserName(
                val!,
                getTranslated(context, 'USER_REQUIRED'),
                getTranslated(context, 'USER_LENGTH')),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 10, bottom: 5),
            child: Text(
              "Email",
              style:
              TextStyle(color: colors.primary, fontWeight: FontWeight.w600),
            ),
          ),
          CustomFields(
            controller: emailController,
            title: "Email",
            keyboard: TextInputType.emailAddress,
            validate: (val) => validateEmail(
                val!,
                getTranslated(context, 'EMAIL_REQUIRED'),
                getTranslated(context, 'VALID_EMAIL')),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 10, bottom: 5),
            child: Text(
              "Mobile Number",
              style:
              TextStyle(color: colors.primary, fontWeight: FontWeight.w600),
            ),
          ),
          CustomFields(
            controller: mobileController,
            title: "Mobile Number",
            keyboard: TextInputType.number,
            mxLength: 10,
            validate: (val) => validateMob(
                val!,
                getTranslated(context, 'MOB_REQUIRED'),
                getTranslated(context, 'VALID_MOB')),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 10, bottom: 5),
            child: Text(
              "Gender",
              style:
              TextStyle(color: colors.primary, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                        value: 1,
                        fillColor: MaterialStateColor.resolveWith(
                                (states) => colors.primary),
                        groupValue: _value3,
                        onChanged: (int? value) {
                          setState(() {
                            _value3 = value!;
                            gender = 'Male';
                            // isUpi = false;
                          });
                        }),
                    Text(
                      "Male",
                      style: TextStyle(color: colors.primary),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                        value: 2,
                        fillColor: MaterialStateColor.resolveWith(
                                (states) => colors.primary),
                        groupValue: _value3,
                        onChanged: (int? value) {
                          setState(() {
                            _value3 = value!;
                            gender = 'Female';
                          });
                        }),
                    Text(
                      "Female",
                      style: TextStyle(color: colors.primary),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Radio(
                        value: 3,
                        fillColor: MaterialStateColor.resolveWith(
                                (states) => colors.primary),
                        groupValue: _value3,
                        onChanged: (int? value) {
                          setState(() {
                            _value3 = value!;
                            gender = 'Other';
                          });
                        }),
                    Text(
                      "Other",
                      style: TextStyle(color: colors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 25.0, top: 10, bottom: 5),
                    child: Text(
                      "Age",
                      style: TextStyle(
                          color: colors.primary, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15, top: 8, bottom: 4),
                    // height: 50,
                    width: MediaQuery.of(context).size.width / 2 - 20,
                    // decoration: BoxDecoration(
                    //     color: Theme.of(context).colorScheme.lightWhite,
                    //     borderRadius: BorderRadius.circular(50),
                    //     border: Border.all(color: colors.primary)
                    // ),
                    // width: width != 0 ? width : MediaQuery.of(context).size.width,
                    child: TextFormField(
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.fontColor),
                      keyboardType: TextInputType.number,
                      // maxLength: mxLength,
                      controller: ageController,
                      validator: (val) =>
                          validateField(val!, "Please enter age"),
                      decoration: InputDecoration(
                          focusColor: colors.primary,
                          counterText: '',
                          // border: InputBorder.none,
                          border: OutlineInputBorder(
                              borderSide:
                              BorderSide(color: colors.primary, width: 1),
                              borderRadius: BorderRadius.circular(60)),
                          hintText: "Age",
                          hintStyle: TextStyle(fontWeight: FontWeight.w400)),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 25.0, top: 10, bottom: 5),
                    child: Text(
                      "DOB",
                      style: TextStyle(
                          color: colors.primary, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 4),
                      child: InkWell(
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2100),
                              builder: (context, child) {
                                return Theme(
                                    data: Theme.of(context).copyWith(
                                        colorScheme: ColorScheme.light(
                                          primary: colors.primary,
                                        )),
                                    child: child!);
                              });

                          if (pickedDate != null) {
                            //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                            //formatted date output using intl package =>  2021-03-16
                            setState(() {
                              selectedDate =
                                  formattedDate; //set output date to TextField value.
                            });
                          }
                        },
                        child: Material(
                          child: Container(
                            padding: EdgeInsets.all(8),
                            height: 60,
                            width: MediaQuery.of(context).size.width / 2 - 20,
                            decoration: BoxDecoration(
                              // color: Colors.white,
                                borderRadius: BorderRadius.circular(60),
                                border: Border.all(color: Colors.grey)),
                            child: selectedDate == null || selectedDate == ''
                                ? Center(
                                child: Text(
                                  "Select DOB",
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .fontColor),
                                ))
                                : Center(
                                child: Text(
                                  "${selectedDate.toString()}",
                                )),
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 10, bottom: 5),
            child: Text(
              "Describe Yourself",
              style:
              TextStyle(color: colors.primary, fontWeight: FontWeight.w600),
            ),
          ),
          CustomFields(
            controller: aboutController,
            title: "Describe Yourself",
            keyboard: TextInputType.name,
            validate: (val) => validateField(
              val!,
              "Filed is required",
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, 100),
          child: AppBar(
            centerTitle: true,
            leading: IconButton(icon: Icon(Icons.arrow_back_ios), color: colors.whiteTemp,
              onPressed: (){
              Navigator.pop(context);
              },),
            title: Image.asset('assets/images/homelogo.png', height: 60,),
            backgroundColor: colors.primary,
            iconTheme: IconThemeData(color: colors.whiteTemp),
            // actions: [
            //   InkWell(
            //     onTap: (){
            //      // Navigator.push(context, MaterialPageRoute(builder: (context)=> WalletHistory()));
            //     },
            //     child: Padding(
            //       padding: const EdgeInsets.only(right: 25.0, top: 4),
            //       child: Column(
            //         children: [
            //           Icon(Icons.wallet, color: colors.whiteTemp, size: 34,),
            //           Text("Wallet", style: TextStyle(
            //               color: colors.whiteTemp,
            //               fontWeight: FontWeight.w600
            //           ),)
            //         ],
            //       ),
            //     ),
            //   )],
          ),
        ),
        resizeToAvoidBottomInset: true,
        key: _scaffoldKey,
        body: _isNetworkAvail
            ? Form(
          key: _formkey,
          child: ScrollConfiguration(
            behavior: MyBehavior(),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 2.5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 15,),
                    // _subLogo(),
                    registerTxt(),
                    const SizedBox(height: 10,),
                    InkWell(
                      onTap: () {
                        _selectImage(context, 3);
                      },
                      child: Container(
                          child: imageProfile == null || imageProfile.toString() == ''?
                          profileImage == null
                              ? Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: colors.primary),
                              shape: BoxShape.circle,
                              // borderRadius:
                              // BorderRadius.circular(15),
                              // image: DecorationImage(
                              //     image: FileImage(File(aadhaarImage!.path)),
                              //     fit: BoxFit.fill
                              //   //AssetImage(Image.file(file)File(tableImage!.path)),
                              // )
                            ),
                            width: MediaQuery.of(context)
                                .size
                                .width /
                                2 -
                                20,
                            height: MediaQuery.of(context)
                                .size
                                .width /
                                2 -
                                20,
                            child: Center(
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.upload_file_outlined,
                                    size: 32,
                                  ),
                                  Text('Profile Image')
                                ],
                              ),
                            ),
                          )
                              : Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: colors.primary),
                                shape: BoxShape.circle,
                                // borderRadius:
                                // BorderRadius.circular(15),
                                image: DecorationImage(
                                    image: FileImage(File(
                                        profileImage!.path)),
                                    fit: BoxFit.fill
                                  //AssetImage(Image.file(file)File(tableImage!.path)),
                                )),
                            width: MediaQuery.of(context)
                                .size
                                .width /
                                2 -
                                20,
                            height: MediaQuery.of(context)
                                .size
                                .width /
                                2 -
                                20,
                          )
                              : Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: colors.primary),
                                shape: BoxShape.circle,
                                // borderRadius:
                                // BorderRadius.circular(15),
                                image: DecorationImage(
                                    image: NetworkImage(adharBack.toString()),
                                    fit: BoxFit.fill
                                  //AssetImage(Image.file(file)File(tableImage!.path)),
                                )),
                            width: MediaQuery.of(context)
                                .size
                                .width /
                                2 -
                                20,
                            height: MediaQuery.of(context)
                                .size
                                .width /
                                2 -
                                20,
                          )

                      ),
                    ),
                    fieldsWidget(),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 15, left: 15.0, right: 15, bottom: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              _selectImage(context, 1);
                            },
                            child: Container(
                                child: Column(
                                  children: [
                                    adharFront == null || adharFront.toString() == ''?
                                    aadhaarFront == null
                                        ? Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey),
                                        borderRadius:
                                        BorderRadius.circular(15),
                                        // image: DecorationImage(
                                        //     image: FileImage(File(aadhaarImage!.path)),
                                        //     fit: BoxFit.fill
                                        //   //AssetImage(Image.file(file)File(tableImage!.path)),
                                        // )
                                      ),
                                      width: MediaQuery.of(context)
                                          .size
                                          .width /
                                          2 -
                                          20,
                                      height: MediaQuery.of(context)
                                          .size
                                          .width /
                                          2 -
                                          20,
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.upload_file_outlined,
                                            size: 32,
                                          ),
                                          Text('Aadhaar Front')
                                        ],
                                      ),
                                    )
                                        : Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: colors.primary),
                                          borderRadius:
                                          BorderRadius.circular(15),
                                          image: DecorationImage(
                                              image: FileImage(File(
                                                  aadhaarFront!.path)),
                                              fit: BoxFit.fill
                                            //AssetImage(Image.file(file)File(tableImage!.path)),
                                          )),
                                      width: MediaQuery.of(context)
                                          .size
                                          .width /
                                          2 -
                                          20,
                                      height: MediaQuery.of(context)
                                          .size
                                          .width /
                                          2 -
                                          20,
                                    )
                                 :   Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: colors.primary),
                                          borderRadius:
                                          BorderRadius.circular(15),
                                          image: DecorationImage(
                                              image: NetworkImage(adharBack.toString()),
                                              fit: BoxFit.fill
                                            //AssetImage(Image.file(file)File(tableImage!.path)),
                                          )),
                                      width: MediaQuery.of(context)
                                          .size
                                          .width /
                                          2 -
                                          20,
                                      height: MediaQuery.of(context)
                                          .size
                                          .width /
                                          2 -
                                          20,
                                    )

                                  ],
                                )),
                          ),
                          InkWell(
                            onTap: () {
                              _selectImage(context, 2);
                            },
                            child: Container(
                              child: adharBack == null || adharBack.toString() == ''?
                              aadhaarBack == null
                                  ? Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey),
                                  borderRadius:
                                  BorderRadius.circular(15),
                                  // image: DecorationImage(
                                  //     image: FileImage(File(aadhaarImage!.path)),
                                  //     fit: BoxFit.fill
                                  //   //AssetImage(Image.file(file)File(tableImage!.path)),
                                  // )
                                ),
                                width: MediaQuery.of(context)
                                    .size
                                    .width /
                                    2 -
                                    20,
                                height: MediaQuery.of(context)
                                    .size
                                    .width /
                                    2 -
                                    20,
                                child: Center(
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.upload_file_outlined,
                                        size: 32,
                                      ),
                                      Text('Aadhaar Back')
                                    ],
                                  ),
                                ),
                              )
                                  : Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: colors.primary),
                                    borderRadius:
                                    BorderRadius.circular(15),
                                    image: DecorationImage(
                                        image: FileImage(File(
                                            aadhaarBack!.path)),
                                        fit: BoxFit.fill
                                      //AssetImage(Image.file(file)File(tableImage!.path)),
                                    )),
                                width: MediaQuery.of(context)
                                    .size
                                    .width /
                                    2 -
                                    20,
                                height: MediaQuery.of(context)
                                    .size
                                    .width /
                                    2 -
                                    20,
                              )
                              : Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: colors.primary),
                                    borderRadius:
                                    BorderRadius.circular(15),
                                    image: DecorationImage(
                                        image: NetworkImage(adharBack.toString()),
                                        fit: BoxFit.fill
                                      //AssetImage(Image.file(file)File(tableImage!.path)),
                                    )),
                                width: MediaQuery.of(context)
                                    .size
                                    .width /
                                    2 -
                                    20,
                                height: MediaQuery.of(context)
                                    .size
                                    .width /
                                    2 -
                                    20,
                              )

                            ),
                          )
                        ],
                      ),
                    ),

                    verifyBtn(),
                    // loginTxt(),
                  ],
                ),
              ),
            ),
          ),
        )
        // Stack(
        //         children: [
        //           backBtn(),
        //           Container(
        //             width: double.infinity,
        //             height: double.infinity,
        //             decoration: back(),
        //           ),
        //           Image.asset(
        //             'assets/images/doodle.png',
        //             fit: BoxFit.fill,
        //             width: double.infinity,
        //             height: double.infinity,
        //           ),
        //           //getBgImage(),
        //           getLoginContainer(),
        //           getLogo(),
        //         ],
        //       )
            : noInternet(context));
  }

  Future<void> generateReferral() async {
    String refer = getRandomString(8);

    try {
      var data = {
        REFERCODE: refer,
      };

      Response response =
      await post(validateReferalApi, body: data, headers: headers)
          .timeout(Duration(seconds: timeOut));

      var getdata = json.decode(response.body);

      bool error = getdata["error"];

      if (!error) {
        referCode = refer;
        REFER_CODE = refer;
        if (mounted) setState(() {});
      } else {
        if (count < 5) generateReferral();
        count++;
      }
    } on TimeoutException catch (_) {}
  }

  final _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  getLoginContainer() {
    return Positioned.directional(
      start: MediaQuery.of(context).size.width * 0.025,
      // end: width * 0.025,
      // top: width * 0.45,
      top: MediaQuery.of(context).size.height * 0.2, //original
      //    bottom: height * 0.1,
      textDirection: Directionality.of(context),
      child: ClipPath(
        clipper: ContainerClipper(),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom * 0.8),
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.95,
          color: Theme.of(context).colorScheme.white,
          child: Form(
            key: _formkey,
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 2.5,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.10,
                      ),
                      registerTxt(),
                      // setUserName(),
                      CustomFields(
                        controller: nameController,
                        title: "Full Name",
                        keyboard: TextInputType.name,
                        validate: (val) => validateUserName(
                            val!,
                            getTranslated(context, 'USER_REQUIRED'),
                            getTranslated(context, 'USER_LENGTH')),
                      ),
                      CustomFields(
                        controller: emailController,
                        title: "Email",
                        keyboard: TextInputType.emailAddress,
                        validate: (val) => validateEmail(
                            val!,
                            getTranslated(context, 'EMAIL_REQUIRED'),
                            getTranslated(context, 'VALID_EMAIL')),
                      ),
                      CustomFields(
                        controller: mobileController,
                        title: "Mobile Number",
                        keyboard: TextInputType.name,
                        validate: (val) => validateMob(
                            val!,
                            getTranslated(context, 'MOB_REQUIRED'),
                            getTranslated(context, 'VALID_MOB')),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding:
                            EdgeInsets.only(left: 15, top: 8, bottom: 4),
                            height: 50,
                            width: MediaQuery.of(context).size.width / 2 - 20,
                            // decoration: BoxDecoration(
                            //     color: Theme.of(context).colorScheme.lightWhite,
                            //     borderRadius: BorderRadius.circular(50),
                            //     border: Border.all(color: colors.primary)
                            // ),
                            // width: width != 0 ? width : MediaQuery.of(context).size.width,
                            child: TextFormField(
                              style: TextStyle(
                                  color:
                                  Theme.of(context).colorScheme.fontColor),
                              keyboardType: TextInputType.number,
                              // maxLength: mxLength,
                              controller: ageController,
                              validator: (val) => validateMob(
                                  val!,
                                  getTranslated(context, 'MOB_REQUIRED'),
                                  getTranslated(context, 'VALID_MOB')),
                              decoration: InputDecoration(
                                  focusColor: colors.primary,
                                  counterText: '',
                                  // border: InputBorder.none,
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: colors.primary, width: 1),
                                      borderRadius: BorderRadius.circular(60)),
                                  hintText: "Age",
                                  hintStyle:
                                  TextStyle(fontWeight: FontWeight.w400)),
                            ),
                          ),
                          Container(
                            padding:
                            EdgeInsets.only(left: 15, top: 8, bottom: 4),
                            height: 50,
                            width: MediaQuery.of(context).size.width / 2 - 20,
                            // decoration: BoxDecoration(
                            //     color: Theme.of(context).colorScheme.lightWhite,
                            //     borderRadius: BorderRadius.circular(50),
                            //     border: Border.all(color: colors.primary)
                            // ),
                            // width: width != 0 ? width : MediaQuery.of(context).size.width,
                            child: TextFormField(
                              style: TextStyle(
                                  color:
                                  Theme.of(context).colorScheme.fontColor),
                              keyboardType: TextInputType.number,
                              // maxLength: mxLength,
                              controller: ageController,
                              validator: (val) => validateMob(
                                  val!,
                                  getTranslated(context, 'MOB_REQUIRED'),
                                  getTranslated(context, 'VALID_MOB')),
                              decoration: InputDecoration(
                                  focusColor: colors.primary,
                                  counterText: '',
                                  // border: InputBorder.none,
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: colors.primary, width: 1),
                                      borderRadius: BorderRadius.circular(60)),
                                  hintText: "Age",
                                  hintStyle:
                                  TextStyle(fontWeight: FontWeight.w400)),
                            ),
                          ),
                        ],
                      ),
                      CustomFields(
                        controller: nameController,
                        title: "Describe Yourself",
                        keyboard: TextInputType.name,
                        validate: (val) => validateField(
                          val!,
                          "Filed is required",
                        ),
                      ),
                      // setEmail(),
                      // setMono(),
                      // setPass(),
                      // setRefer(),
                      //showPass(),
                      verifyBtn(),
                      loginTxt(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getLogo() {
    return Positioned(
      // textDirection: Directionality.of(context),
      left: (MediaQuery.of(context).size.width / 2) - 50,
      // right: ((MediaQuery.of(context).size.width /2)-55),

      top: (MediaQuery.of(context).size.height * 0.2) - 50,
      //  bottom: height * 0.1,
      child: SizedBox(
        width: 100,
        height: 100,
        child: Image.asset(
          'assets/images/loginlogo.png',
        ),
      ),
    );
  }
}
