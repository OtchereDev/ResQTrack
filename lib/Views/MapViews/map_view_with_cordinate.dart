import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/Provider/Location/location_provider.dart';
import 'package:resq_track/Provider/Map/map_provider.dart';

class MapScreenWidthCordinate extends StatefulWidget {
  final LatLng? latLng;
  const MapScreenWidthCordinate({super.key, this.latLng});

  @override
  State<MapScreenWidthCordinate> createState() => _MapScreenWidthCordinateState();
}

class _MapScreenWidthCordinateState extends State<MapScreenWidthCordinate> {
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    // Call the provider to fetch route data
    if (widget.latLng != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // Initialize the map with the route
        Provider.of<MapProvider>(context, listen: false)
            .fetchPolylinePoints(context, latitude: widget.latLng!.latitude, longitude: widget.latLng!.longitude)
            .then((coordinates) {
          if (coordinates != null) {
            // Generate polyline from the fetched coordinates
            Provider.of<MapProvider>(context, listen: false).generatePolyLineFromPoints(coordinates);
          }
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(
      builder: (context, mapProvider, child) {
      var current=  Provider.of<LocationProvider>(context, listen: false);
        if (widget.latLng == null) {
          return Center(child: CircularProgressIndicator());
        }

        final LatLng currentLocation = LatLng(
          current.currentPosition!.latitude,
          current.currentPosition!.longitude,
        );

        // Move the camera to the user's current location whenever it updates
        if (mapController != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            mapController?.animateCamera(
              CameraUpdate.newLatLng(currentLocation),
            );
          });
        }

        return GoogleMap(
          myLocationButtonEnabled: false,
          initialCameraPosition: CameraPosition(
            target: currentLocation,
            zoom: 17,
          ),
          markers: {
            Marker(
              markerId: MarkerId('currentLocation'),
              position: currentLocation,
            ),
          },
          polylines: Set<Polyline>.of(mapProvider.polylines.values), // Show polyline on the map
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
        );
      },
    );
  }
}
