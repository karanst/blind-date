import 'dart:convert';
import 'dart:io';
import 'package:blind_date/Helper/Session.dart';
import 'package:blind_date/Screen/bottom_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:blind_date/Helper/Color.dart';
import 'package:blind_date/Helper/String.dart';
import 'package:blind_date/Screen/NewScreens/location_details.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({Key? key}) : super(key: key);

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  int? _value3 = 1;
  String gender = 'Male';
  int currentIndex = 0;
  RangeValues _currentRangeValues = const RangeValues(18, 50);

  List _selectedItems = [];
  List selectedCategoryItems = [];
  String? selectCatItems;

  LocationPermission? permission;
  Position? currentLocation;
  double? lat, long;
  String? currentAddress;



  Future getUserCurrentLocation() async {
    permission = await Geolocator.requestPermission();
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((position) {
      if (mounted)
        setState(() {
          currentLocation = position;
          lat = currentLocation!.latitude;
          long = currentLocation!.longitude;
        });
    });
    print("LOCATION===" + currentLocation.toString());
  }

  void getCurrentAddress() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    currentAddress =
        '${placemark.street}, ${placemark.subLocality},${placemark.locality}, ${placemark.country}';
    // print(currentAddress);
  }

  ///MULTI IMAGE PICKER
  ///
  ///
  ///
  var imagePathList;
  bool isImages = false;


  List<File> selectedImages = []; // List of selected image
  final picker = ImagePicker();

  Future getImages() async {
    final pickedFile = await picker.pickMultiImage(
        imageQuality: 100, // To set quality of images
        maxHeight: 1000, // To set maxheight of images that you want in your app
        maxWidth: 1000); // To set maxheight of images that you want in your app
    List<XFile> xfilePick = pickedFile;

    // if atleast 1 images is selected it will add
    // all images in selectedImages
    // variable so that we can easily show them in UI
    if (xfilePick.isNotEmpty) {
      for (var i = 0; i < xfilePick.length; i++) {
        selectedImages.add(File(xfilePick[i].path));
      }
      setState(
            () {  },
      );
    } else {
      // If no image is selected it will show a
      // snackbar saying nothing is selected
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nothing is selected')));
    }

  }
  Future<void> getFromGallery() async {

    var result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        isImages = true;
        // servicePic = File(result.files.single.path.toString());
      });
      imagePathList = result.paths.toList();
      // imagePathList.add(result.paths.toString()).toList();
      print("SERVICE PIC === ${imagePathList.length}");
    } else {
      // User canceled the picker
    }
  }
  Widget uploadMultiImage() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          InkWell(
              onTap: () async {
                getImages();
                // getFromGallery();
                // await pickImages();
              },
              child: Container(
                  height: 40,
                  width: 150,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: colors.primary),
                  child: Center(
                      child: Text(
                        "Upload Pictures",
                        style: TextStyle(color: colors.whiteTemp),
                      )))),

          const SizedBox(
            height: 20,
          ),
          Container(
            height: MediaQuery.of(context).size.width,
            width: MediaQuery.of(context).size.width, // To show images in particular area only
            child: selectedImages.isEmpty  // If no images is selected
                ? const Center(child: Text('Sorry nothing selected!!'))
            // If atleast 1 images is selected
                : GridView.builder(
              itemCount: selectedImages.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3
                // Horizontally only 3 images will show
              ),
              itemBuilder: (BuildContext context, int index) {
                // TO show selected file
                return Padding(
                  padding: const EdgeInsets.only(left: 5.0, bottom: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(selectedImages[index]),
                        fit: BoxFit.fill
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: colors.primary)
                    ),
                  )    // child: Image.file(selectedImages[index])),
                );
                // If you are making the web app then you have to
                // use image provider as network image or in
                // android or iOS it will as file only
              },
            ),
          ),
          // Visibility(
          //     visible: isImages,
          //     child: imagePathList != null ? buildGridView() : SizedBox.shrink()
          // )

        ],
      ),
    );
  }
  Widget buildGridView() {
    return Container(
      height: MediaQuery.of(context).size.height/2 - 35 ,
      child:
      GridView.builder(
        itemCount: imagePathList.length,
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Stack(
            children: [
              Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(17),
                      border: Border.all(color: colors.primary, width: 2)
                    ),
                    width: MediaQuery.of(context).size.width/2-20,
                    height: MediaQuery.of(context).size.height/2-20,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: Image.file(File(imagePathList[index]),
                          fit: BoxFit.cover),
                    ),
                  )),
              Positioned(
                top: 5,
                right: 10,
                child: InkWell(
                  onTap: (){
                    setState((){
                      imagePathList.remove(imagePathList[index]);
                    });

                  },
                  child: Icon(
                    Icons.remove_circle,
                    size: 30,
                    color: Colors.red.withOpacity(0.7),),
                ),
              )
            ],
          );
        },
      ),
    );
  }
  ///MULTI IMAGE PICKER
  ///
  ///

  getAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(MediaQuery.of(context).size.width, 100),
      child: AppBar(
        leading: Icon(
          Icons.arrow_back_ios,
          color: colors.primary,
        ),
        centerTitle: true,
        title: Image.asset(
          'assets/images/homelogo.png',
          height: 60,
        ),
        backgroundColor: colors.primary,
        iconTheme: IconThemeData(color: colors.whiteTemp),
        // actions: [
        //   InkWell(
        //     onTap: (){
        //       // Navigator.push(context, MaterialPageRoute(builder: (context)=> WalletHistory()));
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
    );
  }

  ///STEP 1
  chooseGenderWidget() {
    return Expanded(
      child: Column(
        children: [
          Text(
            "Choose who you want to date?",
            style: TextStyle(
                color: Theme.of(context).colorScheme.fontColor,
                fontWeight: FontWeight.w600,
                fontSize: 20),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30, top: 30),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/boy.png', height: 50, width: 50,),
                    const SizedBox(width: 2,),
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
                      style: TextStyle(color: colors.primary, fontSize: 16),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/girl.png', height: 50, width: 50,),
                    const SizedBox(width: 2,),
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
                      style: TextStyle(color: colors.primary, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  currentIndex = 1;
                });
              },
              child: Text(
                "Next",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(MediaQuery.of(context).size.width / 2, 45),
                primary: colors.primary,
                shape: StadiumBorder(),
              ),
            ),
          )
        ],
      ),
    );
  }
  ///STEP 2
  chooseAgeGroupWidget() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 10),
        child: Column(
          children: [
            Text(
              "Select the age of the partner with whom they want to go on the date with?",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.fontColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
            ),
            const SizedBox(
              height: 20,
            ),
            RangeSlider(
              values: _currentRangeValues,
              max: 70,
              min: 18,
              divisions: 52,
              labels: RangeLabels(
                _currentRangeValues.start.round().toString(),
                _currentRangeValues.end.round().toString(),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _currentRangeValues = values;
                });
                print("this is current range values ${_currentRangeValues.start.toString()}");
              },
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0,  right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentIndex = 0;
                      });
                    },
                    child: Text(
                      "Previous",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width / 2 - 30, 45),
                      primary: colors.primary,
                      shape: StadiumBorder(),
                    ),
                  ),

                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        currentIndex = 2;
                      });
                    },
                    child: Text(
                      "Next",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    style: ElevatedButton.styleFrom(
                      fixedSize: Size(MediaQuery.of(context).size.width / 2 - 30, 45),
                      primary: colors.primary,
                      shape: StadiumBorder(),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
  ///STEP 3
    List languages = ['Hindi', 'English', 'Marathi', 'Gujarati'];

    void _itemChange( itemValue, bool isSelected) {
      setState(() {
        if (isSelected) {
          _selectedItems.add(itemValue);
        } else {
          _selectedItems.remove(itemValue);
        }
      });
      print("this is selected values ${_selectedItems.toString()}");
    }
  chooseLanguageWidget() {
    return Expanded(
      child: Column(
        children: [
          Text(
            "Select languages you know?",
            style: TextStyle(
                color: Theme.of(context).colorScheme.fontColor,
                fontWeight: FontWeight.w600,
                fontSize: 18),
          ),
          ListBody(
            children: languages
                .map((item) =>
            // InkWell(
            //   onTap: (){
            //     setState(() {
            //       if (isChecked) {
            //         setState(() {
            //           _selectedItems.add(item);
            //         });
            //         print("length of item list ${_selectedItems.length}");
            //         for (var i = 0; i < _selectedItems.length; i++) {
            //           print("ok now final  ${_selectedItems[i]
            //               .id} and  ${_selectedItems[i].cName}");
            //         }
            //       }
            //       else {
            //         setState(() {
            //           _selectedItems.remove(item);
            //         });
            //         print("ok now data ${_selectedItems}");
            //       }
            //     });
            //
            //   },
            //   child: Row(
            //     children: [
            //       Container(
            //         height: 40,
            //         width: 40,
            //         decoration: BoxDecoration(
            //           color: AppColor().colorBg1(),
            //           border: Border.all(
            //             color: isChecked ? colors.primary : AppColor().colorTextSecondary()
            //           ),
            //           borderRadius: BorderRadius.circular(5)
            //         ),
            //         child: Icon(
            //           Icons.check,
            //         ),
            //       ),
            //       Text(item.cName!)
            //     ],
            //   ),
            // )
            CheckboxListTile(
              activeColor: colors.primary,
              value: _selectedItems.contains(item),
              title: Text(item, style: TextStyle(
                color: Theme.of(context).colorScheme.fontColor
              ),),
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (isChecked) => _itemChange(item, isChecked!),
              // onChanged: (isChecked) {
              //   setState(() {
              //     if (!isChecked! && _selectedItems.contains(item.id)) {
              //       setState(() {
              //         _selectedItems.remove(item);
              //       });
              //       print("ok now data ${_selectedItems}");
              //     }
              //     else {
              //       setState(() {
              //         _selectedItems.add(item);
              //       });
              //       print("length of item list ${_selectedItems.length}");
              //       for (var i = 0; i < _selectedItems.length; i++) {
              //         print("ok now final  ${_selectedItems[i]
              //             .id} and  ${_selectedItems[i].cName}");
              //       }
              //     }
              //   });
              // },
            )
            ).toList(),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0, left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentIndex = 0;
                    });
                  },
                  child: Text(
                    "Previous",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width / 2 - 30, 45),
                    primary: colors.primary,
                    shape: StadiumBorder(),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if(_selectedItems.isNotEmpty) {
                      setState(() {
                        currentIndex = 2;
                      });
                    }else{
                      Fluttertoast.showToast(msg: "Please select languages!");
                      // setSnackbar("Please select languages!", context);
                    }
                  },
                  child: Text(
                    "Next",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width / 2 - 30, 45),
                    primary: colors.primary,
                    shape: StadiumBorder(),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
  ///STEP 4
  chooseMultiImage() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Select best images of yours?",
            style: TextStyle(
                color: Theme.of(context).colorScheme.fontColor,
                fontWeight: FontWeight.w600,
                fontSize: 18),
          ),
          uploadMultiImage(),
          Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 40.0, left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentIndex = 1;
                    });
                  },
                  child: Text(
                    "Previous",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width / 2 - 30, 45),
                    primary: colors.primary,
                    shape: StadiumBorder(),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if(selectedImages.length < 2) {
                     setSnackbar("Please select atleast two images!", context);
                    }else{
                      updateUserData();
                    }
                    // setState(() {
                    //   currentIndex = 3;
                    // });
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(MediaQuery.of(context).size.width / 2 - 30, 45),
                    primary: colors.primary,
                    shape: StadiumBorder(),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  updateUserData() async {

    var headers = {
      'Cookie': 'ci_session=aa83f4f9d3335df625437992bb79565d0973f564'
    };
    var request =
    http.MultipartRequest('POST', Uri.parse(completeProfileApi.toString()));

    request.fields.addAll({
      'who_you_want_to_date': gender.toString(),
      'latitude': lat.toString(),
      'longitude': long.toString(),
      'address': currentAddress.toString(),
      'languages':_selectedItems.toString(),
      'age_group_from': _currentRangeValues.start.toString(),
      'age_group_to': _currentRangeValues.end.toString(),
      'id': CUR_USERID.toString()
    });

    if(selectedImages.isNotEmpty) {
      for (var i = 0; i < selectedImages.length; i++) {
        selectedImages == null
            ? null
            : request.files.add(await http.MultipartFile.fromPath(
            'images[]', selectedImages[i].path));
      }
    }

    print(
        "this is complete profile request ====>>>> ${request.fields.toString()} and ${request.files.toString()}");
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
        // id = i[ID];
        // username = i[USERNAME];
        // email = i[EMAIL];
        // mobile = i[MOBILE];
        // city = i[CITY];
        // area = i[AREA];
        // address = i[ADDRESS];
        // pincode = i[PINCODE];
        // latitude = i[LATITUDE];
        // longitude = i[LONGITUDE];
        // image = i[IMAGE];
        // gender=i['gender'];
        //
        // CUR_USERID = id;
        // // CUR_USERNAME = username;
        //
        // UserProvider userProvider =
        // Provider.of<UserProvider>(this.context, listen: false);
        // userProvider.setName(username ?? "");
        // userProvider.setEmail(email ?? "");
        // userProvider.setProfilePic(image ?? "");
        // userProvider.setGender(gender ?? "");
        //
        // SettingProvider settingProvider =
        // Provider.of<SettingProvider>(context, listen: false);
        //
        // settingProvider.setPrefrenceBool(ISFIRSTTIME, true);
        //
        // settingProvider.saveUserDetail(id!, username, email, mobile,
        //     gender, city, area, address, pincode, latitude, longitude, image, context);
        //
        // setPrefrenceBool(isLogin, true);

        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Dashboard1()));
      } else {
        setSnackbar(msg, context);
      }
    } else {
      print(response.reasonPhrase);
    }
  }

  headerWidget(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentIndex == 0 ?
                   colors.primary
                  :  colors.primary.withOpacity(0.5)

          ),
        ),
        Container(
          width: 20,
          child: Divider(
            thickness: 2,
            color: currentIndex == 0 ?
            colors.primary
            : colors.primary.withOpacity(0.5),
          ),
        ),

        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentIndex == 0 && currentIndex == 1?
              colors.primary
                  : colors.primary.withOpacity(0.5)

          ),
        ),
        Container(
          width: 20,
          child: Divider(
            thickness: 2,
            color: currentIndex == 0 && currentIndex == 1?
            colors.primary
                : colors.primary.withOpacity(0.5),
          ),
        ),

        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentIndex == 0 && currentIndex == 1 && currentIndex == 2?
              colors.primary
                  : colors.primary.withOpacity(0.5)

          ),
        ),
        Container(
          width: 20,
          child: Divider(
            thickness: 2,
            color: currentIndex == 0 && currentIndex == 1 && currentIndex == 2?
            colors.primary
                : colors.primary.withOpacity(0.5),
          ),
        ),

        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentIndex == 0 && currentIndex == 1 && currentIndex == 2 && currentIndex == 3?
              colors.primary
                  : colors.primary.withOpacity(0.5)

          ),
        ),

    ],);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     getUserCurrentLocation();
    getCurrentAddress();
    // Future.delayed(Duration(seconds: 1), (){
    //   _getAddressFromLatLng();
    // });
    //  getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(
            height: 40,
          ),
          // headerWidget(),
          currentIndex == 0 ? chooseGenderWidget() : SizedBox.shrink(),
          // currentIndex == 1 ? chooseAgeGroupWidget() : SizedBox.shrink(),
          currentIndex == 1 ? chooseLanguageWidget() : SizedBox.shrink(),
          currentIndex == 2 ?  chooseMultiImage() : SizedBox.shrink(),
          const SizedBox(height: 20,)

        ],
      ),
    );
  }
}


