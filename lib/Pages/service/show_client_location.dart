import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ShowClientLocation extends StatefulWidget {
  double latitudeClient;
  double latitude;
  double longitudeClient;
  double longitude;
  ShowClientLocation({super.key,required this.latitudeClient, required this.longitudeClient, required this.latitude, required this.longitude});

  @override
  State<ShowClientLocation> createState() => _ShowClientLocationState();
}

class _ShowClientLocationState extends State<ShowClientLocation> {
  
  //DEFAULT GOOGLE MAPS SETTINGS
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  BitmapDescriptor clientIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty, 'asset/icons/position.png').then(
        (icon) {
          setState(() {
            markerIcon = icon;
          });
        });
    BitmapDescriptor.fromAssetImage(
      ImageConfiguration.empty, 'asset/icons/location.png').then(
        (icon) {
          setState(() {
            clientIcon = icon;
          });
        });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children :[
          SizedBox(
            height: 400,
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: const CameraPosition(
                target: LatLng(35.7917887, 0.6840489),
                zoom: 18,
              ),
              zoomControlsEnabled: true,
              zoomGesturesEnabled: true,
              onMapCreated: (controller) {
                _controller.complete(controller);
              },
              markers: {
                Marker(markerId: MarkerId('Client'),position: LatLng(widget.latitudeClient, widget.longitudeClient),icon: clientIcon,infoWindow: InfoWindow(title: 'Client Location')),
                Marker(markerId: MarkerId('Client'),position: LatLng(widget.latitude, widget.longitude),icon: markerIcon,infoWindow: InfoWindow(title: 'Your Location')),
              },
            ),
          ),
          Align(
            alignment: Alignment(1, 0.9),
            child: IconButton(
              onPressed: () async {
                final GoogleMapController controller = await _controller.future;
                    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                      bearing: 0,
                      target: LatLng(widget.latitude, widget.longitude),
                      tilt: 0,
                      zoom: 17
                    ),
                  )
                );
              }, 
              icon: Icon(Icons.near_me_outlined),
            ),
          ),
          Align(
            alignment: Alignment(-1, 0.8),
            child: IconButton(
              onPressed: () async {
                final GoogleMapController controller = await _controller.future;
                    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                      bearing: 0,
                      target: LatLng(widget.latitudeClient, widget.longitudeClient),
                      tilt: 0,
                      zoom: 17
                    ),
                  )
                );
              },  
              icon: Icon(Icons.location_on_outlined),
            ),
          ),
        ]
      ),
    );
  }
}