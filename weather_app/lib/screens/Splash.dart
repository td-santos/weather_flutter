import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'HomePage.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  Position _position;
  StreamSubscription<Position> _positionStream;
  String latitude,longitude;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var locationOptions = LocationOptions(accuracy: LocationAccuracy.high, distanceFilter: 10);
    _positionStream = Geolocator().getPositionStream(locationOptions).listen((Position position){
      _position = position;
      latitude = position == null ? 'Unknown' : position.latitude.toString();
      longitude = position == null ? 'Unknown' :  position.longitude.toString();
      //print(_position == null ? 'Unknown' : _position.latitude.toString() + ', ' + _position.longitude.toString());
      print( latitude + ', ' + longitude);
    });

    Future.delayed(Duration(seconds: 2),(){
      Navigator.push(context, MaterialPageRoute(
        builder: (context)=> HomePage(
          latitude: latitude,
          longitude: longitude,
        )
        ));
    });
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
      child: Text("Clean Weather !",style: TextStyle(
        fontSize: 50,
        color: Colors.orange
      ),),
    ),
    );
  }
}