import 'package:blind_date/Helper/Color.dart';
import 'package:flutter/material.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({Key? key}) : super(key: key);

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {

  int? _value3 = 1;
  String gender = 'Male';
  int currentIndex = 0 ;

  chooseGenderWidget(){
    return Expanded(
      child: Column(
        children: [
          Text("Choose who you want to date?",
            style: TextStyle(color: Theme.of(context).colorScheme.fontColor),),
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
                        fillColor: MaterialStateColor.resolveWith((states) => colors.primary),
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
                        fillColor: MaterialStateColor.resolveWith((states) => colors.primary),
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
              ],
            ),
          ),
            Spacer(),
          ElevatedButton(onPressed: (){
            setState(() {
              currentIndex = 1;
            });
          }, child: Text("Next"), style: ElevatedButton.styleFrom(primary: colors.primary, shape: StadiumBorder()),)
        ],
      ),
    );
  }

  chooseAgeGroupWidget(){
    return Expanded(
      child: Column(
        children: [
          Text("select the age of the partner with whom they want to go on the date with?",
            style: TextStyle(color: Theme.of(context).colorScheme.fontColor),),
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
                        fillColor: MaterialStateColor.resolveWith((states) => colors.primary),
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
                        fillColor: MaterialStateColor.resolveWith((states) => colors.primary),
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
                        fillColor: MaterialStateColor.resolveWith((states) => colors.primary),
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
          Spacer(),
          ElevatedButton(onPressed: (){
            setState(() {
              currentIndex = 2;
            });
          }, child: Text("Next"), style: ElevatedButton.styleFrom(primary: colors.primary, shape: StadiumBorder()),)
        ],
      ),
    );
  }

  chooseLanguageWidget(){
    return Expanded(
      child: Column(
        children: [
          Text("Select languages you know?",
            style: TextStyle(color: Theme.of(context).colorScheme.fontColor),),
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
                        fillColor: MaterialStateColor.resolveWith((states) => colors.primary),
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
                        fillColor: MaterialStateColor.resolveWith((states) => colors.primary),
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
              ],
            ),
          ),
          Spacer(),
          ElevatedButton(onPressed: (){
            setState(() {
              currentIndex= 1;
            });
          }, child: Text("Next"), style: ElevatedButton.styleFrom(primary: colors.primary, shape: StadiumBorder()),)
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 40,),
          currentIndex == 0 ?
          chooseGenderWidget()
          : SizedBox.shrink(),

          currentIndex == 1?
          chooseAgeGroupWidget()
              : SizedBox.shrink(),

          currentIndex == 2?
          chooseLanguageWidget()
              : SizedBox.shrink(),


        ],
      ),
    );
  }
}
