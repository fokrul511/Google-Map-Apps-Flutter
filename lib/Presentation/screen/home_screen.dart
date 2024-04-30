import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// GPS  service enable/disable
// App permison enable
// get location
// lesen location
//

class _HomeScreenState extends State<HomeScreen> {
  Position? position;

  @override
  void initState() {
    super.initState();
    _onScreenStart();
    listenCurrentLocation();
  }

  Future<void> _onScreenStart() async {
    LocationPermission permission = await Geolocator.checkPermission();
    print(permission);

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      position = await Geolocator.getCurrentPosition();
    } else {
      LocationPermission requestStatus = await Geolocator.requestPermission();

      if (requestStatus == LocationPermission.whileInUse ||
          requestStatus == LocationPermission.always) {
        _onScreenStart();
      } else {
        print('Permison denide');
      }
    }
  }

  void listenCurrentLocation() {
    Geolocator.getPositionStream(
        locationSettings: LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 1,
    )).listen((p) {
      print(p);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        title: const Text('Google Map Apps'),
        centerTitle: true,
      ),
      body: GoogleMap(
        zoomControlsEnabled: true,
        initialCameraPosition: CameraPosition(
          target: LatLng(24.439639, 91.859391),
          zoom: 16.0,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onTap: (LatLng latLng) {
          print("tapped on map$latLng");
        },
        onLongPress: (LatLng latLng) {
          print("on long Press$latLng");
        },
        markers: {
          Marker(
            markerId: MarkerId('My New Restureant'),
            position: LatLng(24.444059540916477, 91.86442762613297),
            infoWindow: InfoWindow(title: "My New Resturant"),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta)
          )
        },
      ),
    );
  }
}
