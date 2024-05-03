import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late GoogleMapController _googleMapController;
  Position? _position;
  final Set<Marker> _markers = {};
  final List<LatLng> _polylineCoordinates = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _updateLocationPeriodically();
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _position = position;
      _updateMarker(position);
      _polylineCoordinates.add(LatLng(position.latitude, position.longitude));
    });
  }

  void _updateMarker(Position position) {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: InfoWindow(
            title: 'My current location',
            snippet:
                'Latitude: ${position.latitude}, Longitude: ${position.longitude}',
          ),
        ),
      );
    });
  }

  void _updateLocationPeriodically() {
    Timer.periodic(const Duration(seconds: 10), (Timer timer) {
      if (_position != null) {
        _getCurrentLocation();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Real-time Location Tracker'),
        centerTitle: true,
      ),
      body: _position == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              mapType: MapType.normal,
              onMapCreated: (GoogleMapController controller) {
                _googleMapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(_position!.latitude, _position!.longitude),
                zoom: 16.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: _markers,
              polylines: {
                Polyline(
                  polylineId: const PolylineId('polyline'),
                  color: Colors.blue,
                  width: 5,
                  points: _polylineCoordinates,
                ),
              },
            ),
    );
  }
}
