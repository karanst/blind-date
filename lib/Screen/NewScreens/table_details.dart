import 'dart:async';
import 'dart:convert';
import 'package:blind_date/Helper/Constant.dart';
import 'package:blind_date/Helper/Stripe_Service.dart';
import 'package:blind_date/Helper/user_custom_radio.dart';
import 'package:blind_date/Model/get_coupon_model.dart';
import 'package:blind_date/Model/restaurant_model.dart';
import 'package:blind_date/Provider/CartProvider.dart';
import 'package:blind_date/Provider/SettingProvider.dart';
import 'package:blind_date/Screen/bottom_bar.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:http/http.dart' as http;
import 'package:blind_date/Helper/AppBtn.dart';
import 'package:blind_date/Helper/Color.dart';
import 'package:blind_date/Helper/Session.dart';
import 'package:blind_date/Helper/String.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Model/Transaction_Model.dart';

class TableDetails extends StatefulWidget {
  final Tables? data;
  final Restaurants? restroData;
  const TableDetails({Key? key, this.data, this.restroData}) : super(key: key);

  @override
  State<TableDetails> createState() => _TableDetailsState();
}

bool _isLoading = true;

class _TableDetailsState extends State<TableDetails> with TickerProviderStateMixin {


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

  String? selectedDate;

  TimeOfDay? selectedTime;
  TextEditingController startTimeController = TextEditingController();


