import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(), //GetArea(), //MapView(), //HomePage(),//
    );
  }
}

class GetArea extends StatelessWidget {
  void getArea() async {
    // From a query
    final query = "Arua";
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    print("Got new area ${first.featureName} : ${first.coordinates}");
  }

  @override
  Widget build(BuildContext context) {
    getArea();
    return Container();
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GoogleMapController _controller;
  Location _location = Location();
  String apiKey = 'AIzaSyDeNVsxwno3K_sUIT5J8XbMPgUVcLUEkUA';
  LatLng _initialCameraPositin;
  //  =
  //     LatLng(_latitude,_longitude );

  @override
  void initState() {
    super.initState();
    getAreaCordinates();
  }

  void _onMapCreated(GoogleMapController _cntlr) {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l) {
      _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
          target: _initialCameraPositin, // LatLng(l.latitude, l.longitude),
          zoom: 15)));
    });
  }

  void getAreaCordinates() async {
    // From a query
    final query = "Makerere";
    var addresses = await Geocoder.local.findAddressesFromQuery(query);
    var first = addresses.first;
    print(addresses.length);
    print("Got new area ${first.featureName} : ${first.coordinates}");
    setState(() {
      // _coordinates = first.coordinates;
      _initialCameraPositin =
          LatLng(first.coordinates.latitude, first.coordinates.longitude);
    });
  }

  @override
  Widget build(BuildContext context) {
    getAreaCordinates();
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: _initialCameraPositin),
                mapType: MapType.normal,
                onMapCreated: _onMapCreated,
                myLocationEnabled: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
