import 'dart:async';
import 'dart:convert';
import 'package:blind_date/Helper/Constant.dart';
import 'package:blind_date/Helper/Stripe_Service.dart';
import 'package:blind_date/Helper/user_custom_radio.dart';
import 'package:blind_date/Model/my_bookings_model.dart';
import 'package:blind_date/Model/restaurant_model.dart';
import 'package:blind_date/Provider/SettingProvider.dart';
import 'package:blind_date/Screen/NewScreens/booking_details.dart';
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

import '../../Model/Transaction_Model.dart';

class MyBookings extends StatefulWidget {
  final Restaurants? data;
  final String? id;
  const MyBookings({Key? key, this.data, this.id}) : super(key: key);

  @override
  State<MyBookings> createState() => _MyBookingsState();
}

bool _isLoading = true;

class _MyBookingsState extends State<MyBookings> with TickerProviderStateMixin {
  List<Bookings> bookingList = [];

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

  getMyBookings() async {
    var headers = {
      'Cookie': 'ci_session=aa83f4f9d3335df625437992bb79565d0973f564'
    };
    var request =
    http.MultipartRequest('POST', Uri.parse(bookingListApi.toString()));
    request.fields.addAll({
      'user_id' : CUR_USERID.toString()
    });

    print("this is restro request ${request.fields.toString()}");
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String str = await response.stream.bytesToString();
      var result = json.decode(str);
      var finalResponse = MyBookingsModel.fromJson(result);
      setState(() {
        bookingList = finalResponse.data!;
        _isLoading = false;
      });
      print("this is referral data ${bookingList.length}");
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
  //     print("this is referral data ${bookingList.length}");
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
        getMyBookings();
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
              children: [
                Text("My Bookings", style: TextStyle(
                    color: colors.primary, fontSize: 20, fontWeight: FontWeight.w600
                ),),
                const SizedBox(height: 10,),
                bookingList.isNotEmpty ?
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: bookingList.length,
                    itemBuilder: (context, index) {
                      return bookingCard(index);
                        //restroCard(index);
                    })
                :  Container(
                  height: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text(" No bookings found!"),
                  ),
                ),
              ],
            ),
          ),
        ))
        : noInternet(context);
  }



  Widget restroCard(int index) {
    return InkWell(
      onTap: (){
        // Navigator.push(context, MaterialPageRoute(builder: (context) => TableDetails(data: bookingList[index], restroData: widget.data,)));
      },
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Row(
                    children: [
                      Text('Date : ',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,  color: Theme.of(context).colorScheme.fontColor)),
                      Text('${bookingList[index].bookingDate.toString()}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  color: colors.primary)),
                    ],
                  ),
                    Container(
                      height: 20,
                        child: VerticalDivider(color: colors.primary, thickness: 1,)),

                    Row(
                      children: [
                        Text('Time : ',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,  color: Theme.of(context).colorScheme.fontColor)),
                        Text('${bookingList[index].bookingTime.toString()}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  color: colors.primary)),
                      ],
                    ),

                ],),
                Divider(color: colors.primary, thickness: 1,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Booking ID : ',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,  color: Theme.of(context).colorScheme.fontColor)),
                    Text('${bookingList[index].id.toString()}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  color: colors.primary)),
                  ],
                ),
                const SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Restaurant : ',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,  color: Theme.of(context).colorScheme.fontColor)),
                    Text('${bookingList[index].storeName.toString()}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  color: colors.primary)),
                  ],
                ),
                const SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Table Type : ',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,  color: Theme.of(context).colorScheme.fontColor)),
                    Text('${bookingList[index].tableName.toString()}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  color: colors.primary)),
                  ],
                ),
                const SizedBox(height: 5,),
                Divider(color: colors.primary, thickness: 1,),
                Text('Approx Amount : ₹ ${bookingList[index].approxAmount.toString()}', style: TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14, color: colors.blackTemp
                ),),

              ],
            ),
          )),
    );

  }

  Widget bookingCard(int index) {
    String status = 'Waiting';
    if(bookingList[index].status.toString() == "0"){
      status = 'Waiting';
    }else if(bookingList[index].status.toString() == "1"){
      status = 'Processing';
    }else if(bookingList[index].status.toString() == "2"){
      status = 'Accepted';
    }else if(bookingList[index].status.toString() == "3"){
      status = 'Rejected';
    }else{
      status = 'Completed';
    }
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => BookingDetails(data: bookingList[index])));
      },
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text('Date : ',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,  color: Theme.of(context).colorScheme.fontColor)),
                        Text('${bookingList[index].bookingDate.toString()}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  color: colors.primary)),
                      ],
                    ),
                    Container(
                        height: 20,
                        child: VerticalDivider(color: colors.primary, thickness: 1,)),

                    Row(
                      children: [
                        Text('Time : ',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,  color: Theme.of(context).colorScheme.fontColor)),
                        Text('${bookingList[index].bookingTime.toString()}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  color: colors.primary)),
                      ],
                    ),

                  ],),
                Divider(color: colors.primary, thickness: 1,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Booking ID : ',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,  color: Theme.of(context).colorScheme.fontColor)),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                          child: Text('Restaurant : ',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,  color: Theme.of(context).colorScheme.fontColor)),
                        ),
                        Text('Table Type : ',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,  color: Theme.of(context).colorScheme.fontColor)),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text('Booking Status : ',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,  color: Theme.of(context).colorScheme.fontColor)),
                        ),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${bookingList[index].id.toString()}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  color: colors.primary)),

                        Padding(
                          padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                          child: Text('${bookingList[index].storeName.toString()}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  color: colors.primary)),
                        ),

                        Text('${bookingList[index].tableName.toString()}',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  color: colors.primary)),

                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Text('${status.toString()}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  color: colors.primary)),
                        ),

                      ],

                    )
                  ],
                ),
                Divider(color: colors.primary, thickness: 1,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Approx Amount : ', style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14, color: colors.blackTemp
                    ),),
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                      decoration: BoxDecoration(
                          color: colors.primary,
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Center(
                        child: Text("₹ ${bookingList[index].approxAmount.toString()}",
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  color: colors.whiteTemp)),

                      ),
                    )
                  ],
                ),

              ],
            ),
          )),
    );
  }


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


  @override
  void initState() {
    super.initState();
    getMyBookings();
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
          ),
        ),
        body: bodyWidget());
  }
}
