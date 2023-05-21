import 'package:flutter/material.dart';

class CityProvider with ChangeNotifier {

  String _cityName = '';
  String _cityType = '';

  //Get 
  String get cityName => _cityName;
  String get cityType => _cityType;

  //functions
  void readData(String name, String type){
    _cityName = name;
    _cityType = type;
    notifyListeners();
  }
}