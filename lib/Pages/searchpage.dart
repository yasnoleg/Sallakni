import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:medical_app/Classes/locationServices.dart';
import 'package:medical_app/Classes/location_controller.dart';
import 'package:medical_app/Classes/network_utility.dart';
import 'package:medical_app/Classes/providers/city_provider.dart';
import 'package:medical_app/Classes/tools.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
//import 'package:google_maps_webservice/src/places.dart';
import 'package:medical_app/Pages/locatin_search_dialogue.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  String username;
  VoidCallback Search;
  SearchPage({super.key,required this.username, required this.Search});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  //link 
  Couleur couleur = Couleur();

  //TEXTEDITOR
  TextEditingController searchcontroller = TextEditingController();
  late GoogleMapController _mapController;

  //Variables
  String type = 'repair';
  int displayspace = 0;
  String name = '';

  //DATE
  TimeOfDay time = TimeOfDay.now();
  DateTime date = DateTime.now();

  //function //WHEN YOU ABLE GOOGLE MAP BILLING 
  void placeAutocomplate(String query) async {
    Uri uri = Uri.https(
      "maps.googleapis.com",
      'maps/api/place/autocomplete/json',
      {
        "input": query,
        "key": 'AIzaSyDBT15Ja6KBtdtUDcW_PMfGmAjNT_Qeygc',
      });
    String? response = await NetworkUtility.fetchUrl(uri);

    if (response != null) {
      print(response);
    }
  }//-----------------------------------------

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: couleur.White,
      appBar: AppBar(centerTitle: true,title: const Text("Over search",style: TitleStyle,),backgroundColor: couleur.White,elevation: 0,leading: IconButton(onPressed: () {Navigator.pop(context);}, icon: Icon(Icons.arrow_back,color: couleur.Black,))),
      body: Padding(
        padding: EdgeInsets.only(left: width*0.02,right: width*0.02,top: height*0.01,bottom: height*0.01),
        child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Enter the name of the city",style: LableTextStyle,),
                  SizedBox(height: height*0.01,),
                  Expanded(
                    flex: 0,
                    child: TextField(
                      controller: searchcontroller,
                      onChanged: (value) {
                        setState(() {
                          name = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: "Search by city",
                        hintStyle: LableTextStyle,
                        contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 12 ),
                        filled: true,
                        fillColor: couleur.Grey.withOpacity(0.2),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height*0.02,),
                  Text("Choose what you want to search for it",style: LableTextStyle,),
                  SizedBox(height: height*0.01,),
                  Expanded(
                    flex: 0,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: width*0.02,right: width*0.01),
                            height: height*0.07,
                            decoration: BoxDecoration(
                              color: couleur.Grey.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(height*0.015)
                            ),
                            child: DropdownButton<String>(
                              style: LableTextStyle,
                              borderRadius: BorderRadius.circular(height*0.015),
                              elevation: 4,
                              isExpanded: true,
                              underline: Container(),
                              value: type,
                              items: <String>['repair', 'taxi', 'hotel', 'hospitol']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          value,
                                          style: TextStyle(fontSize: height*0.023),
                                        ),
                                      ),
                                      Expanded(child: Image.asset(value == 'repair' ? 'asset/icons/repair_location.png' : value == 'taxi' ? 'asset/icons/taxi_location.png' : value == 'hotel' ? 'asset/icons/hotel.png' : 'asset/icons/position.png' ,height: height*0.04,))
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  type = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height*0.03,),
                  Row(
                    children: [
                      GestureDetector(onTap: () {
                      },child: Icon(Icons.calendar_month_outlined,size: height*0.027,)),
                      Text("  ${date.year}/${date.month}/${date.day}",style: SmallTextStyle,),
                      Expanded(child: SizedBox(width: 0.01,)),
                      Icon(Icons.watch_later_outlined,size: height*0.027,),
                      Text("  ${time.hour}:${time.minute}",style: SmallTextStyle,),
                      Expanded(child: SizedBox(width: 0.01,)),
                      Icon(Icons.account_circle_outlined,size: height*0.027,),
                      SizedBox(width: 1.5,),
                      Container(height: height*0.02,width: width*0.02,decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.green),),
                      Text(" ${widget.username}",style: SmallTextStyle,),
                    ],
                  ),
                  SizedBox(height: height*0.02,),
                  const Divider(),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance.collection("city_location").snapshots(),
                      builder: (context, snapshot) {
                        return (snapshot.connectionState == ConnectionState.waiting)
                            ? Center(child: CircularProgressIndicator())
                            : ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot data = snapshot.data!.docs[index];
                                  if(searchcontroller.text.isEmpty){
                                    return GestureDetector(
                                      onTap: () {
                                        Provider.of<CityProvider>(context, listen: false).readData(data.id.toString(), type);
                                        widget.Search();
                                        Navigator.of(context).pop();
                                      },
                                      child: ListTile(
                                        leading: Icon(Icons.location_on_outlined,color: couleur.Black,),
                                        title: Text('${data.id}',style: StyleText,),
                                      ),
                                    );
                                  }
                                  if (data.id.toString().contains(searchcontroller.text.toLowerCase()) || data.id.toString() == name || data.id.toString().startsWith(name[0].toUpperCase())) {
                                    return GestureDetector(
                                      onTap: () {
                                        Provider.of<CityProvider>(context, listen: false).readData(data.id.toString(), type);
                                        widget.Search();
                                        Navigator.of(context).pop();
                                      },
                                      child: ListTile(
                                        leading: Icon(Icons.location_on_outlined,color: couleur.Black,),
                                        title: Text('${data.id}',style: StyleText,),
                                      ),
                                    );
                                  }
                                  return Container();
                                },
                              );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
