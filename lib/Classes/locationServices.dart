import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class LocationService {
  LocationService();
  GetUserLocation() async {
    
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    double __latit;

    //GET PERMISSION TO READ LOCATION OF USER
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    //--------------------------------------------------------

    //READ USER LOCATION 
    _locationData = await location.getLocation();
    //--------------------------------------------------------

    return _locationData;
  }

}

// For storing our result
class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

  Future<http.Response> getLocationData(String text) async {
    http.Response response;

      response = await http.get(
        Uri.parse("http://mvs.bslmeiyu.com/api/v1/config/place-api-autocomplete?search_text=$text"),
          headers: {"Content-Type": "application/json"},);

    print(jsonDecode(response.body));
    return response;
  }