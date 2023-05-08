import 'dart:async';
import 'dart:convert';
import 'package:blind_date/Helper/Constant.dart';
import 'package:blind_date/Helper/Stripe_Service.dart';
import 'package:blind_date/Helper/user_custom_radio.dart';
import 'package:blind_date/Model/restaurant_model.dart';
import 'package:blind_date/Provider/SettingProvider.dart';
import 'package:blind_date/Screen/NewScreens/table_details.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:http/http.dart' as http;
import 'package:blind_date/Helper/AppBtn.dart';
import 'package:blind_date/Helper/Color.dart';
import 'package:blind_date/Helper/Session.dart';
import 'package:blind_date/Helper/String.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/Transaction_Model.dart';

class RestaurantDetails extends StatefulWidget {
  final Restaurants? data;
  final String? id;
  const RestaurantDetails({Key? key, this.data, this.id}) : super(key: key);

  @override
  State<RestaurantDetails> createState() => _RestaurantDetailsState();
}

bool _isLoading = true;

class _RestaurantDetailsState extends State<RestaurantDetails> with TickerProviderStateMixin {
  List<Tables> tablesList = [];

  bool _isNetworkAvail = true;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  TextEditingController messageController = TextEditingController();
  List<String?> paymentMethodList = [];
  List<String> paymentIconList = [
    'assets/images/paypal.svg',
    'assets/images/rozerpay.svg',
    'assets/images/paystack.svg',
    'assets/images/flutterwave.svg',
    'assets/images/stripe.svg',
    'assets/images/paytm.svg',
  ];
  List<RadioModel> payModel = [];
  bool? paypal, razorpay, paumoney, paystack, flutterwave, stripe, paytm;
  String? razorpayId,
      paystackId,
      stripeId,
      stripeSecret,
      stripeMode = "test",
      stripeCurCode,
      stripePayId,
      paytmMerId,
      paytmMerKey;

  int? selectedMethod;
  String? payMethod;
  StateSetter? dialogState;
  bool _isProgress = false;
  late Razorpay _razorpay;
  List<TransactionModel> tranList = [];
  int offset = 0;
  int total = 0;
  int tableIndex = 0;
  bool isLoadingmore = true, _isLoading = true, payTesting = true;
  final paystackPlugin = PaystackPlugin();

