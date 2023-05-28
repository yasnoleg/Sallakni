import 'dart:async'; 
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:medical_app/Classes/TheTimer.dart';
import 'package:medical_app/Classes/hiveLocal_DB.dart';
import 'package:medical_app/Classes/locationServices.dart';
import 'package:medical_app/Classes/providers/city_provider.dart';
import 'package:medical_app/Classes/tools.dart';
import 'package:medical_app/Pages/searchpage.dart';
import 'package:medical_app/Pages/timer/timer_widget.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart' as LT;

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {

  //DEFAULT GOOGLE MAPS SETTINGS
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  
  CustomInfoWindowController _custominfowindowController = CustomInfoWindowController();
  //--------------------------------------------------------

  //MY SETTINGS + VARS
  double _latitude = 0;
  double _longitude = 0;
  late LocationData _locatioDT;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor repairIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor hotelIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor taxiIcon = BitmapDescriptor.defaultMarker;
  final user = FirebaseAuth.instance.currentUser;
  int display = 1;
  int displayTimer = 0;
  int key = 0;

  //LISTS
  List<String> serviceId = [];
  Map services = {};
  final doctorsCollection = FirebaseFirestore.instance.collection('doctor');
  Set<Marker> markers = <Marker>{};
  List<LatLng> polylineCoordinates = [];


  //LINK WITH LOCATION SERVICE
  LocationService locationservice = LocationService();
  HiveDB hiveDB = HiveDB();
  Couleur couleur = Couleur();
  TimerController timerController = TimerController();

  //DATE / TIME
  DateTime date = DateTime.now();

  //--------------------------------------------------------


  //MAP
  Map<String, dynamic> UserMap = {};

  //CURRENT USER TO READ USER INFORMATION
  final Instance = FirebaseFirestore.instance;

  //FUNCTIONS
  GetUserMap() {
    //1
    print(UserMap);
    if(UserMap.isEmpty){
      Instance.collection('user').doc('${user!.email}').get().then((value) {
        setState(() {
          UserMap = value.data()!;
          hiveDB.usermap = UserMap;
          hiveDB.UpdateUserMapData();
        });
      });
      print(UserMap);
      if(UserMap.isEmpty){
        Instance.collection('repair').doc('${user!.email}').get().then((value) {
          setState(() {
            UserMap = value.data()!;
            hiveDB.usermap = UserMap;
            hiveDB.UpdateUserMapData();
          });
        });
        print(UserMap);
        if(UserMap.isEmpty){
          Instance.collection('repair').doc('${user!.email}').get().then((value) {
            setState(() {
              UserMap = value.data()!;
              hiveDB.usermap = UserMap;
              hiveDB.UpdateUserMapData();
            });
          });
          print(UserMap);
        }
      }
    }
  }


  @override
  void initState() {
    addCustomIcon();
    if(hiveDB.bx.get("usermap") == null){
      hiveDB.InitUserMapData();
    }else{
      hiveDB.LoadUserMapData();
    }
    Future.delayed(Duration(seconds: 1), () {
      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
          contentPadding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
          title: Text('Loading your location please wait!',style: StyleText,),
          content: Container(
            width: 250.0,
            height: 100.0,
            child: LT.Lottie.asset("asset/animations/loading_data.json"),
            ),
          );
        }
      );
    });
    Future.delayed(Duration(seconds: 2), () {
      if (hiveDB.usermap['locality'] == null) {
        FindUserLocation();
      }    
      GetUserMap();
    });
    Future.delayed(Duration(seconds: 5), () {
      Navigator.of(context).pop();
    });
    super.initState();
  }


  void addCustomIcon() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty, 'asset/icons/position.png').then(
        (icon) {
          setState(() {
            markerIcon = icon;
          });
        });
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty, 'asset/icons/repair_location.png').then(
        (icon) {
          setState(() {
            repairIcon = icon;
          });
        });
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty, 'asset/icons/hotel.png').then(
        (icon) {
          setState(() {
            hotelIcon = icon;
          });
        });
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty, 'asset/icons/taxi_location.png').then(
        (icon) {
          setState(() {
            taxiIcon = icon;
          });
        });
  }

  void FindUserLocation() async {
    _locatioDT = await locationservice.GetUserLocation();
    setState(() {
      _latitude = _locatioDT.latitude!;
      _longitude = _locatioDT.longitude!;
    });
    FirebaseFirestore.instance.collection(hiveDB.usermap['type']).doc('${user!.email}').update({
      'latitude': _latitude,
      'longitude': _longitude,
    });
    final GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          bearing: 0,
          target: LatLng(_latitude, _longitude),
          tilt: 0,
          zoom: 20
        ),
      )
    );
    getCityStreetOfUser();
    markers.add(Marker(markerId: MarkerId('user_position'),icon: markerIcon,position: LatLng(_latitude, _longitude)));
  }

  void SearchNearServiceOnUserLocation(String type, String locality) {
    markers.clear();
    services.clear();
    _custominfowindowController.hideInfoWindow!();
    FirebaseFirestore.instance.collection(type).where("locality" , isEqualTo: locality ).where("type", isEqualTo: type)
      .snapshots().listen((event) { event.docs.asMap().forEach((key, value) { 
        services.addAll({key:value.data()});
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            markers.add(
              Marker(
                markerId: MarkerId("repaire$key"),
                position: LatLng(services[key]["latitude"], services[key]["longitude"]),
                icon: type == "repair" ? repairIcon : type == "taxi" ? taxiIcon : type == "hotel" ? hotelIcon : markerIcon,
                onTap: () {
                  CreateCustomInfoWindow(services[key], key);
                },
              ),
            );
          });
        } );
      });
    });
  }

  void CreateCustomInfoWindow(Map<dynamic, dynamic> child, int Key) {
    _custominfowindowController.addInfoWindow!(
      Container(
        padding: const EdgeInsets.only(),
        height: 200,
        width: 200,
        decoration: BoxDecoration(
          color: couleur.White,
          borderRadius: BorderRadius.circular(10),
        ),
        child: child['type'] == 'taxi' || child['type'] == 'repair' ? Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('${child['firstname']} ${child['lastname']}',style: MidTextStyle,),
                  Text('${child['type']}, ${child['locality']}',style: SmallTextStyle,),
                ],
              ),
            ),
            Expanded(child: GestureDetector(
              onTap: () {
                setState(() {
                  display = 0;
                  key = Key;
                });
                _custominfowindowController.hideInfoWindow!();
              },
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10)),
                  color: couleur.Black,
                ),
                child: Icon(Icons.arrow_forward_ios_outlined,color: couleur.White,),
              ),
            )),
          ],
        ) : child['type'] == 'hotel' || child['hospital'] ? Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('${child['name']}, ${child['country']}',style: MidTextStyle,),
                  Text('${child['type']}, ${child['locality']}',style: SmallTextStyle,),
                ],
              ),
            ),
            Expanded(child: GestureDetector(
              onTap: () {
                setState(() {
                  display = 0;
                  key = Key;
                });
                _custominfowindowController.hideInfoWindow!();
              },
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10)),
                  color: couleur.Black,
                ),
                child: Icon(Icons.arrow_forward_ios_outlined,color: couleur.White,),
              ),
            )),
          ],
        ) : Container(),
      ),
      LatLng(child["latitude"], child["longitude"]),
    );
  }

  void CreateDemande(String name, String type, DateTime date) {
    FirebaseFirestore.instance.collection('user').doc('${user!.email}').collection('demande').doc('${type}_${date.day}_${date.month}').set({
      'name': name,
      'type': type,
      'date': '${date.day}/${date.month}/${date.year}',
      'state': 'waiting',
    });
  }

  void SendToService(String name, String type, DateTime date, String locality, String clientPhonenumber, String clientEmail){
    FirebaseFirestore.instance.collection(type).doc('${services[key]['email']}').collection('demande').doc('${type}_${date.day}_${date.month}').set({
      'name': name,
      'type': type,
      'date': '${date.day}/${date.month}/${date.year}',
      'locality': locality,
      'clientEmail': clientEmail,
      'clientNumber': clientPhonenumber,
      'latitude': hiveDB.usermap['latitude'],
      'longitude': hiveDB.usermap['longitude'],
      'state': 'waiting',
    });
  }

  @override
  Widget build(BuildContext context) {
    //HIGHT / WIDTH
    double hight = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: const CameraPosition(
              target: LatLng(35.7917887, 0.6840489),
              zoom: 18,
            ),
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            markers: markers,
            onMapCreated: (GoogleMapController controller) {
              _custominfowindowController.googleMapController = controller;
              _controller.complete(controller);
            },
            onTap: (argument) {
              _custominfowindowController.hideInfoWindow!();
            },
            onCameraMove: (position) {
              _custominfowindowController.onCameraMove!();
            },
          ),

          CustomInfoWindow(
          height: 75,
          width: 190,
          controller: _custominfowindowController),

          //BUTTON TO DISPLAY USER LOCATION
          Align(
            alignment: Alignment(1, -0.8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () async {
                  FindUserLocation();
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: couleur.White,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(Icons.location_on_outlined),
                ),
              ),
            ),
          ),

          //BUTTON TO GO BACK
          display == 0 ? Align(
            alignment: Alignment(-1, -0.8),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    display = 1;
                    displayTimer = 0;
                  });
                  CreateCustomInfoWindow(services[key], key);
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: couleur.White,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(Icons.arrow_back),
                ),
              ),
            ),
          ) : Container() ,
        
          //SEARCH FOR SERVICE
          display == 1 ? hiveDB.usermap['type'] == 'user' ? Align(
            alignment: const Alignment(0, 0.9),
            child: Padding(
              padding: EdgeInsets.only(right: hight*0.01,left: hight*0.01),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: hight*0.01,bottom: hight*0.01,right: width*0.03,left: width*0.03),
                      height: hight*0.22,
                      decoration: BoxDecoration(
                        color: couleur.White,
                        borderRadius: BorderRadius.circular(hight*0.02),
                        boxShadow: [
                          BoxShadow(
                            color: couleur.Grey.withOpacity(0.4),
                            spreadRadius: 0.5,
                            blurRadius: 3.2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('  Search for near repair on your location ',style: LableTextStyle,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(child: Text(hiveDB.usermap['locality'] == null ? '  Get your location first! ' : ' ${hiveDB.usermap['locality']}' ,style: StyleText,)),
                              IconButton(onPressed: () {
                                  SearchNearServiceOnUserLocation("repair", hiveDB.usermap['locality']);
                                }, 
                                icon: Icon(Icons.location_on_outlined,color: couleur.Black,)),
                            ],
                          ),
                          Divider(),
                          Text('  Search for near repair by city ',style: LableTextStyle,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => SearchPage(username: hiveDB.usermap['username'], Search: () { SearchNearServiceOnUserLocation(context.read<CityProvider>().cityType, context.read<CityProvider>().cityName); },)),
                                  );
                                }, child: Text('Search for city',style: StyleText,)),
                              Expanded(child: SizedBox()),
                              IconButton(onPressed: () { }, icon: Icon(Icons.search,color: couleur.Black,)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ) : Container() : services[key]['type'] == 'taxi' || services[key]['type'] == 'repair' ? Align(
            alignment: const Alignment(0, 1),
            child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: hight*0.01,bottom: hight*0.01,right: width*0.03,left: width*0.03),
                      height: hight*0.22,
                      decoration: BoxDecoration(
                        color: couleur.White,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(hight*0.02),topRight: Radius.circular(hight*0.02)),
                        boxShadow: [
                          BoxShadow(
                            color: couleur.Grey.withOpacity(0.4),
                            spreadRadius: 0.5,
                            blurRadius: 3.2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('${services[key]['firstname']} ${services[key]['lastname']}',style: StyleText,),
                                  Text('${services[key]['locality']}',style: SmallTextStyle,),
                                ],
                              ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${services[key]['type']}',style: SmallTextStyle,),
                                Text('${services[key]['phonenumber']}',style: SmallTextStyle,),
                              ],
                            ),
                            Image.asset(services[key]['type'] == 'taxi' ? 'asset/icons/taxi_icon.png' : services[key]['type'] == 'repair' ? 'asset/icons/icons8-camping-car-64.png' : services[key]['type'] == 'hopital' ? 'asset/icons/hôpital_icon.png' : 'asset/icons/hôtel_icon.png'),
                            ],
                          ),
                          Divider(),
                          displayTimer == 0 ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(hight*0.01),
                                  child: GestureDetector(
                                    onTap: () {
                                      var snackBar = SnackBar(
                                        elevation: 0,
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        dismissDirection: DismissDirection.startToEnd,
                                        content: AwesomeSnackbarContent(
                                          title: 'Well Done',
                                          message: 'Now , wait for your services!',
                                          contentType: ContentType.success,
                                        ),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      setState(() {
                                        displayTimer = 1;
                                      });
                                      CreateDemande(services[key]['firstname'],services[key]['type'],date);
                                      SendToService(hiveDB.usermap['firstname'],services[key]['type'],date,hiveDB.usermap['locality'],hiveDB.usermap['phonenumber'],hiveDB.usermap['email']);
                                     },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: hight*0.055,
                                      decoration: BoxDecoration(
                                        color: couleur.Black,
                                        borderRadius: BorderRadius.circular(hight*0.008),
                                      ),
                                      child: Text('Start your direction',style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2,
                                          fontFamily: 'text',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ) : Padding(
                            padding: EdgeInsets.only(top: hight*0.03),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('3000 DZD',style: StyleText),
                                Text('Check your historical', style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  fontFamily: 'text',
                                  color: couleur.LightRed,
                                ),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ) : Align(
            alignment: const Alignment(0, 1),
            child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.only(top: hight*0.01,bottom: hight*0.01,right: width*0.03,left: width*0.03),
                      height: hight*0.22,
                      decoration: BoxDecoration(
                        color: couleur.White,
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(hight*0.02),topRight: Radius.circular(hight*0.02)),
                        boxShadow: [
                          BoxShadow(
                            color: couleur.Grey.withOpacity(0.4),
                            spreadRadius: 0.5,
                            blurRadius: 3.2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('${services[key]['name']}, ${services[key]['country']}',style: StyleText,),
                                  Text('${services[key]['locality']}',style: SmallTextStyle,),
                                ],
                              ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${services[key]['type']}',style: SmallTextStyle,),
                                Text('${services[key]['phonenumber']}',style: SmallTextStyle,),
                              ],
                            ),
                            Image.asset(services[key]['type'] == 'hospital' ? 'asset/icons/hôpital_icon.png' : 'asset/icons/hôtel_icon.png'),
                            ],
                          ),
                          Divider(),
                          displayTimer == 0 ? Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(hight*0.01),
                                  child: GestureDetector(
                                    onTap: () {
                                      var snackBar = SnackBar(
                                        elevation: 0,
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.transparent,
                                        dismissDirection: DismissDirection.startToEnd,
                                        content: AwesomeSnackbarContent(
                                          title: 'Well Done',
                                          message: 'Now , wait for your services!',
                                          contentType: ContentType.success,
                                        ),
                                      );
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      setState(() {
                                        displayTimer = 1;
                                      });
                                      CreateDemande(services[key]['firstname'],services[key]['type'],date);
                                      SendToService(hiveDB.usermap['firstname'],services[key]['type'],date,hiveDB.usermap['locality'],hiveDB.usermap['phonenumber'],hiveDB.usermap['email']);
                                     },
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: hight*0.055,
                                      decoration: BoxDecoration(
                                        color: couleur.Black,
                                        borderRadius: BorderRadius.circular(hight*0.008),
                                      ),
                                      child: Text('Start your direction',style: TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 2,
                                          fontFamily: 'text',
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ) : Padding(
                            padding: EdgeInsets.only(top: hight*0.03),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('3000 DZD',style: StyleText),
                                Text('Check your historical', style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2,
                                  fontFamily: 'text',
                                  color: couleur.LightRed,
                                ),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ]
      ),
    );
  }

  getCityStreetOfUser() async {
    List<Placemark> placemark = await placemarkFromCoordinates(_latitude, _longitude);
    FirebaseFirestore.instance.collection(hiveDB.usermap['type']).doc('${user!.email}').update({
      'country': placemark[0].country,
      'street': placemark[0].street,
      'postalcode': placemark[0].postalCode,
      'administrativeArea': placemark[0].administrativeArea,
      'locality': placemark[0].locality,
      'name': placemark[0].name,
      'subAdministrativeArea': placemark[0].subAdministrativeArea,
    });
    hiveDB.usermap = {
      'country': placemark[0].country,
      'street': placemark[0].street,
      'postalcode': placemark[0].postalCode,
      'administrativeArea': placemark[0].administrativeArea,
      'locality': placemark[0].locality,
      'name': placemark[0].name,
      'subAdministrativeArea': placemark[0].subAdministrativeArea,
    };
    hiveDB.UpdateUserMapData();
  }
}