// class MultiSelect extends StatefulWidget {
//   MultiSelect({Key? key}) : super(key: key);
//
//   @override
//   State<StatefulWidget> createState() => _MultiSelectState();
//
// }
//
//
// class _MultiSelectState extends State<MultiSelect> {
//   List _selectedItems = [];
//   // this variable holds the selected items
//
//   // List<CityData> cityList = [];
//   // List<Categories> eventCat = [];
//   List languages = ['Hindi', 'English', 'Marathi', 'Gujarati'];
//
//   void _itemChange( itemValue, bool isSelected) {
//     setState(() {
//       if (isSelected) {
//         _selectedItems.add(itemValue);
//       } else {
//         _selectedItems.remove(itemValue);
//       }
//     });
//     print("this is selected values ${_selectedItems.toString()}");
//   }
//
//   void _cancel() {
//     Navigator.pop(context);
//   }
//
//
//   void _submit() {
//     List selectedItem = _selectedItems.map((item) => item.id).toList();
//
//     Navigator.pop(context);
//   }
//
//   bool isChecked = false;
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // _getEventCategory();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       child: ListBody(
//         children: languages
//             .map((item) =>
//         CheckboxListTile(
//           activeColor: colors.primary,
//           value: _selectedItems.contains(item),
//           title: Text(item),
//           controlAffinity: ListTileControlAffinity.leading,
//           onChanged: (isChecked) => _itemChange(item, isChecked!),
//         )
//         ).toList(),
//       ),
//     );
//
//   }
// }