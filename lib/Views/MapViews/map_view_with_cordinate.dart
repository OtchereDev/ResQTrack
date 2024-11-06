import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/Core/Helpers/navigation_helper.dart';
import 'package:resq_track/Provider/Location/location_provider.dart';
import 'package:resq_track/Provider/Map/map_provider.dart';
import 'package:resq_track/Provider/Responder/responder_provider.dart';
import 'package:resq_track/Responder/Home/responder_index_page.dart';
import 'package:resq_track/Widgets/custom_buttom.dart';

import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

class MapScreenWidthCordinate extends StatefulWidget {
  final LatLng? latLng;
  final bool showButton;
  const MapScreenWidthCordinate(
      {super.key, this.latLng, required this.showButton});

  @override
  State<MapScreenWidthCordinate> createState() =>
      _MapScreenWidthCordinateState();
}

class _MapScreenWidthCordinateState extends State<MapScreenWidthCordinate> {
  GoogleMapController? mapController;
  BitmapDescriptor? currentLocationIcon;
  BitmapDescriptor? destinationIcon;

  @override
  void initState() {
    super.initState();
    _loadCustomIcons();
    // Call the provider to fetch route data
    if (mounted) {
      if (widget.latLng != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Initialize the map with the route
          Provider.of<MapProvider>(context, listen: false)
              .fetchPolylinePoints(context,
                  latitude: widget.latLng!.latitude,
                  longitude: widget.latLng!.longitude)
              .then((coordinates) {
            if (coordinates != null) {
              // Generate polyline from the fetched coordinates
              Provider.of<MapProvider>(context, listen: false)
                  .generatePolyLineFromPoints(coordinates);
            }
          });
        });
      }
    }
  }

  Future<void> _loadCustomIcons() async {
    currentLocationIcon = await getResizedMarkerIcon(
      'assets/images/ambulance.png',
      width: 100, // Adjust width as needed
    );

    destinationIcon = await getResizedMarkerIcon(
      'assets/images/ambulance.png',
      width: 100, // Adjust width as needed
    );

    setState(() {}); // Trigger rebuild to show icons when loaded
  }

  Future<BitmapDescriptor> getResizedMarkerIcon(String assetPath,
      {int width = 100}) async {
    // Load image from assets as bytes
    ByteData data = await rootBundle.load(assetPath);
    Uint8List bytes = data.buffer.asUint8List();

    // Decode image and resize it
    img.Image? image = img.decodeImage(bytes);
    img.Image resized = img.copyResize(image!, width: width);

    // Encode resized image to bytes
    Uint8List resizedBytes = Uint8List.fromList(img.encodePng(resized));

    // Create a BitmapDescriptor from resized bytes
    return BitmapDescriptor.fromBytes(resizedBytes);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MapProvider>(
      builder: (context, mapProvider, child) {
        var current = Provider.of<LocationProvider>(context, listen: false);
        if (widget.latLng == null) {
          return Center(child: CircularProgressIndicator());
        }

        final LatLng currentLocation = LatLng(
          current.currentPosition!.latitude,
          current.currentPosition!.longitude,
        );

        // print("-----------------------$currentLocation---------------==${widget.latLng}===================================");

        // Move the camera to the user's current location whenever it updates
        if (mapController != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            mapController?.animateCamera(
              CameraUpdate.newLatLng(currentLocation),
            );
          });
        }

        return Stack(
          children: [
            GoogleMap(
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                target: currentLocation,
                zoom: 17,
              ),
              markers: {
                Marker(
                  markerId: MarkerId('currentLocation'),
                  position: currentLocation,
                  icon: currentLocationIcon ??
                      BitmapDescriptor
                          .defaultMarker, // Use custom icon or default
                ),
                Marker(
                  markerId: MarkerId('destination'),
                  position: widget.latLng!,
                  icon: destinationIcon ??
                      BitmapDescriptor
                          .defaultMarker, // Use custom icon or default
                ),
              },
              polylines: Set<Polyline>.of(
                  mapProvider.polylines.values), // Show polyline on the map
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
            widget.showButton
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CustomButton(
                        title: 'Arrived',
                        onTap: () {
                          var resp = context.read<ResponderProvider>();
                          context.read<ResponderProvider>().responderComplete(
                              context, resp.emergencyRes.emergency?.id ?? "");

                          AppNavigationHelper.setRootOldWidget(
                              context, ResponderBaseHomePage());
                        },
                      ),
                    ))
                : SizedBox.shrink()
          ],
        );
      },
    );
  }
}
