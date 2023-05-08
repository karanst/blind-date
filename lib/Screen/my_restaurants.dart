import 'dart:async';
import 'dart:convert';
import 'package:blind_date/Model/restaurant_model.dart';
import 'package:blind_date/Screen/NewScreens/restaurant_details.dart';
import 'package:http/http.dart' as http;
import 'package:blind_date/Helper/AppBtn.dart';
import 'package:blind_date/Helper/Color.dart';
import 'package:blind_date/Helper/Session.dart';
import 'package:blind_date/Helper/String.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyRestaurants extends StatefulWidget {
  const MyRestaurants({Key? key}) : super(key: key);

  @override
  State<MyRestaurants> createState() => _MyRestaurantsState();
}

bool _isLoading = true;

class _MyRestaurantsState extends State<MyRestaurants>
    with TickerProviderStateMixin {
  List<Restaurants> restaurantList = [];

  bool _isNetworkAvail = true;
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  String? gender;

  getRestaurants() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double? lat = prefs.getDouble(LATITUDE);
    double? long = prefs.getDouble(LONGITUDE);
     gender = prefs.getString(GENDER);
    var headers = {
      'Cookie': 'ci_session=aa83f4f9d3335df625437992bb79565d0973f564'
    };
    var request =
        http.MultipartRequest('POST', Uri.parse(getRestroListApi.toString()));
    request.fields.addAll({
      'user_type': gender.toString(),
      'lat' : lat.toString(),
      'lng': long.toString()
    });

    print("this is restro request ${request.fields.toString()}");
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String str = await response.stream.bytesToString();
      var result = json.decode(str);
      var finalResponse = RestaurantModel.fromJson(result);
      setState(() {
        restaurantList = finalResponse.data!;
        _isLoading = false;
      });
      print("this is referral data ${restaurantList.length}");
    } else {
      print(response.reasonPhrase);
    }
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
        getRestaurants();
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
                        Text("Choose Restaurants", style: TextStyle(
                          color: colors.primary, fontSize: 20, fontWeight: FontWeight.w600
                        ),),
                        const SizedBox(height: 10,),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: restaurantList.length,
                            itemBuilder: (context, index) {
                              return restroCard(index);
                            }),
                      ],
                    ),
                  ),
                ))
        : noInternet(context);
  }

  // Widget tablesCard(int index){
  //   return Container(
  //     height: 160,
  //     child: Stack(
  //       children: [
  //         Positioned(
  //           left: 40,
  //           top: 30,
  //           child: Card(
  //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
  //             child: Container(
  //               // height: 280,
  //               width: MediaQuery.of(context).size.width - 70,
  //               decoration: BoxDecoration(
  //                   borderRadius: BorderRadius.circular(15),
  //                   color: colors.whiteTemp,
  //                   border: Border.all(color: primary, width: 1)
  //               ),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   Container(
  //                     padding: EdgeInsets.only(top: 5, bottom: 5),
  //                     child:  Center(
  //                       child: Text(tablesList[index].name.toString(),
  //                           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: colors.whiteTemp)),
  //                     ),
  //                     decoration: BoxDecoration(
  //                       color: primary,
  //                       borderRadius: BorderRadius.only(topRight: Radius.circular(13), topLeft: Radius.circular(13))
  //                     ),
  //                   ),
  //                   Padding(
  //                     padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         const SizedBox(width: 60,),
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //
  //                             Padding(
  //                               padding: const EdgeInsets.only(bottom: 5),
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                 children: [
  //                                   Text("Booking Amount : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color:  Theme.of(context).colorScheme.fontColor),),
  //                                   Text("₹ ${tablesList[index].price.toString()}",
  //                                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: primary) ),
  //                                   // Container(
  //                                   //   padding: EdgeInsets.all(10),
  //                                   //   decoration: BoxDecoration(border: Border.all(color: primary, ),
  //                                   //       borderRadius: BorderRadius.circular(15)),
  //                                   //   child: Text(bookingList[index].approxAmount.toString(),
  //                                   //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: primary) ),
  //                                   // ),
  //                                 ],
  //                               ),
  //                             ),
  //                             Row(
  //                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Text("Total Tables : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color:  Theme.of(context).colorScheme.fontColor),),
  //                                 Text("${tablesList[index].totalTables.toString()}",
  //                                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: primary) ),
  //                               ],
  //                             ),
  //                             Padding(
  //                               padding: const EdgeInsets.only(top: 5.0),
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                 children: [
  //                                   Text("Benefits : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color:  Theme.of(context).colorScheme.fontColor),),
  //                                   Text("${tablesList[index].benifits.toString()}",
  //                                       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: primary) ),
  //                                 ],
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         // Column(
  //                         //   crossAxisAlignment: CrossAxisAlignment.start,
  //                         //   children: [
  //                         //     Row(
  //                         //       children: [
  //                         //         Text("Name : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color:  Theme.of(context).colorScheme.fontColor),),
  //                         //
  //                         //         Text(bookingList[index].users![0].detail!.username.toString(),
  //                         //             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  color: primary)),
  //                         //       ],
  //                         //     ),
  //                         //     const SizedBox(height: 5,),
  //                         //     Row(
  //                         //       children: [
  //                         //         Text("Contact No.: ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color:  Theme.of(context).colorScheme.fontColor),),
  //                         //         Text(bookingList[index].users![0].detail!.mobile.toString(),
  //                         //             style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  color: primary) ),
  //                         //       ],
  //                         //     ),
  //                         //   ],
  //                         // ),
  //                       ],
  //                     ),
  //                   ),
  //
  //                   // Padding(
  //                   //   padding: const EdgeInsets.only(left: 10.0, right: 10),
  //                   //   child: Row(
  //                   //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   //     children: [
  //                   //       Text("Amount : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color:  Theme.of(context).colorScheme.fontColor),),
  //                   //       Text("₹ ${tablesList[index].price.toString()}",
  //                   //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: primary) ),
  //                   //       // Container(
  //                   //       //   padding: EdgeInsets.all(10),
  //                   //       //   decoration: BoxDecoration(border: Border.all(color: primary, ),
  //                   //       //       borderRadius: BorderRadius.circular(15)),
  //                   //       //   child: Text(bookingList[index].approxAmount.toString(),
  //                   //       //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: primary) ),
  //                   //       // ),
  //                   //     ],
  //                   //   ),
  //                   // ),
  //                   //
  //                   // Padding(
  //                   //   padding: const EdgeInsets.only(left: 10.0, right: 10),
  //                   //   child: Row(
  //                   //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   //     children: [
  //                   //       Text("Total Tables : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color:  Theme.of(context).colorScheme.fontColor),),
  //                   //       Text("${tablesList[index].totalTables.toString()}",
  //                   //           style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: primary) ),
  //                   //       // Container(
  //                   //       //   padding: EdgeInsets.all(10),
  //                   //       //   decoration: BoxDecoration(border: Border.all(color: primary, ),
  //                   //       //       borderRadius: BorderRadius.circular(15)),
  //                   //       //   child: Text(bookingList[index].approxAmount.toString(),
  //                   //       //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: primary) ),
  //                   //       // ),
  //                   //     ],
  //                   //   ),
  //                   // ),
  //
  //                   const SizedBox(height: 10,),
  //                   // Container(
  //                   //   width: MediaQuery.of(context).size.width,
  //                   //   padding: EdgeInsets.all(10),
  //                   //   decoration: BoxDecoration(
  //                   //       color: primary,
  //                   //       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(13), bottomRight: Radius.circular(13))
  //                   //   ),
  //                   //   // child: Row(
  //                   //   //   mainAxisAlignment: MainAxisAlignment.end,
  //                   //   //   children: [
  //                   //   //     Padding(
  //                   //   //       padding: const EdgeInsets.only(right: 10.0),
  //                   //   //       child: Container(
  //                   //   //         padding: EdgeInsets.all(4),
  //                   //   //         decoration: BoxDecoration(
  //                   //   //             color: colors.whiteTemp,
  //                   //   //             borderRadius: BorderRadius.circular(8)
  //                   //   //         ),
  //                   //   //         child: Text("",
  //                   //   //           style: TextStyle(
  //                   //   //               color: primary,
  //                   //   //               fontWeight: FontWeight.w600,
  //                   //   //               fontSize: 16
  //                   //   //           ),),
  //                   //   //       ),
  //                   //   //     ),
  //                   //   //   ],
  //                   //   // ),
  //                   //   // child:
  //                   //   // bookingList[index].bookingStatus.toString() == "1" ?
  //                   //   // Row(
  //                   //   //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                   //   //   children: [
  //                   //   //     ElevatedButton(
  //                   //   //       onPressed: (){
  //                   //   //       // showInformationDialog(context, index, bookingList[index]);
  //                   //   //     }, child: Text("Accept", style: TextStyle(color: primary, fontSize: 16, fontWeight: FontWeight.w600),),
  //                   //   //       style: ElevatedButton.styleFrom(
  //                   //   //           fixedSize: Size(MediaQuery.of(context).size.width/2 - 60, 35),
  //                   //   //           primary: colors.whiteTemp, shape: RoundedRectangleBorder(
  //                   //   //         borderRadius: BorderRadius.circular(10),
  //                   //   //
  //                   //   //       )),
  //                   //   //     ),
  //                   //   //     ElevatedButton(
  //                   //   //       onPressed: (){
  //                   //   //         // showInformationDialog(context, index, bookingList[index]);
  //                   //   //       }, child: Text("Reject", style: TextStyle(color: primary, fontSize: 16, fontWeight: FontWeight.w600),),
  //                   //   //       style: ElevatedButton.styleFrom(
  //                   //   //           fixedSize: Size(MediaQuery.of(context).size.width/2 - 60, 35),
  //                   //   //           primary: colors.whiteTemp, shape: RoundedRectangleBorder(
  //                   //   //         borderRadius: BorderRadius.circular(10),
  //                   //   //
  //                   //   //       )),
  //                   //   //     ),
  //                   //   //   ],
  //                   //   // )
  //                   //   // : SizedBox.shrink(),
  //                   // ),
  //
  //                   // Spacer(),
  //                   // Divider(
  //                   //   thickness: 2,
  //                   //   color: secondary,
  //                   // ),
  //                   // Expanded(
  //                   //   child: Padding(
  //                   //     padding: const EdgeInsets.only(right: 8.0),
  //                   //     child: DropdownButtonFormField(
  //                   //       dropdownColor: colors.whiteTemp,
  //                   //       isDense: true,
  //                   //       iconEnabledColor: primary,
  //                   //       hint: Text(
  //                   //         getTranslated(context, "UpdateStatus")!,
  //                   //         style: Theme.of(this.context)
  //                   //             .textTheme
  //                   //             .subtitle2!
  //                   //             .copyWith(
  //                   //             color: primary,
  //                   //             fontWeight: FontWeight.bold),
  //                   //       ),
  //                   //       decoration: InputDecoration(
  //                   //         filled: true,
  //                   //         isDense: true,
  //                   //         fillColor: colors.whiteTemp,
  //                   //         contentPadding: EdgeInsets.symmetric(
  //                   //             vertical: 10, horizontal: 10),
  //                   //         enabledBorder: OutlineInputBorder(
  //                   //           borderSide: BorderSide(color: primary),
  //                   //         ),
  //                   //       ),
  //                   //       value: orderItem.status,
  //                   //       onChanged: (dynamic newValue) {
  //                   //         setState(
  //                   //               () {
  //                   //             orderItem.curSelected = newValue;
  //                   //             updateOrder(
  //                   //               orderItem.curSelected,
  //                   //               updateOrderItemApi,
  //                   //               model.id,
  //                   //               true,
  //                   //               i,
  //                   //             );
  //                   //           },
  //                   //         );
  //                   //       },
  //                   //       items: statusList.map(
  //                   //             (String st) {
  //                   //           return DropdownMenuItem<String>(
  //                   //             value: st,
  //                   //             child: Text(
  //                   //               capitalize(st),
  //                   //               style: Theme.of(this.context)
  //                   //                   .textTheme
  //                   //                   .subtitle2!
  //                   //                   .copyWith(
  //                   //                   color: primary,
  //                   //                   fontWeight:
  //                   //                   FontWeight.bold),
  //                   //             ),
  //                   //           );
  //                   //         },
  //                   //       ).toList(),
  //                   //     ),
  //                   //   ),
  //                   // ),
  //                   // statusUpdateWidget(index, bookingList[index]),
  //                   // ElevatedButton(onPressed: (){
  //                   //   // showInformationDialog(context, index, bookingList[index]);
  //                   // }, child: Text("Change Status", style: TextStyle(color: Colors.colors.whiteTemp, fontSize: 16, fontWeight: FontWeight.w600),),
  //                   //   style: ElevatedButton.styleFrom(
  //                   //       fixedSize: Size(MediaQuery.of(context).size.width - 60, 50),
  //                   //       primary: primary, shape: RoundedRectangleBorder(
  //                   //     borderRadius: BorderRadius.circular(10),
  //                   //
  //                   //   )),
  //                   // )
  //                   // Container(
  //                   //   width: MediaQuery.of(context).size.width,
  //                   //   height: 60,
  //                   //   child: Row(
  //                   //     children: [
  //                   //       Container(
  //                   //         width: MediaQuery.of(context).size.width/2,
  //                   //         height: 60,
  //                   //         child: DropdownButton(
  //                   //           hint: Text('Select Status'), // Not necessary for Option 1
  //                   //           value: categoryValue,
  //                   //           onChanged: (String? newValue) {
  //                   //             setState(() {
  //                   //               categoryValue = newValue;
  //                   //             });
  //                   //           },
  //                   //           items: leadStatus.map((item) {
  //                   //             return DropdownMenuItem(
  //                   //               child:  Text(item),
  //                   //               value: item,
  //                   //             );
  //                   //           }).toList(),
  //                   //         ),
  //                   //       ),
  //                   //       // Container(
  //                   //       //     padding: EdgeInsets.all(8),
  //                   //       //     decoration: BoxDecoration(
  //                   //       //         color: secondary,
  //                   //       //         borderRadius: BorderRadius.circular(10)
  //                   //       //     ),
  //                   //       //     child: Center(child: Text(bookingList[index].status.toString(), style: TextStyle(fontSize: 14,
  //                   //       //         color: Colors.colors.whiteTemp,
  //                   //       //         fontWeight: FontWeight.w600)))),
  //                   //     ],
  //                   //   ),
  //                   // ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //         Card(
  //           elevation: 4,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(100)
  //           ),
  //           child:  tablesList[index].image != null || tablesList[index].image !='' ?
  //           Container(
  //             height: 100,
  //             width: 100,
  //             decoration: BoxDecoration(
  //               // border: Border.all(color: primary, width: 1),
  //               shape: BoxShape.circle,
  //                 image: DecorationImage(
  //                     image: NetworkImage(tablesList[index].image.toString()),
  //                     fit: BoxFit.fill
  //                 ),
  //                 // borderRadius: BorderRadius.circular(15)
  //             ),
  //             // child: Image.network(tablesList[index].image.toString(), width: 100, height: 100,)
  //           )
  //           : Container(
  //             height: 100,
  //             width: 100,
  //             decoration: BoxDecoration(
  //               shape: BoxShape.circle,
  //               image: DecorationImage(
  //                   image:  AssetImage('assets/images/placeholder.png'),
  //                   fit: BoxFit.fill
  //               ),
  //               // borderRadius: BorderRadius.circular(15)
  //             ),
  //             // child: Image.network(tablesList[index].image.toString(), width: 100, height: 100,)
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget restroCard(int index) {
    return InkWell(
      onTap: (){
        if(restaurantList[index].isDateAvailable == true ) {
          Navigator.push(context, MaterialPageRoute(builder: (context) =>
              RestaurantDetails(id: restaurantList[index].id.toString(),
                data: restaurantList[index],)));
        }
      },
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              Row(
                // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child: restaurantList[index].logo == null ||
                            restaurantList[index].logo ==
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
                            // child: Image.network(restaurantList[index].image.toString(), width: 100, height: 100,)
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
                                      restaurantList[index].logo.toString()),
                                  fit: BoxFit.fill),
                              // borderRadius: BorderRadius.circular(15)
                            ),
                            // child: Image.network(restaurantList[index].image.toString(), width: 100, height: 100,)
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width/2-20,
                            child: Text(restaurantList[index].storeName.toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,  color: Theme.of(context).colorScheme.fontColor)),
                          ),
                          const SizedBox(height: 5,),
                          Container(
                            width: MediaQuery.of(context).size.width/2-20,
                            child: Text(restaurantList[index].address.toString(),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,  color: Theme.of(context).colorScheme.fontColor)),
                          ),
                          const SizedBox(height: 5,),
                          gender == "male" || gender == "Male"?
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width/2-70,
                                // child: Text(restaurantList[index].address.toString(),
                                //     overflow: TextOverflow.ellipsis,
                                //     maxLines: 2,
                                //     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,  color: Theme.of(context).colorScheme.fontColor)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0, right: 5),
                                child: Container(
                                    width: MediaQuery.of(context).size.width/3 - 20,
                                    padding: EdgeInsets.only( top: 4, bottom: 4),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        color: restaurantList[index].isDateAvailable == true ? Colors.green
                                            : Colors.red
                                      //colors.primary
                                    ),
                                    child: Center(
                                        child:
                                        restaurantList[index].isDateAvailable == true ?
                                        BlinkText( title: "Available" )
                                            : Text("Not Available", style: TextStyle(color: colors.whiteTemp, fontWeight: FontWeight.w600) ,))
                                ),
                              ),
                            ],
                          )
                              : SizedBox.shrink(),

                        ],
                      ),
                    ),


                  ]),


            ],
          )),
    );

    //   Container(
    //   // height: 160,
    //   child: Stack(
    //     children: [
    //       // Positioned(
    //       // left: 40,
    //       // top: 30,
    //       // child:
    //       Card(
    //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    //         child: Container(
    //           // height: 280,
    //           width: MediaQuery.of(context).size.width ,
    //           decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(15),
    //               color: colors.whiteTemp,
    //               border: Border.all(color: colors.primary, width: 1)
    //           ),
    //           child: Column(
    //             mainAxisSize: MainAxisSize.min,
    //             children: [
    //               Container(
    //                 padding: EdgeInsets.only(top: 4, bottom: 4, left: 8, right: 8),
    //                 child:  Row(
    //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                   children: [
    //                     Text(restaurantList[index].storeName.toString(),
    //                         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,  color: colors.whiteTemp)),
    //                     Row(
    //                       mainAxisAlignment: MainAxisAlignment.center,
    //                       children: [
    //                         IconButton(
    //                             onPressed: (){
    //                               // Navigator.push(context, MaterialPageRoute(builder: (context)=> EditTable(
    //                               //     data: restaurantList[index]
    //                               // )));
    //                             }, icon: Icon(Icons.edit, color: colors.whiteTemp)),
    //                         IconButton(onPressed: (){
    //                           showDialog(
    //                               context: context,
    //                               barrierDismissible: false,
    //                               builder: (BuildContext context) {
    //                                 return AlertDialog(
    //                                   title: Text("Confirm Delete"),
    //                                   content: Text("Are you sure you want to Delete?"),
    //                                   actions: <Widget>[
    //                                     ElevatedButton(
    //                                       style: ElevatedButton.styleFrom(primary: colors.primary),
    //                                       child: Text("YES", style: TextStyle(color: colors.whiteTemp),),
    //                                       onPressed: () {
    //
    //                                         Navigator.pop(context);
    //                                       },
    //                                     ),
    //                                     ElevatedButton(
    //                                       style: ElevatedButton.styleFrom(primary: colors.primary),
    //                                       child: Text("NO", style: TextStyle(color: colors.whiteTemp),),
    //                                       onPressed: () {
    //                                         Navigator.pop(context);
    //                                       },
    //                                     )
    //                                   ],
    //                                 );
    //                               });
    //                         }, icon: Icon(Icons.delete_forever, color: colors.whiteTemp))
    //                       ],
    //                     )
    //                   ],
    //                 ),
    //                 decoration: BoxDecoration(
    //                     color: colors.primary,
    //                     borderRadius: BorderRadius.only(topRight: Radius.circular(13), topLeft: Radius.circular(13))
    //                 ),
    //               ),
    //               Padding(
    //                 padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
    //                 child: Row(
    //                   mainAxisAlignment: MainAxisAlignment.start,
    //                   crossAxisAlignment: CrossAxisAlignment.center,
    //                   children: [
    //                     restaurantList[index].logo == null || restaurantList[index].logo =='https://developmentalphawizz.com/blind_date/' ?
    //                     Container(
    //                       height: 100,
    //                       width: 100,
    //                       decoration: BoxDecoration(
    //                         shape: BoxShape.circle,
    //                         image: DecorationImage(
    //                             image:  AssetImage('assets/images/placeholder.png'),
    //                             fit: BoxFit.fitHeight
    //                         ),
    //                         // borderRadius: BorderRadius.circular(15)
    //                       ),
    //                       // child: Image.network(restaurantList[index].image.toString(), width: 100, height: 100,)
    //                     )
    //                         : Container(
    //                       height: 100,
    //                       width: 100,
    //                       decoration: BoxDecoration(
    //                         // border: Border.all(color: primary, width: 1),
    //                         // shape: BoxShape.circle,
    //                         borderRadius: BorderRadius.circular(12),
    //                         image: DecorationImage(
    //                             image: NetworkImage(restaurantList[index].logo.toString()),
    //                             fit: BoxFit.fill
    //                         ),
    //                         // borderRadius: BorderRadius.circular(15)
    //                       ),
    //                       // child: Image.network(restaurantList[index].image.toString(), width: 100, height: 100,)
    //                     ),
    //                     const SizedBox(width: 15,),
    //                     Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //
    //                         Padding(
    //                           padding: const EdgeInsets.only(bottom: 5),
    //                           child: Row(
    //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                             children: [
    //                               Text("Booking Amount : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,
    //                                   color: Theme.of(context).colorScheme.fontColor),),
    //                               Text("₹ ${restaurantList[index].address.toString()}",
    //                                   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  color: colors.primary) ),
    //                             ],
    //                           ),
    //                         ),
    //                         Row(
    //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                           children: [
    //                             Text("Total Tables : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color:  Theme.of(context).colorScheme.fontColor),),
    //                             Text("${restaurantList[index].bookingDate.toString()}",
    //                                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  color: colors.primary) ),
    //                           ],
    //                         ),
    //                         Padding(
    //                           padding: const EdgeInsets.only(top: 5.0),
    //                           child: Row(
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                             children: [
    //                               Text("Benefits : ", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color:  Theme.of(context).colorScheme.fontColor),),
    //                               Container(
    //                                 width: MediaQuery.of(context).size.width/2 -50,
    //                                 child: Text("${restaurantList[index].bookingTime.toString()}",
    //                                     maxLines: 2,
    //                                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  color: colors.primary) ),
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                       ],
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //
    //
    //               const SizedBox(height: 10,),
    //               // Container(
    //               //   width: MediaQuery.of(context).size.width,
    //               //   padding: EdgeInsets.all(10),
    //               //   decoration: BoxDecoration(
    //               //       color: primary,
    //               //       borderRadius: BorderRadius.only(bottomLeft: Radius.circular(13), bottomRight: Radius.circular(13))
    //               //   ),
    //               //   // child: Row(
    //               //   //   mainAxisAlignment: MainAxisAlignment.end,
    //               //   //   children: [
    //               //   //     Padding(
    //               //   //       padding: const EdgeInsets.only(right: 10.0),
    //               //   //       child: Container(
    //               //   //         padding: EdgeInsets.all(4),
    //               //   //         decoration: BoxDecoration(
    //               //   //             color: colors.whiteTemp,
    //               //   //             borderRadius: BorderRadius.circular(8)
    //               //   //         ),
    //               //   //         child: Text("",
    //               //   //           style: TextStyle(
    //               //   //               color: primary,
    //               //   //               fontWeight: FontWeight.w600,
    //               //   //               fontSize: 16
    //               //   //           ),),
    //               //   //       ),
    //               //   //     ),
    //               //   //   ],
    //               //   // ),
    //               //   // child:
    //               //   // bookingList[index].bookingStatus.toString() == "1" ?
    //               //   // Row(
    //               //   //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //               //   //   children: [
    //               //   //     ElevatedButton(
    //               //   //       onPressed: (){
    //               //   //       // showInformationDialog(context, index, bookingList[index]);
    //               //   //     }, child: Text("Accept", style: TextStyle(color: primary, fontSize: 16, fontWeight: FontWeight.w600),),
    //               //   //       style: ElevatedButton.styleFrom(
    //               //   //           fixedSize: Size(MediaQuery.of(context).size.width/2 - 60, 35),
    //               //   //           primary: colors.whiteTemp, shape: RoundedRectangleBorder(
    //               //   //         borderRadius: BorderRadius.circular(10),
    //               //   //
    //               //   //       )),
    //               //   //     ),
    //               //   //     ElevatedButton(
    //               //   //       onPressed: (){
    //               //   //         // showInformationDialog(context, index, bookingList[index]);
    //               //   //       }, child: Text("Reject", style: TextStyle(color: primary, fontSize: 16, fontWeight: FontWeight.w600),),
    //               //   //       style: ElevatedButton.styleFrom(
    //               //   //           fixedSize: Size(MediaQuery.of(context).size.width/2 - 60, 35),
    //               //   //           primary: colors.whiteTemp, shape: RoundedRectangleBorder(
    //               //   //         borderRadius: BorderRadius.circular(10),
    //               //   //
    //               //   //       )),
    //               //   //     ),
    //               //   //   ],
    //               //   // )
    //               //   // : SizedBox.shrink(),
    //               // ),
    //
    //               // Spacer(),
    //               // Divider(
    //               //   thickness: 2,
    //               //   color: secondary,
    //               // ),
    //               // Expanded(
    //               //   child: Padding(
    //               //     padding: const EdgeInsets.only(right: 8.0),
    //               //     child: DropdownButtonFormField(
    //               //       dropdownColor: colors.whiteTemp,
    //               //       isDense: true,
    //               //       iconEnabledColor: primary,
    //               //       hint: Text(
    //               //         getTranslated(context, "UpdateStatus")!,
    //               //         style: Theme.of(this.context)
    //               //             .textTheme
    //               //             .subtitle2!
    //               //             .copyWith(
    //               //             color: primary,
    //               //             fontWeight: FontWeight.bold),
    //               //       ),
    //               //       decoration: InputDecoration(
    //               //         filled: true,
    //               //         isDense: true,
    //               //         fillColor: colors.whiteTemp,
    //               //         contentPadding: EdgeInsets.symmetric(
    //               //             vertical: 10, horizontal: 10),
    //               //         enabledBorder: OutlineInputBorder(
    //               //           borderSide: BorderSide(color: primary),
    //               //         ),
    //               //       ),
    //               //       value: orderItem.status,
    //               //       onChanged: (dynamic newValue) {
    //               //         setState(
    //               //               () {
    //               //             orderItem.curSelected = newValue;
    //               //             updateOrder(
    //               //               orderItem.curSelected,
    //               //               updateOrderItemApi,
    //               //               model.id,
    //               //               true,
    //               //               i,
    //               //             );
    //               //           },
    //               //         );
    //               //       },
    //               //       items: statusList.map(
    //               //             (String st) {
    //               //           return DropdownMenuItem<String>(
    //               //             value: st,
    //               //             child: Text(
    //               //               capitalize(st),
    //               //               style: Theme.of(this.context)
    //               //                   .textTheme
    //               //                   .subtitle2!
    //               //                   .copyWith(
    //               //                   color: primary,
    //               //                   fontWeight:
    //               //                   FontWeight.bold),
    //               //             ),
    //               //           );
    //               //         },
    //               //       ).toList(),
    //               //     ),
    //               //   ),
    //               // ),
    //               // statusUpdateWidget(index, bookingList[index]),
    //               // ElevatedButton(onPressed: (){
    //               //   // showInformationDialog(context, index, bookingList[index]);
    //               // }, child: Text("Change Status", style: TextStyle(color: Colors.colors.whiteTemp, fontSize: 16, fontWeight: FontWeight.w600),),
    //               //   style: ElevatedButton.styleFrom(
    //               //       fixedSize: Size(MediaQuery.of(context).size.width - 60, 50),
    //               //       primary: primary, shape: RoundedRectangleBorder(
    //               //     borderRadius: BorderRadius.circular(10),
    //               //
    //               //   )),
    //               // )
    //               // Container(
    //               //   width: MediaQuery.of(context).size.width,
    //               //   height: 60,
    //               //   child: Row(
    //               //     children: [
    //               //       Container(
    //               //         width: MediaQuery.of(context).size.width/2,
    //               //         height: 60,
    //               //         child: DropdownButton(
    //               //           hint: Text('Select Status'), // Not necessary for Option 1
    //               //           value: categoryValue,
    //               //           onChanged: (String? newValue) {
    //               //             setState(() {
    //               //               categoryValue = newValue;
    //               //             });
    //               //           },
    //               //           items: leadStatus.map((item) {
    //               //             return DropdownMenuItem(
    //               //               child:  Text(item),
    //               //               value: item,
    //               //             );
    //               //           }).toList(),
    //               //         ),
    //               //       ),
    //               //       // Container(
    //               //       //     padding: EdgeInsets.all(8),
    //               //       //     decoration: BoxDecoration(
    //               //       //         color: secondary,
    //               //       //         borderRadius: BorderRadius.circular(10)
    //               //       //     ),
    //               //       //     child: Center(child: Text(bookingList[index].status.toString(), style: TextStyle(fontSize: 14,
    //               //       //         color: Colors.colors.whiteTemp,
    //               //       //         fontWeight: FontWeight.w600)))),
    //               //     ],
    //               //   ),
    //               // ),
    //             ],
    //           ),
    //         ),
    //       ),
    //       // ),
    //       // Card(
    //       //   elevation: 4,
    //       //   shape: RoundedRectangleBorder(
    //       //       borderRadius: BorderRadius.circular(100)
    //       //   ),
    //       //   child:  tablesList[index].image != null || tablesList[index].image !='' ?
    //       //   Container(
    //       //     height: 100,
    //       //     width: 100,
    //       //     decoration: BoxDecoration(
    //       //       // border: Border.all(color: primary, width: 1),
    //       //       shape: BoxShape.circle,
    //       //       image: DecorationImage(
    //       //           image: NetworkImage(tablesList[index].image.toString()),
    //       //           fit: BoxFit.fill
    //       //       ),
    //       //       // borderRadius: BorderRadius.circular(15)
    //       //     ),
    //       //     // child: Image.network(tablesList[index].image.toString(), width: 100, height: 100,)
    //       //   )
    //       //       : Container(
    //       //     height: 100,
    //       //     width: 100,
    //       //     decoration: BoxDecoration(
    //       //       shape: BoxShape.circle,
    //       //       image: DecorationImage(
    //       //           image:  AssetImage('assets/images/placeholder.png'),
    //       //           fit: BoxFit.fill
    //       //       ),
    //       //       // borderRadius: BorderRadius.circular(15)
    //       //     ),
    //       //     // child: Image.network(tablesList[index].image.toString(), width: 100, height: 100,)
    //       //   ),
    //       // )
    //     ],
    //   ),
    // );
  }

  @override
  void initState() {
    super.initState();
    getRestaurants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: PreferredSize(
        //   preferredSize: Size.fromHeight(80),
        //   child: AppBar(
        //     centerTitle: true,
        //     title: Image.asset('assets/images/homelogo.png', height: 60,),
        //     backgroundColor: colors.primary,
        //     leading: IconButton(
        //       onPressed: (){
        //         Navigator.pop(context);
        //       },
        //       icon: Icon(Icons.arrow_back_ios, color: colors.whiteTemp,),
        //     ),
        //     actions: [
        //       Padding(
        //         padding: const EdgeInsets.all(8.0),
        //         child: InkWell(
        //           onTap: () async {
        //             // var result = await Navigator.push(context, MaterialPageRoute(builder: (context)=> AddTable()));
        //             // if(result != null){
        //             //   getRestroTables();
        //             // }
        //           },
        //           child: Container(
        //             padding: EdgeInsets.all(8),
        //             decoration: BoxDecoration(
        //                 border: Border.all(color: colors.whiteTemp),
        //                 borderRadius: BorderRadius.circular(30)
        //             ),
        //             child: Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 Text("Add Table ", style: TextStyle(
        //                     color: colors.whiteTemp,
        //                     fontWeight: FontWeight.w600,
        //                     fontSize: 16
        //                 ),),
        //                 Icon(Icons.add_box, color: colors.whiteTemp,)
        //               ],
        //             ),
        //           ),
        //         ),
        //       ),
        //
        //       // SizedBox(
        //       //   height: 30,
        //       //   child: Container(
        //       //     height: 30,
        //       //     width: 100,
        //       //     decoration: BoxDecoration(
        //       //       color: Colors.colors.whiteTemp, borderRadius: BorderRadius.circular(20)
        //       //     ),
        //       //     child: Center(
        //       //       child: Row(
        //       //         mainAxisAlignment: MainAxisAlignment.center,
        //       //         children: [
        //       //           Text("Add Table", style: TextStyle(
        //       //             color: primary
        //       //           ),),
        //       //           Icon(Icons.add_box, color: primary,)
        //       //         ],
        //       //       ),
        //       //     ),
        //       //   ),
        //       // )
        //
        //     ],
        //   ),
        // ),
        body: bodyWidget());
  }
}
