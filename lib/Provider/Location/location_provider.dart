import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:resq_track/Model/Request/emergency_m.dart';
import 'package:resq_track/Utils/Dialogs/notifications.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;

class LocationProvider with ChangeNotifier {
  String _locationMessage = "Loading...";
  String get locationMessage => _locationMessage;
  Map<String, dynamic> _latLong = {"lat": 0.0, "lng": 0.0};
  Map<String, dynamic> get latLong => _latLong;
  Map<PolylineId, Polyline> polylines = {};


  StreamSubscription<Position>? _positionStreamSubscription;

  Position? _currentPosition;

  Position? get currentPosition => _currentPosition;

  String _country = "";
  String get country => _country;



  // Start listening to location changes
  void startLocationUpdates(context) {
    _positionStreamSubscription = Geolocator.getPositionStream(
            locationSettings: Platform.isIOS
                ? AppleSettings(
                    accuracy: LocationAccuracy.high,
                    distanceFilter: 20, // meters
                  )
                : AndroidSettings(
                    accuracy: LocationAccuracy.high,
                    distanceFilter: 20, // meters
                  ))
        .listen((Position position) {
      _currentPosition = position;
      // print("-------$_currentPosition---------------");
      NotificationUtils.showToast(context,message: _currentPosition?.latitude.toString() ??"N/A");
      notifyListeners();
    });
  }

   // Stop listening to location changes
  void stopLocationUpdates() {
    _positionStreamSubscription?.cancel();
  }


   // Dispose the stream subscription
  @override
  void dispose() {
    stopLocationUpdates();
    super.dispose();
  }


  Future<void> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _locationMessage = "Location services are disabled.";
      notifyListeners();
      return;
    }
    debugPrint("------------$serviceEnabled-------------");


    // Request permission if not already granted.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _locationMessage = "Location permissions are denied.";
        notifyListeners();
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _locationMessage =
          "Location permissions are permanently denied, we cannot request permissions.";
      notifyListeners();
      return;
    }

    debugPrint("------------$serviceEnabled--------$permission-----");


    // Get the current position.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Convert the coordinates to an address.
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      _latLong = {"lat": position.latitude, "lng": position.longitude};

      Placemark place = placemarks[0];
      _locationMessage = "${place.locality}, ${place.country}";
      _country = place.country ?? "";
    } catch (e) {
      _locationMessage = "Failed to get location name.";
    }

    notifyListeners();
  }





  //   Future<List<LatLng>?> fetchPolylinePoints() async {
  //   if (_currentPosition != null) {
  //     final String url =
  //         'https://maps.googleapis.com/maps/api/directions/json?origin=${_currentPosition!.latitude},${_currentPosition!.longitude}&destination=${_destinationLoc.latitude},${_destinationLoc.longitude}&key=$kGoogleApiKey';

  //     final response = await http.get(Uri.parse(url));
  //  print("=================${_currentPosition!.latitude},${_currentPosition!.longitude}&destination=${_destinationLoc.latitude},${_destinationLoc.longitude}==============");
  //     if (response.statusCode == 200) {
  //       final Map<String, dynamic> data = json.decode(response.body);
     

  //       if ((data['routes'] as List).isNotEmpty) {
  //         final String polylineString = data['routes'][0]['overview_polyline']['points'];
  //         final List<LatLng> polylineCoordinates = _decodePolyline(polylineString);
  //         return polylineCoordinates;
  //       } else {
  //         debugPrint('No routes found');
  //         return [];
  //       }
  //     } else {
  //       debugPrint('Error fetching directions: ${response.statusCode}');
  //       return [];
  //     }
  //   }
  // }

  List<LatLng> _decodePolyline(String encoded) {
    List<LatLng> polyline = [];
    int index = 0, len = encoded.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int b, shift = 0, result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lat += dlat;

      shift = 0;
      result = 0;
      do {
        b = encoded.codeUnitAt(index++) - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
      lng += dlng;

      LatLng position = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
      polyline.add(position);
    }

    return polyline;
  }

  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) {
    const id = PolylineId('polyline');

    final polyline = Polyline(
      polylineId: id,
      color: Colors.blueAccent,
      points: polylineCoordinates,
      width: 5,
    );

    polylines[id] = polyline;
    notifyListeners();
  }
}

