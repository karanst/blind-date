import 'dart:async';
import 'dart:convert';
import 'package:blind_date/Model/restaurant_model.dart';
import 'package:http/http.dart' as http;
import 'package:blind_date/Helper/AppBtn.dart';
import 'package:blind_date/Helper/Color.dart';
import 'package:blind_date/Helper/Session.dart';
import 'package:blind_date/Helper/String.dart';
import 'package:flutter/material.dart';

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

  getRestaurantTable() async {
    var headers = {
      'Cookie': 'ci_session=aa83f4f9d3335df625437992bb79565d0973f564'
    };
    var request =
    http.MultipartRequest('POST', Uri.parse(getRestroListApi.toString()));
    request.fields.addAll({
      'user_type': 'female',
      'id': widget.id.toString()
    });

    print("this is restro request ${request.fields.toString()}");
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
              children: [
                Text(widget.data!.storeName.toString(), style: TextStyle(
                    color: colors.primary, fontSize: 20, fontWeight: FontWeight.w600
                ),),
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
        // Navigator.push(context, MaterialPageRoute(builder: (context) => RestaurantDetails(id: restaurantList[index].id.toString())));
      },
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.end,
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 30.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width/2-20,
                        child: Text(tablesList[index].name.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,  color: colors.blackTemp)),
                      ),
                      const SizedBox(height: 5,),
                      Container(
                        width: MediaQuery.of(context).size.width/2-20,
                        child: Text(tablesList[index].benifits.toString(),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,  color: Theme.of(context).colorScheme.fontColor)),
                      ),


                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60.0, right: 5),
                  child: Container(
                    padding: EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40),
                        color: colors.primary
                    ),
                    child: Center(
                      child: Text('₹ ${tablesList[index].price.toString()}', style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 14, color: colors.whiteTemp
                      ),),
                    ),
                  ),
                )

              ])),
    );

  }

  @override
  void initState() {
    super.initState();
    getRestaurantTable();
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