  _selectStartTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        useRootNavigator: true,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(primary: colors.primary),
                buttonTheme: ButtonThemeData(
                    colorScheme: ColorScheme.light(primary: colors.primary))),
            child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: false),
                child: child!),
          );
        });
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay.replacing(hour: timeOfDay.hourOfPeriod);
        startTimeController.text = selectedTime!.format(context);
      });
    }
    var per = selectedTime!.period.toString().split(".");
    print("selected time here ${selectedTime!.format(context).toString()} and ${per[1]}");
  }

  // void openRequestTrainingBottomSheet() {
  //   showModalBottomSheet(
  //     shape: const RoundedRectangleBorder(
  //         borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0))),
  //     isScrollControlled: true,
  //     context: context,
  //     builder: (context) {
  //       return StatefulBuilder(
  //           builder: (BuildContext context, StateSetter setState) {
  //             return
  //
  //               Wrap(
  //                 alignment: WrapAlignment.center,
  //                 children: [
  //
  //                   Padding(
  //                       padding: EdgeInsets.all(15),
  //                       child: Text(
  //                         "Book Now", style: TextStyle(color: Theme
  //                           .of(context)
  //                           .colorScheme
  //                           .fontColor,
  //                           fontSize: 18,
  //                           fontWeight: FontWeight.w600),)),
  //                   // catList.isNotEmpty ?
  //                   // Padding(
  //                   //     padding: const EdgeInsets.all(20),
  //                   //     child: Container(
  //                   //       padding: EdgeInsets.all(8),
  //                   //       height: 50,
  //                   //       width: MediaQuery
  //                   //           .of(context)
  //                   //           .size
  //                   //           .width,
  //                   //       decoration: BoxDecoration(
  //                   //           color: Theme
  //                   //               .of(context)
  //                   //               .colorScheme
  //                   //               .white,
  //                   //           borderRadius: BorderRadius.circular(12),
  //                   //           border: Border.all(color: Theme
  //                   //               .of(context)
  //                   //               .colorScheme
  //                   //               .fontColor)
  //                   //       ),
  //                   //       child: DropdownButtonHideUnderline(
  //                   //         child: DropdownButton(
  //                   //           hint: Text('Select Product type'),
  //                   //           // Not necessary for Option 1
  //                   //           value: categoryValue,
  //                   //           onChanged: (String? newValue) {
  //                   //             setState(() {
  //                   //               categoryValue = newValue;
  //                   //             });
  //                   //             print("this is category value $categoryValue");
  //                   //           },
  //                   //           items: catList.map((item) {
  //                   //             return DropdownMenuItem(
  //                   //               child: Text(
  //                   //                 item.name!, style: TextStyle(color: Theme
  //                   //                   .of(context)
  //                   //                   .colorScheme
  //                   //                   .fontColor),),
  //                   //               value: item.id,
  //                   //             );
  //                   //           }).toList(),
  //                   //         ),
  //                   //       ),
  //                   //     )
  //                   // )
  //                   //     : SizedBox.shrink(),
  //                   Padding(
  //                     padding: const EdgeInsets.all(20),
  //                     child: Container(
  //                       padding:
  //                       EdgeInsets.only(bottom: MediaQuery
  //                           .of(context)
  //                           .viewInsets
  //                           .bottom),
  //                       decoration: BoxDecoration(
  //                         color: Theme
  //                             .of(context)
  //                             .colorScheme
  //                             .white,
  //                         borderRadius: BorderRadius.circular(10.0),
  //                       ),
  //                       child: Padding(
  //                         padding:
  //                         const EdgeInsets.symmetric(
  //                             horizontal: 10.0, vertical: 5.0),
  //                         child: TextFormField(
  //                           //initialValue: nameController.text,
  //                           style: TextStyle(
  //                               color: Theme
  //                                   .of(context)
  //                                   .colorScheme
  //                                   .fontColor,
  //                               fontWeight: FontWeight.bold),
  //                           controller: messageController,
  //                           decoration: InputDecoration(
  //                               label: Text(
  //                                 "Message",
  //                                 style: TextStyle(
  //                                   color: Theme
  //                                       .of(context)
  //                                       .colorScheme
  //                                       .primary,
  //                                 ),
  //                               ),
  //                               fillColor: Theme
  //                                   .of(context)
  //                                   .colorScheme
  //                                   .primary,
  //                               border: InputBorder.none),
  //                           // validator: (val) => validateUserName(
  //                           //     val!,
  //                           //     getTranslated(context, 'USER_REQUIRED'),
  //                           //     getTranslated(context, 'USER_LENGTH')),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.only(bottom: 20.0, top: 10),
  //                     child: ElevatedButton(onPressed: () {
  //                       // if(selectedDate != null && selectedTime != null) {
  //                       //   razorpayPayment(1000);
  //                       // }else{
  //                       //   setSnackbar("Please select booking date and time", context);
  //                       // }
  //                     },
  //                         style: ElevatedButton.styleFrom(primary: colors.primary,
  //                             fixedSize: Size(MediaQuery
  //                                 .of(context)
  //                                 .size
  //                                 .width - 60, 40),
  //                             shape: StadiumBorder()),
  //                         child: Text("Book Now", style: TextStyle(
  //                             fontWeight: FontWeight.w600, fontSize: 16
  //                             , color: colors.whiteTemp),)),
  //                   )
  //                   // Padding(
  //                   //   padding: EdgeInsets.only(
  //                   //       bottom: MediaQuery.of(context).viewInsets.bottom),
  //                   //   child: Form(
  //                   //     key: _changeUserDetailsKey,
  //                   //     child: Column(
  //                   //       mainAxisSize: MainAxisSize.max,
  //                   //       children: [
  //                   //         bottomSheetHandle(),
  //                   //         bottomsheetLabel("EDIT_PROFILE_LBL"),
  //                   //         Selector<UserProvider, String>(
  //                   //             selector: (_, provider) => provider.profilePic,
  //                   //             builder: (context, profileImage, child) {
  //                   //               return Padding(
  //                   //                 padding: const EdgeInsets.symmetric(vertical: 10.0),
  //                   //                 child: getUserImage(profileImage, _imgFromGallery),
  //                   //               );
  //                   //             }),
  //                   //         Selector<UserProvider, String>(
  //                   //             selector: (_, provider) => provider.curUserName,
  //                   //             builder: (context, userName, child) {
  //                   //               return setNameField(userName);
  //                   //             }),
  //                   //         Selector<UserProvider, String>(
  //                   //             selector: (_, provider) => provider.email,
  //                   //             builder: (context, userEmail, child) {
  //                   //               return setEmailField(userEmail);
  //                   //             }),
  //                   //         saveButton(getTranslated(context, "SAVE_LBL")!, () {
  //                   //           validateAndSave(_changeUserDetailsKey);
  //                   //         }),
  //                   //       ],
  //                   //     ),
  //                   //   ),
  //                   // ),
  //                 ],
  //               );
  //           }
  //       );
  //     },
  //   );
  // }

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
  //     print("this is referral data ${widget.data.length}");
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
        // getRestaurantTable();
        setState(
              () {
            _isLoading = true;
          },
        );
      },
    );
    return completer.future;
  }

  void openPromoBottomSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0))),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Wrap(
          children: [
            Center(child: Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10),
              child: Text("Apply Promo Code", style: TextStyle(color: Theme.of(context).colorScheme.fontColor, fontSize: 18),),
            )),

            Padding(
              padding: const EdgeInsets.only(left: 12.0, right: 12),
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: couponsList.length,
                  itemBuilder: (context, index) {
                    return couponCard(index);
                  }),
            ),
          ],
        );
      },
    );
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
                Text(widget.data!.name.toString(), style: TextStyle(
                    color: colors.primary, fontSize: 20, fontWeight: FontWeight.w600
                ),),
                const SizedBox(height: 10,),
               restroCard(),
                const SizedBox(height: 10,),
                gender == "male" || gender == "Male"?
                    SizedBox.shrink()
                : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 15.0, top: 10, bottom: 5),
                          child: Text(
                            "Booking Date",
                            style: TextStyle(
                                color: colors.primary, fontWeight: FontWeight.w600),
                          ),
                        ),
                        InkWell(
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
                                selectedDate = formattedDate; //set output date to TextField value.
                              });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            height: 50,
                            width: MediaQuery.of(context).size.width / 2 - 20,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.lightWhite,
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5.0,
                                      offset: Offset(0.75, 0.75)
                                  )
                                ],
                              // color: Colors.white,
                              //   border: Border.all(color: Colors.grey)
                            ),
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    selectedDate == null || selectedDate == ''
                                        ?
                                    Text(
                                      "Select Date",
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .fontColor))
                                      : Text(
                                      "${selectedDate.toString()}",
                          ),
                                    Icon(Icons.calendar_month, color: colors.primary,)

                                  ],
                                )

                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.only(left: 15.0, top: 10, bottom: 5),
                          child: Text(
                            "Booking Time",
                            style: TextStyle(
                                color: colors.primary, fontWeight: FontWeight.w600),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            _selectStartTime(context);
                          },
                          child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width/2- 25,
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.centerLeft,
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.lightWhite,
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5.0,
                                      offset: Offset(0.75, 0.75)
                                  )
                                ],
                                // border: Border.all(
                                //   color: Theme.of(context).colorScheme.fontClr,
                                // )
                              ),
                              child:
                              selectedTime != null
                                  ?
                              Row (
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${selectedTime!.format(context).toString()} ${selectedTime!.period.toString().split(".")[1]}',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.fontColor,
                                    ),),
                                  Icon(Icons.access_time,
                                    color: colors.primary,)
                                ],
                              )
                                  : Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Select Time",
                                    style: TextStyle(
                                        color: Theme.of(context).colorScheme.fontColor,
                                        fontSize: 15),
                                  ),
                                  Icon(Icons.access_time,
                                    color: colors.primary,)
                                ],
                              )),
                          // TextFormField( controller: locationController,
                          //   validator: (v){
                          //     if(v!.isEmpty){
                          //       return "Enter time";
                          //     }
                          //   },
                          //   readOnly: true,
                          //   decoration: InputDecoration(
                          //       hintText: "Select time",
                          //       border: OutlineInputBorder(
                          //           borderRadius: BorderRadius.circular(7),
                          //           borderSide: BorderSide(color: appColorBlack.withOpacity(0.5))
                          //       )
                          //   ),),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                InkWell(
                  onTap: (){
                    openPromoBottomSheet();
                  },
                  child: Container(
                      padding: EdgeInsets.all(8),
                      height: 50,
                      width: MediaQuery.of(context).size.width - 20,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.lightWhite,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5.0,
                              offset: Offset(0.75, 0.75)
                          )
                        ],
                        // color: Colors.white,
                        //   border: Border.all(color: Colors.grey)
                      ),
                      child:  Center(
                          child: Text('Apply Promo Code'))
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     selectedDate == null || selectedDate == ''
                      //         ?
                      //     Text(
                      //         "Select Date",
                      //         style: TextStyle(
                      //             color: Theme.of(context)
                      //                 .colorScheme
                      //                 .fontColor))
                      //         : Text(
                      //       "${selectedDate.toString()}",
                      //     ),
                      //     Icon(Icons.calendar_month, color: colors.primary,)
                      //
                      //   ],
                      // )

                  ),
                ),
                // InkWell(
                //   onTap: (){
                //     openPromoBottomSheet();
                //   },
                //   child: Container(
                //     child: Text("Apply Promo Code"),
                //   ),
                // ),
                const SizedBox(height: 30,),
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: ElevatedButton(onPressed: (){
                    print("this si gender and avaialbility ===>>> ${gender} and ${widget.restroData!.isDateAvailable}");
                    if(gender =="male" || gender == "Male") {
                      if (widget.restroData!.isDateAvailable == true) {
                          razorpayPayment(bookingPrice);
                      }else{
                        setSnackbar("You are not allowed to book now, Please try again later!", context);
                      }
                    }else{
                      if (selectedDate != null && selectedTime != null) {
                        razorpayPayment(bookingPrice);
                      } else {
                        setSnackbar(
                            "Please select booking date and time", context);
                      }
                    }
                  }, child: Text("Book Now", style: TextStyle(color: colors.whiteTemp, fontWeight: FontWeight.w600, fontSize: 16),),
                    style: ElevatedButton.styleFrom(primary: colors.primary, shape: StadiumBorder(),
                        fixedSize: Size(MediaQuery.of(context).size.width-40, 40)),),
                ),
                const SizedBox(height: 30,),
              ],
            ),
          ),
        ))
        : noInternet(context);
  }



  Widget restroCard() {
    return InkWell(
      onTap: (){
        // Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantDetails(id: restaurantList[index].id.toString())));
      },
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: widget.data!.image == null ||
                        widget.data!.image ==
                            'https://developmentalphawizz.com/blind_date/'
                        ? Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: colors.primary, width: 2)),
                      child: Container(
                        height: MediaQuery.of(context).size.width - 120,
                        width: MediaQuery.of(context).size.width - 100 ,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              image:
                              AssetImage('assets/images/placeholder.png'),
                              fit: BoxFit.fitHeight),
                          // borderRadius: BorderRadius.circular(15)
                        ),
                        // child: Image.network(widget.data[index].image.toString(), width: 100, height: 100,)
                      ),
                    )
                        : Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: colors.primary, width: 2)),
                      child: Container(
                        height: MediaQuery.of(context).size.width - 120,
                        width: MediaQuery.of(context).size.width - 100 ,
                        decoration: BoxDecoration(
                          // border: Border.all(color: primary, width: 1),
                          borderRadius: BorderRadius.circular(15),
                          // borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                              image: NetworkImage(
                                  widget.data!.image.toString()),
                              fit: BoxFit.fill),
                          // borderRadius: BorderRadius.circular(15)
                        ),
                        // child: Image.network(widget.data[index].image.toString(), width: 100, height: 100,)
                      ),
                    )),
                // Text(widget.data!.name.toString(),
                //     overflow: TextOverflow.ellipsis,
                //     maxLines: 2,
                //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,  color: colors.primary)),
                const SizedBox(height: 5,),
                Text("Benefits : ${widget.data!.benifits.toString()}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500,  color: Theme.of(context).colorScheme.fontColor)),
                const SizedBox(height: 5,),
                Text('Booking amount : ₹ ${widget.restroData!.bookingAmount.toString()}', style: TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 16, color: Theme.of(context).colorScheme.fontColor
                ),),
                const SizedBox(height: 5,),
                Text('Table Price : ₹ ${widget.data!.price.toString()}', style: TextStyle(
                    fontWeight: FontWeight.w500, fontSize: 16, color: Theme.of(context).colorScheme.fontColor
                ),),
                const SizedBox(height: 10,),


                // Padding(
                //   padding: const EdgeInsets.only(top: 60.0, right: 5),
                //   child: Container(
                //     padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(40),
                //         color: colors.primary
                //     ),
                //     child: Center(
                //       child: Text('₹ ${widget.data[index].price.toString()}', style: TextStyle(
                //           fontWeight: FontWeight.w600, fontSize: 14, color: colors.whiteTemp
                //       ),),
                //     ),
                //   ),
                // )

              ])),
    );

  }

  Widget couponCard(int index) {
    return InkWell(
      onTap: (){
        // Navigator.push(context, MaterialPageRoute(builder: (context) => TableDetails(data: couponsList[index], restroData: widget.data,)));
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
                    child: couponsList[index].image == null ||
                        couponsList[index].image ==
                            'https://developmentalphawizz.com/blind_date/'
                        ? Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.primary, width: 2)),
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image:
                              AssetImage('assets/images/placeholder.png'),
                              fit: BoxFit.fitHeight),
                          // borderRadius: BorderRadius.circular(15)
                        ),
                        // child: Image.network(couponsList[index].image.toString(), width: 100, height: 100,)
                      ),
                    )
                        : Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: colors.primary, width: 2)),
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          // border: Border.all(color: primary, width: 1),
                          shape: BoxShape.circle,
                          // borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                              image: NetworkImage(
                                  couponsList[index].image.toString()),
                              fit: BoxFit.fill),
                          // borderRadius: BorderRadius.circular(15)
                        ),
                        // child: Image.network(couponsList[index].image.toString(), width: 100, height: 100,)
                      ),
                    )),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width/2 - 20,
                      child: Text(couponsList[index].promoCode.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: Theme.of(context).colorScheme.fontColor)),
                    ),
                    const SizedBox(height: 5,),
                    Container(
                      width: MediaQuery.of(context).size.width/2 -20,
                      child: Text('${couponsList[index].message.toString()}',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,  color: Theme.of(context).colorScheme.fontColor)),
                    ),
                    const SizedBox(height: 5,),
                    Text('Valid till : ${couponsList[index].endDate.toString()}', style: TextStyle(
                        fontWeight: FontWeight.w500, fontSize: 14, color: Theme.of(context).colorScheme.fontColor
                    ),),

                  ],
                ),
                ElevatedButton(
                    onPressed: (){
                      validatePromo(couponsList[index].promoCode.toString());
                    },
                    style: ElevatedButton.styleFrom(
                        primary: colors.primary,
                        shape: StadiumBorder()
                    ),
                    child: Text("Apply", style: TextStyle(
                        color: colors.whiteTemp,
                        fontWeight: FontWeight.w600
                    ),))
                // Padding(
                //   padding: const EdgeInsets.only(top: 60.0, right: 5),
                //   child: Container(
                //     padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(40),
                //         color: colors.primary
                //     ),
                //     child: Center(
                //       child: Text('₹ ${couponsList[index].price.toString()}', style: TextStyle(
                //           fontWeight: FontWeight.w600, fontSize: 14, color: colors.whiteTemp
                //       ),),
                //     ),
                //   ),
                // )

              ])),
    );

  }

  bookingNow(String transID) async {
    print("this is working here also!");

    var headers = {
      'Cookie': 'ci_session=aa83f4f9d3335df625437992bb79565d0973f564'
    };

    var request =
    http.MultipartRequest('POST', Uri.parse(bookNowApi.toString()));

    request.fields.addAll({
      'restaurant_id': widget.restroData!.id.toString(),
      'table_id': widget.data!.id.toString(),
      'approx_amount': widget.data!.price.toString(),
      'date': gender == "male" || gender == "Male"? widget.restroData!.bookingDate.toString()  : selectedDate.toString(),
      'time': gender == "male" || gender == "Male"? widget.restroData!.bookingTime.toString()  : '${selectedTime!.format(context).toString()} ${selectedTime!.period.toString().split(".")}',
      'booking_amount': widget.restroData!.bookingAmount.toString(),
      'booking_transaction_id':transID.toString(),
      'booking_payment_status':'1',
      'booking_id': gender == 'male' || gender == 'Male' ? widget.restroData!.bookingId.toString() : '',
      'user_id': CUR_USERID.toString(),
      'user_type': gender.toString()
    });

    // if(imagePathList != null) {
    //   for (var i = 0; i < imagePathList.length; i++) {
    //     imagePathList == null
    //         ? null
    //         : request.files.add(await http.MultipartFile.fromPath(
    //         'images[]', imagePathList[i].toString()));
    //   }
    // }

    print("this is complete profile request ====>>>> ${request.fields.toString()} and ${request.files.toString()}");
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String str = await response.stream.bytesToString();
      var result = json.decode(str);
      bool error = result['error'];
      String msg = result['message'];
      print("this is result response $error and $msg");
      if (!error) {
        setSnackbar(msg, context);

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Dashboard1()));
      } else {
        setSnackbar(msg, context);
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  double bookingPrice = 0, promoAmt = 0;
  Future<void> validatePromo(String promoCode) async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        setState(() {});
        var parameter = {
          USER_ID: CUR_USERID,
          PROMOCODE: promoCode.toString(),
          FINAL_TOTAL: widget.data!.price.toString(),
        };
        print("this is apply promo code $parameter");
        Response response =
        await post(validatePromoApi, body: parameter, headers: headers)
            .timeout(Duration(seconds: timeOut));

        if (response.statusCode == 200) {
          var getdata = json.decode(response.body);

          bool error = getdata["error"];
          String? msg = getdata["message"];
          if (!error) {
             var data = getdata["data"][0];

             promoAmt = double.parse(data["final_discount"]);
             setState((){
               bookingPrice = double.parse(widget.restroData!.bookingAmount.toString()) - promoAmt!;
             });
            // promocode = data["promo_code"];
            // isPromoValid = true;
            setSnackbar("Promo Code applied successfully!", context);
            print("this is promo code $promoAmt");
            Navigator.pop(context);
          } else {

            setSnackbar(msg!, context);
            Navigator.pop(context);
            // isPromoValid = false;
            // promoAmt = 0;
            // promocode = null;
            // promoC.clear();
            // var data = getdata["data"];
            //
            // totalPrice = double.parse(data["final_total"]) + delCharge;

          }

        }
      } on TimeoutException catch (_) {

        setState(() {});
        setSnackbar(getTranslated(context, 'somethingMSg')!, context);
      }
    } else {
      _isNetworkAvail = false;

      setState(() {});
    }
  }

  List<Coupons> couponsList = [];

  getCouponCodes() async {
    var headers = {
      'Cookie': 'ci_session=aa83f4f9d3335df625437992bb79565d0973f564'
    };
    var request =
    http.MultipartRequest('POST', Uri.parse(getCouponCodesApi.toString()));


    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String str = await response.stream.bytesToString();
      var result = json.decode(str);
      var finalResponse = GetCouponModel.fromJson(result);
      setState(() {
        couponsList = finalResponse.data!;
        // _isLoading = false;
      });
      print("this is referral data ${couponsList.length}");
    } else {
      print(response.reasonPhrase);
    }
  }

  ///RAZORPAY
  ///
  String? transID;
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("this is working here !");
   setState(() {
     transID = response.paymentId!;
   });
    bookingNow(transID!);
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
    getCouponCodes();
    // getRestaurantTable();
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

  @override
  void dispose() {
    buttonController!.dispose();

    if (_razorpay != null) _razorpay.clear();
    super.dispose();
  }
}
