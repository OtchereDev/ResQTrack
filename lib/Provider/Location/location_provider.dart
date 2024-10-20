import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:resq_track/Utils/Dialogs/notifications.dart';

class LocationProvider with ChangeNotifier {
  String _locationMessage = "Loading...";
  String get locationMessage => _locationMessage;
  Map<String, dynamic> _latLong = {"lat": "", "lng": ""};
  Map<String, dynamic> get latLong => _latLong;

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
}
