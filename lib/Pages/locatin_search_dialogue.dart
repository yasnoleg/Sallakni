import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:medical_app/Classes/locationServices.dart';
import 'package:medical_app/Classes/location_controller.dart';
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
import 'package:google_maps_webservice/src/places.dart';

class LocationSearchDialogue extends StatefulWidget {
  final GoogleMapController? mapController;
  LocationSearchDialogue({super.key, required this.mapController});

  @override
  State<LocationSearchDialogue> createState() => _LocationSearchDialogueState();
}

class _LocationSearchDialogueState extends State<LocationSearchDialogue> {

  TextEditingController searchcontroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(0),
        child: placesAutoCompleteTextField(),
        
        //TypeAheadField(
        //  textFieldConfiguration: TextFieldConfiguration(
        //    controller: searchcontroller,
        //    decoration: InputDecoration(
        //      hintText: "Search by city",
        //      hintStyle: LableTextStyle,
        //      contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 12 ),
        //      filled: true,
        //      fillColor: Colors.grey.withOpacity(0.2),
        //      border: OutlineInputBorder(
        //        borderSide: BorderSide.none,
        //        borderRadius: BorderRadius.all(Radius.circular(15)),
        //      ),
        //    ),
        //  ), 
        //  suggestionsCallback: (pattern) async {
        //    return await Get.find<LocationController>().searchLocation(context, pattern);
        //  },
        //  itemBuilder: (context, Prediction suggestion) {
        //    return Padding(
        //      padding: EdgeInsets.all(10),
        //      child: Row(children: [
        //        Icon(Icons.location_on),
        //        Expanded(
        //          child: Text(suggestion.description!, maxLines: 1, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.headline2?.copyWith(
        //            color: Theme.of(context).textTheme.bodyText1?.color, fontSize: 20,
        //          )),
        //        ),
        //      ]),
        //    );
        //  },
        //  onSuggestionSelected: (Prediction suggestion) {
        //    print("My location is "+suggestion.description!);
        //    //Get.find<LocationController>().setLocation(suggestion.placeId!, suggestion.description!, mapController);
        //    Get.back();
        //  },
        //),
      ),
    );
  }

  placesAutoCompleteTextField() {
    return Container();
  }
}