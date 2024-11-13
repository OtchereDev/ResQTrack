import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/Core/app_constants.dart';
import 'package:resq_track/Provider/Location/location_provider.dart';

class MapProvider with ChangeNotifier {
  Map<PolylineId, Polyline> _polylines = {};
  Map<PolylineId, Polyline>get polylines =>_polylines;

  BitmapDescriptor? ambulanceIcon;
  BitmapDescriptor? hospitalIcon;

  Future<void> initializeMap(BuildContext context) async {
    await loadCustomIcons();
  }

  Future<void> loadCustomIcons() async {
    ambulanceIcon = await _createCustomMarkerImage('assets/images/ambulance.png', 100);
    hospitalIcon = await _createCustomMarkerImage('assets/images/hospital.png', 100);
    notifyListeners();
  }

  Future<BitmapDescriptor> _createCustomMarkerImage(String path, int width) async {
    final ByteData data = await rootBundle.load(path);
    final ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    final ui.FrameInfo fi = await codec.getNextFrame();
    final ByteData? byteData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List resizedImageData = byteData!.buffer.asUint8List();
    return BitmapDescriptor.fromBytes(resizedImageData);
  }

  Future<List<LatLng>?> fetchPolylinePoints(BuildContext context, {required double latitude, required double longitude}) async {
    var locationProvider = Provider.of<LocationProvider>(context, listen: false);

    if (locationProvider.currentPosition != null) {
      final String url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=5.632262,-0.15229&destination=5.6311426997256495,-0.15700468372677176&mode=driving&departure_time=now&key=AIzaSyDDG9vbTjy9bmYNRZjiJqCGiGBpXAkDzwI';

      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if ((data['routes'] as List).isNotEmpty) {
          final String polylineString = data['routes'][0]['overview_polyline']['points'];
          final List<LatLng> polylineCoordinates = _decodePolyline(polylineString);
          return polylineCoordinates;
        } else {
          debugPrint('No routes found');
          return [];
        }
      } else {
        debugPrint('Error fetching directions: ${response.statusCode}');
        return [];
      }
    }
    return null;
  }

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

    _polylines[id] = polyline;
    notifyListeners();
  }
}
