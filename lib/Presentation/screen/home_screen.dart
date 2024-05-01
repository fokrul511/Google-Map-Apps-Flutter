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
  late GoogleMapController _googleMapController;
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
        locationSettings: const LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 1,
    )).listen((p) {
      print(p);
    });
  }

  Future<void> _initalizeMapSomethings() async {
    print(await _googleMapController.getVisibleRegion());
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
      body: GoogleMap(
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          _googleMapController = controller;
          _initalizeMapSomethings();
        },
        zoomControlsEnabled: true,
        initialCameraPosition: const CameraPosition(
          target: LatLng(24.439639, 91.859391),
          zoom: 16.0,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onTap: (LatLng latLng) {
          print("tapped on map $latLng");
        },
        onLongPress: (LatLng latLng) {
          print("on long Press$latLng");
        },
        markers: {
          Marker(
            markerId: const MarkerId('My New clud'),
            position: const LatLng(24.444059540916477, 91.86442762613297),
            infoWindow: const InfoWindow(title: "My New club"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueMagenta),
            draggable: false,
            flat: false,
          ),
          Marker(
            markerId: const MarkerId('My New Restureant'),
            position: const LatLng(24.438878258856057, 91.86352673918009),
            infoWindow: const InfoWindow(title: "My New Resturant"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            draggable: false,
            flat: false,
          ),
          Marker(
            markerId: const MarkerId('My New House'),
            position: const LatLng(24.44422558260487, 91.85850497335196),
            infoWindow: const InfoWindow(title: "My New House"),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            draggable: false,
            flat: false,
          ),
        },
        circles: {
          Circle(
            circleId: const CircleId('my resturent area'),
            center: const LatLng(24.438878258856057, 91.86352673918009),
            radius: 100,
            strokeColor: Colors.orange,
            fillColor: Colors.orange.withOpacity(0.10),
            strokeWidth: 2,
          )
        },
        polylines: {
          const Polyline(
            width: 3,
            color: Colors.green,
            visible: true,
            polylineId: PolylineId('poly-line-id'),
            points: [
              LatLng(24.436260218748043, 91.86096858233213),
              LatLng(24.44201879744929, 91.85368370264769),
            ],
          ),
        },
        polygons: {
          Polygon(
              polygonId: const PolygonId('poly-gons-id'),
              points: [
                const LatLng(24.438758911352352, 91.85212936252356),
                const LatLng(24.43312503122457, 91.85084592550993),
                const LatLng(24.435923535516917, 91.85564439743757)
              ],
              strokeWidth: 2,
              fillColor: Colors.blue.withOpacity(0.10),
              strokeColor: Colors.blue,
              holes: []),
        },
      ),
    );
  }
}
