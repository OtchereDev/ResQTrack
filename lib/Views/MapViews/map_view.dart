import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:resq_track/Provider/Location/location_provider.dart';

class MapScreen extends StatefulWidget {
  final double height;
  const MapScreen({super.key, required this.height});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
 LocationProvider? _locationProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _locationProvider = Provider.of<LocationProvider>(context, listen: false);
        _locationProvider?.startLocationUpdates(context);
      }
    });
  }

  @override
  void dispose() {
    if (mounted) {
      _locationProvider?.stopLocationUpdates();
    }
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        if (locationProvider.currentPosition == null) {
          return Center(child: CircularProgressIndicator());
        }
    
        final LatLng currentLocation = LatLng(
          locationProvider.currentPosition!.latitude,
          locationProvider.currentPosition!.longitude,
        );
        // Move the camera to the user's current location whenever it updates
        if (mapController != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            mapController?.animateCamera(
              CameraUpdate.newLatLng(currentLocation),
            );
          });
        }
    
        return SizedBox(
          height: widget.height, 
          child: GoogleMap(
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
            buildingsEnabled: true,
            indoorViewEnabled: true,
            trafficEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              // Move the camera to the user's current location
              mapController = controller;
            },
            
          ),
        );
      },
    );
  }
}
