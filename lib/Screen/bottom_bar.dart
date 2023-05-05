
import 'dart:convert';

import 'package:blind_date/Helper/Color.dart';
import 'package:blind_date/Helper/Session.dart';
import 'package:blind_date/Screen/HomePage.dart';
import 'package:blind_date/Screen/MyProfile.dart';
import 'package:blind_date/Screen/my_restaurants.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard1 extends StatefulWidget {
  final String? type, bookingId;
  final int? index;
  const Dashboard1({Key? key, this.type, this.bookingId, this.index}) : super(key: key);

  @override
  State<Dashboard1> createState() => _Dashboard1State();
}

class _Dashboard1State extends State<Dashboard1> {

  var _selBottom = 0;
  

  @override
  void initState() {
    if(widget.index != null){
      setState(() {
        currentIndex = widget.index!;
      });
    }
    // getUserDataFromPrefs();
    super.initState();
    // getUserDataFromPrefs();
  }
  String? type ;


  // getUserDataFromPrefs() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   // String? userDataStr =
  //   // preferences.getString(SharedPreferencesKey.LOGGED_IN_USERRDATA);
  //   type = preferences.getString(TokenString.type);
  //   // Map<String, dynamic> userData = json.decode(userDataStr!);
  //   // print(userData);
  //
  //   setState(() {
  //     // userID = userData['user_id'];
  //   });
  // }

  int currentIndex = 1;
  bool isLoading = false;



  Widget _getBottomNavigatorDelivery() {
    return SafeArea(
      bottom: true,
      child: Material(
        color: Theme.of(context).colorScheme.background,
        //elevation: 2,
        child: CurvedNavigationBar(
          index: currentIndex,
          animationCurve: Curves.easeIn,
          height: 50,
          backgroundColor: Colors.white.withOpacity(0.9),
          buttonBackgroundColor: colors.primary,
          // backgroundColor: Color(0xfff4f4f4),
          items: <Widget>[


            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ImageIcon(
                AssetImage(
                    currentIndex == 0?
                    'assets/icons/restaurants-fill.png'
                        : 'assets/icons/restaurants-unfill.png'),
                color:   currentIndex == 0 ? colors.whiteTemp
                : colors.primary,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ImageIcon(
                AssetImage(
                    currentIndex == 1 ?
                    'assets/icons/home-fill.png'
                        : 'assets/icons/home-unfill.png'),
                color:  currentIndex == 1 ? colors.whiteTemp
                : colors.primary,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ImageIcon(
                AssetImage(
                    currentIndex == 2 ?
                    'assets/icons/Profile-fill.png'
                        : 'assets/icons/Profile-unfill.png'),
                color:   currentIndex == 2 ? colors.whiteTemp
                : colors.primary,
              ),
            ),

          ],
          onTap: (index) {
            print("current index here ${index}");
            setState(() {
              currentIndex = index;
              _selBottom = currentIndex;
              print("sel bottom ${_selBottom}");
              //_pageController.jumpToPage(index);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> _handlePagesDelivery = [
       MyRestaurants(),HomePage(), MyProfile()
    ];
    return
      WillPopScope(
          onWillPop: () async {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Confirm Exit"),
                    content: Text("Are you sure you want to exit?"),
                    actions: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: colors.primary
                        ),
                        child: Text("YES"),
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: colors.primary
                        ),
                        child: Text("NO"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                }
            );
            return true;
          },
          child:
          Scaffold(
            appBar: getAppBar("", context),
              body:
              // type == "2" || type == "3" || type == "4" ?
              _handlePagesDelivery[currentIndex],
              // : _handlePages[_currentIndex],
              bottomNavigationBar:
              // type == "2" || type == "3" || type == "4" ?
              _getBottomNavigatorDelivery()
          )
      );
  }
}
