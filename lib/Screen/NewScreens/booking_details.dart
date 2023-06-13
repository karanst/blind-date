
import 'dart:convert';

import 'package:blind_date/Helper/Color.dart';
import 'package:blind_date/Helper/String.dart';
import 'package:blind_date/Model/my_bookings_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;


class BookingDetails extends StatefulWidget {
  Bookings? data;
   BookingDetails({Key? key, this.data}) : super(key: key);

  @override
  State<BookingDetails> createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {

  double rating = 0.0;
  TextEditingController reviewController = TextEditingController();

  Widget bookingDetails(){
    String status = 'Waiting';
    if(widget.data?.status.toString() == "0"){
      status = 'Waiting';
    }else if(widget.data?.status.toString() == "1"){
      status = 'Processing';
    }else if(widget.data?.status.toString() == "2"){
      status = 'Accepted';
    }else if(widget.data?.status.toString() == "3"){
      status = 'Rejected';
    }else{
      status = 'Completed';
    }
    return Padding(
      padding: const EdgeInsets.all(15.0),
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
                  Text('${widget.data?.bookingDate.toString()}',
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
                  Text('${widget.data!.bookingTime.toString()}',
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
                  Text('${widget.data!.id.toString()}',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  color: colors.primary)),

                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                    child: Text('${widget.data!.storeName.toString()}',
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  color: colors.primary)),
                  ),

                  Text('${widget.data!.tableName.toString()}',
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
                  child: Text("₹ ${widget.data!.approxAmount.toString()}",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,  color: colors.whiteTemp)),

                ),
              )
            ],
          ),

        ],
      ),
    );
  }

  Widget reviewRating(){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        children: [
          Center(
            child: RatingBar(
              initialRating: rating,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 36,
              ratingWidget: RatingWidget(
                full: Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                half: Icon(
                  Icons.star_half_rounded,
                  color: Colors.amber,
                ),
                empty: Icon(
                  Icons.star_border_rounded,
                  color: Colors.amber,
                ),
              ),
              itemPadding: EdgeInsets.zero,
              onRatingUpdate: (rating1) {
                print(rating1);
                setState(() {
                  rating = rating1;
                });
              },
            ),
          ),
          const SizedBox(height: 10,),
          TextField(
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            controller: reviewController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              hintText: "Review your experience with restaurant"
            ),
          ),
          const SizedBox(height: 10,),
          ElevatedButton(
            onPressed: (){
            rateReviewRestaurant();
          }, child: Text("Submit"), style: ElevatedButton.styleFrom(
            backgroundColor: colors.primary,
            shape: StadiumBorder(),
            fixedSize: Size(250, 40)
          ),)
        ],
      ),
    );
  }

  rateReviewRestaurant() async {
    var headers = {
      'Cookie': 'ci_session=aa83f4f9d3335df625437992bb79565d0973f564'
    };
    var request =
    http.MultipartRequest('POST', Uri.parse(rateReviewApi.toString()));
    request.fields.addAll({
      'user_id' : CUR_USERID.toString(),
      'restaurant_id': widget.data!.resId.toString(),
      'rating' : rating.toStringAsFixed(1),
      'review': reviewController.text.toString()
    });

    print("this is restaurant review request ${request.fields.toString()}");
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      String str = await response.stream.bytesToString();
      var result = json.decode(str);
      Fluttertoast.showToast(msg: result['message']);
      Navigator.pop(context);
      // var finalResponse = RestaurantModel.fromJson(result);
      // setState(() {
      //   tablesList = finalResponse.data![0].tables!;
      //   _isLoading = false;
      // });
      // print("this is referral data ${tablesList.length}");
    } else {
      print(response.reasonPhrase);
    }
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
      body: Column(
        children: [
          bookingDetails(),
          widget.data?.status == "4" ?
          reviewRating() :
              SizedBox.shrink()


        ],
      ),
    );
  }
}