  getRestaurantTable() async {
    var headers = {
      'Cookie': 'ci_session=aa83f4f9d3335df625437992bb79565d0973f564'
    };
    var request =
    http.MultipartRequest('POST', Uri.parse(getRestroListApi.toString()));
    request.fields.addAll({
      'user_type': gender.toString(),
      'id': widget.id.toString()
    });

    print("this is restaurant table request ${request.fields.toString()}");
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String str = await response.stream.bytesToString();
      var result = json.decode(str);
      var finalResponse = RestaurantModel.fromJson(result);
      setState(() {
        tablesList = finalResponse.data![0].tables!;
        _isLoading = false;
      });
      print("this is referral data ${tablesList.length}");
    } else {
      print(response.reasonPhrase);
    }
  }

  void openRequestTrainingBottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0))),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return

                Wrap(
                  alignment: WrapAlignment.center,
                  children: [

                    Padding(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          "Book Now", style: TextStyle(color: Theme
                            .of(context)
                            .colorScheme
                            .fontColor,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),)),
                    // catList.isNotEmpty ?
                    // Padding(
                    //     padding: const EdgeInsets.all(20),
                    //     child: Container(
                    //       padding: EdgeInsets.all(8),
                    //       height: 50,
                    //       width: MediaQuery
                    //           .of(context)
                    //           .size
                    //           .width,
                    //       decoration: BoxDecoration(
                    //           color: Theme
                    //               .of(context)
                    //               .colorScheme
                    //               .white,
                    //           borderRadius: BorderRadius.circular(12),
                    //           border: Border.all(color: Theme
                    //               .of(context)
                    //               .colorScheme
                    //               .fontColor)
                    //       ),
                    //       child: DropdownButtonHideUnderline(
                    //         child: DropdownButton(
                    //           hint: Text('Select Product type'),
                    //           // Not necessary for Option 1
                    //           value: categoryValue,
                    //           onChanged: (String? newValue) {
                    //             setState(() {
                    //               categoryValue = newValue;
                    //             });
                    //             print("this is category value $categoryValue");
                    //           },
                    //           items: catList.map((item) {
                    //             return DropdownMenuItem(
                    //               child: Text(
                    //                 item.name!, style: TextStyle(color: Theme
                    //                   .of(context)
                    //                   .colorScheme
                    //                   .fontColor),),
                    //               value: item.id,
                    //             );
                    //           }).toList(),
                    //         ),
                    //       ),
                    //     )
                    // )
                    //     : SizedBox.shrink(),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Container(
                        padding:
                        EdgeInsets.only(bottom: MediaQuery
                            .of(context)
                            .viewInsets
                            .bottom),
                        decoration: BoxDecoration(
                          color: Theme
                              .of(context)
                              .colorScheme
                              .white,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Padding(
                          padding:
                          const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 5.0),
                          child: TextFormField(
                            //initialValue: nameController.text,
                            style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .colorScheme
                                    .fontColor,
                                fontWeight: FontWeight.bold),
                            controller: messageController,
                            decoration: InputDecoration(
                                label: Text(
                                  "Message",
                                  style: TextStyle(
                                    color: Theme
                                        .of(context)
                                        .colorScheme
                                        .primary,
                                  ),
                                ),
                                fillColor: Theme
                                    .of(context)
                                    .colorScheme
                                    .primary,
                                border: InputBorder.none),
                            // validator: (val) => validateUserName(
                            //     val!,
                            //     getTranslated(context, 'USER_REQUIRED'),
                            //     getTranslated(context, 'USER_LENGTH')),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0, top: 10),
                      child: ElevatedButton(onPressed: () {
                        razorpayPayment(1000);
                      },
                          style: ElevatedButton.styleFrom(primary: colors.primary,
                              fixedSize: Size(MediaQuery
                                  .of(context)
                                  .size
                                  .width - 60, 40),
                              shape: StadiumBorder()),
                          child: Text("Book Now", style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 16
                              , color: colors.whiteTemp),)),
                    )
                    // Padding(
                    //   padding: EdgeInsets.only(
                    //       bottom: MediaQuery.of(context).viewInsets.bottom),
                    //   child: Form(
                    //     key: _changeUserDetailsKey,
                    //     child: Column(
                    //       mainAxisSize: MainAxisSize.max,
                    //       children: [
                    //         bottomSheetHandle(),
                    //         bottomsheetLabel("EDIT_PROFILE_LBL"),
                    //         Selector<UserProvider, String>(
                    //             selector: (_, provider) => provider.profilePic,
                    //             builder: (context, profileImage, child) {
                    //               return Padding(
                    //                 padding: const EdgeInsets.symmetric(vertical: 10.0),
                    //                 child: getUserImage(profileImage, _imgFromGallery),
                    //               );
                    //             }),
                    //         Selector<UserProvider, String>(
                    //             selector: (_, provider) => provider.curUserName,
                    //             builder: (context, userName, child) {
                    //               return setNameField(userName);
                    //             }),
                    //         Selector<UserProvider, String>(
                    //             selector: (_, provider) => provider.email,
                    //             builder: (context, userEmail, child) {
                    //               return setEmailField(userEmail);
                    //             }),
                    //         saveButton(getTranslated(context, "SAVE_LBL")!, () {
                    //           validateAndSave(_changeUserDetailsKey);
                    //         }),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                );
            }
        );
      },
    );
  }

  // deleteTable(String tableId) async{
  //   CUR_USERID = await getPrefrence(Id);
  //   var headers = {
  //     'Cookie': 'ci_session=aa83f4f9d3335df625437992bb79565d0973f564'
  //   };
  //   var request = http.MultipartRequest('POST', Uri.parse(deleteTablesApi.toString()));
  //   request.fields.addAll({
  //     'id' : tableId.toString()
  //   });
  //
  //   print("this is refer request ${request.fields.toString()}");
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //   if (response.statusCode == 200) {
  //     String str = await response.stream.bytesToString();
  //     var result = json.decode(str);
  //     if(!result['error']){
  //       Fluttertoast.showToast(msg: '${result['message']}');
  //       getRestroTables();
  //     }
  //     print("this is referral data ${tablesList.length}");
  //   }
  //   else {
  //     print(response.reasonPhrase);
  //   }
  // }

  Future<Null> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  noInternet(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            noIntImage(),
            noIntText(context),
            noIntDec(context),
            AppBtn(
              title: getTranslated(context, "TRY_AGAIN_INT_LBL")!,
              btnAnim: buttonSqueezeanimation,
              btnCntrl: buttonController,
              onBtnSelected: () async {
                _playAnimation();

                Future.delayed(Duration(seconds: 2)).then(
                      (_) async {
                    _isNetworkAvail = await isNetworkAvailable();
                    if (_isNetworkAvail) {
                    } else {
                      await buttonController!.reverse();
                      setState(
                            () {},
                      );
                    }
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Future<Null> _refresh() async {
    Completer<Null> completer = new Completer<Null>();
    await Future.delayed(Duration(seconds: 3)).then(
          (onvalue) {
        completer.complete();
        getRestaurantTable();
        setState(
              () {
            _isLoading = true;
          },
        );
      },
    );
    return completer.future;
  }

  Widget bodyWidget() {
    return _isNetworkAvail
        ? _isLoading
        ? shimmer(context)
        : RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _refresh,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(widget.data!.storeName.toString(), style: TextStyle(
                      color: colors.primary, fontSize: 20, fontWeight: FontWeight.w600
                  ),),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Text("Choose your table", style: TextStyle(
                      color: Theme.of(context).colorScheme.fontColor, fontSize: 18, fontWeight: FontWeight.w600
                  ),),
                ),

                const SizedBox(height: 10,),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: tablesList.length,
                    itemBuilder: (context, index) {
                      return restroCard(index);
                    }),
              ],
            ),
          ),
        ))
        : noInternet(context);
  }



  Widget restroCard(int index) {
    return InkWell(
      onTap: (){
         Navigator.push(context, MaterialPageRoute(builder: (context) => TableDetails(data: tablesList[index], restroData: widget.data,)));
      },
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: tablesList[index].image == null ||
                        tablesList[index].image ==
                            'https://developmentalphawizz.com/blind_date/'
                        ? Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.primary, width: 2)),
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image:
                              AssetImage('assets/images/placeholder.png'),
                              fit: BoxFit.fitHeight),
                          // borderRadius: BorderRadius.circular(15)
                        ),
                        // child: Image.network(tablesList[index].image.toString(), width: 100, height: 100,)
                      ),
                    )
                        : Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.primary, width: 2)),
                      child: Container(
                        height: 80,
                        width: 80,
                        decoration: BoxDecoration(
                          // border: Border.all(color: primary, width: 1),
                          shape: BoxShape.circle,
                          // borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                              image: NetworkImage(
                                  tablesList[index].image.toString()),
                              fit: BoxFit.fill),
                          // borderRadius: BorderRadius.circular(15)
                        ),
                        // child: Image.network(tablesList[index].image.toString(), width: 100, height: 100,)
                      ),
                    )),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width/2,
                      child: Text(tablesList[index].name.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,  color: Theme.of(context).colorScheme.fontColor)),
                    ),
                    const SizedBox(height: 5,),
                    Container(
                      width: MediaQuery.of(context).size.width/2,
                      child: Text('Benefits : ${tablesList[index].benifits.toString()}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,  color: Theme.of(context).colorScheme.fontColor)),
                    ),
                    const SizedBox(height: 5,),
                    Text('Table Price : ₹ ${tablesList[index].price.toString()}', style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14, color: Theme.of(context).colorScheme.fontColor
                    ),),

                  ],
                ),
                // Padding(
                //   padding: const EdgeInsets.only(top: 60.0, right: 5),
                //   child: Container(
                //     padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(40),
                //         color: colors.primary
                //     ),
                //     child: Center(
                //       child: Text('₹ ${tablesList[index].price.toString()}', style: TextStyle(
                //           fontWeight: FontWeight.w600, fontSize: 14, color: colors.whiteTemp
                //       ),),
                //     ),
                //   ),
                // )

              ])),
    );

  }

  // bookingNow() async {
  //   var headers = {
  //     'Cookie': 'ci_session=aa83f4f9d3335df625437992bb79565d0973f564'
  //   };
  //   var request =
  //   http.MultipartRequest('POST', Uri.parse(completeProfileApi.toString()));
  //
  //   request.fields.addAll({
  //   'restaurant_id': widget.data!.id.toString(),
  //   'table_id': tablesList[0].id.toString(),
  //   'approx_amount':'1000',
  //   'date':'2023-05-05',
  //   'time':'10:00',
  //   'booking_amount':'100',
  //   'booking_transaction_id':'ABC7896543214',
  //   'booking_payment_status':'1',
  //   'booking_id':'22' ,
  //     'user_id': CUR_USERID.toString()
  //   });
  //
  //   // if(imagePathList != null) {
  //   //   for (var i = 0; i < imagePathList.length; i++) {
  //   //     imagePathList == null
  //   //         ? null
  //   //         : request.files.add(await http.MultipartFile.fromPath(
  //   //         'images[]', imagePathList[i].toString()));
  //   //   }
  //   // }
  //
  //   print(
  //       "this is complete profile request ====>>>> ${request.fields.toString()} and ${request.files.toString()}");
  //   request.headers.addAll(headers);
  //
  //   http.StreamedResponse response = await request.send();
  //   if (response.statusCode == 200) {
  //     String str = await response.stream.bytesToString();
  //     var result = json.decode(str);
  //     bool error = result['error'];
  //     String msg = result['message'];
  //     print("this is result response $error and $msg");
  //     if (!error) {
  //       setSnackbar(msg, context);
  //       // Navigator.pushReplacement(context,
  //       //     MaterialPageRoute(builder: (context) => Dashboard1()));
  //     } else {
  //       setSnackbar(msg, context);
  //     }
  //   } else {
  //     print(response.reasonPhrase);
  //   }
  // }

  ///RAZORPAY
  ///
    void _handlePaymentSuccess(PaymentSuccessResponse response) {
      // bookingNow();
      // placeOrder(response.paymentId);
      // sendRequest(response.paymentId, "RazorPay");
    }

    void _handlePaymentError(PaymentFailureResponse response) {
      setSnackbar(response.message!, context);
      if (mounted)
        setState(() {
          _isProgress = false;
        });
    }

    void _handleExternalWallet(ExternalWalletResponse response) {
      print("EXTERNAL_WALLET: " + response.walletName!);
    }

    razorpayPayment(double price) async {
      SettingProvider settingsProvider =
          Provider.of<SettingProvider>(this.context, listen: false);

      String? contact = settingsProvider.mobile;
      String? email = settingsProvider.email;

      double amt = price * 100;

      if (contact != '' && email != '') {
        if (mounted)
          setState(() {
            _isProgress = true;
          });

        var options = {
          KEY: razorpayId,
          AMOUNT: amt.toString(),
          NAME: settingsProvider.userName,
          'prefill': {CONTACT: contact, EMAIL: email},
        };

        try {
          _razorpay.open(options);
        } catch (e) {
          debugPrint(e.toString());
        }
      } else {
        if (email == '')
          setSnackbar(getTranslated(context, 'emailWarning')!, context);
        else if (contact == '')
          setSnackbar(getTranslated(context, 'phoneWarning')!, context);
      }
    }
  ///
  ///
  ///
  Future<void> _getpaymentMethod() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        var parameter = {
          TYPE: PAYMENT_METHOD,
        };
        Response response =
        await post(getSettingApi, body: parameter, headers: headers)
            .timeout(Duration(seconds: timeOut));
        if (response.statusCode == 200) {
          var getdata = json.decode(response.body);

          bool error = getdata["error"];

          if (!error) {
            var data = getdata["data"];

            var payment = data["payment_method"];

            paypal = payment["paypal_payment_method"] == "1" ? true : false;
            paumoney =
            payment["payumoney_payment_method"] == "1" ? true : false;
            flutterwave =
            payment["flutterwave_payment_method"] == "1" ? true : false;
            razorpay = payment["razorpay_payment_method"] == "1" ? true : false;
            paystack = payment["paystack_payment_method"] == "1" ? true : false;
            stripe = payment["stripe_payment_method"] == "1" ? true : false;
            paytm = payment["paytm_payment_method"] == "1" ? true : false;

            if (razorpay!) razorpayId = payment["razorpay_key_id"];
            if (paystack!) {
              paystackId = payment["paystack_key_id"];

              paystackPlugin.initialize(publicKey: paystackId!);
            }
            if (stripe!) {
              stripeId = payment['stripe_publishable_key'];
              stripeSecret = payment['stripe_secret_key'];
              stripeCurCode = payment['stripe_currency_code'];
              stripeMode = payment['stripe_mode'] ?? 'test';
              StripeService.secret = stripeSecret;
              StripeService.init(stripeId, stripeMode);
            }
            if (paytm!) {
              paytmMerId = payment['paytm_merchant_id'];
              paytmMerKey = payment['paytm_merchant_key'];
              payTesting =
              payment['paytm_payment_mode'] == 'sandbox' ? true : false;
            }

            for (int i = 0; i < paymentMethodList.length; i++) {
              payModel.add(RadioModel(
                  isSelected: i == selectedMethod ? true : false,
                  name: paymentMethodList[i],
                  ));
            }
          }
        }
        if (mounted)
          setState(() {
            _isLoading = false;
          });
        if (dialogState != null) dialogState!(() {});
      } on TimeoutException catch (_) {
        setSnackbar(getTranslated(context, 'somethingMSg')!, context);
      }
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
        });
    }
  }

  String? gender;

  getUserData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState((){
      gender = prefs.getString(GENDER);
    });
  }


  @override
  void initState() {
    super.initState();
    getUserData();
    Future.delayed(Duration(seconds: 1), (){
      getRestaurantTable();
    });
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    selectedMethod = null;
    payMethod = null;
    new Future.delayed(Duration.zero, () {
      paymentMethodList = [
        getTranslated(context, 'PAYPAL_LBL'),
        getTranslated(context, 'RAZORPAY_LBL'),
        getTranslated(context, 'PAYSTACK_LBL'),
        getTranslated(context, 'FLUTTERWAVE_LBL'),
        getTranslated(context, 'STRIPE_LBL'),
        getTranslated(context, 'PAYTM_LBL'),
      ];
      _getpaymentMethod();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBar(
          centerTitle: true,
          title: Image.asset('assets/images/homelogo.png', height: 60,),
          backgroundColor: colors.primary,
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios, color: colors.whiteTemp,),
          ),
          // actions: [
          //   Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: InkWell(
          //       onTap: () async {
          //         // var result = await Navigator.push(context, MaterialPageRoute(builder: (context)=> AddTable()));
          //         // if(result != null){
          //         //   getRestroTables();
          //         // }
          //       },
          //       child: Container(
          //         padding: EdgeInsets.all(8),
          //         decoration: BoxDecoration(
          //             border: Border.all(color: colors.whiteTemp),
          //             borderRadius: BorderRadius.circular(30)
          //         ),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.center,
          //           children: [
          //             Text("Add Table ", style: TextStyle(
          //                 color: colors.whiteTemp,
          //                 fontWeight: FontWeight.w600,
          //                 fontSize: 16
          //             ),),
          //             Icon(Icons.add_box, color: colors.whiteTemp,)
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          //
          //   // SizedBox(
          //   //   height: 30,
          //   //   child: Container(
          //   //     height: 30,
          //   //     width: 100,
          //   //     decoration: BoxDecoration(
          //   //       color: Colors.colors.whiteTemp, borderRadius: BorderRadius.circular(20)
          //   //     ),
          //   //     child: Center(
          //   //       child: Row(
          //   //         mainAxisAlignment: MainAxisAlignment.center,
          //   //         children: [
          //   //           Text("Add Table", style: TextStyle(
          //   //             color: primary
          //   //           ),),
          //   //           Icon(Icons.add_box, color: primary,)
          //   //         ],
          //   //       ),
          //   //     ),
          //   //   ),
          //   // )
          //
          // ],
        ),
      ),
        body: bodyWidget());
  }
}
