import 'package:flutter/material.dart';
import 'package:weather_app/screens/HomePage.dart';
import 'package:weather_app/screens/TelaPrincipal.dart';

main(List<String> args) {
  runApp(MaterialApp(
    //home: HomePage(),
    theme: ThemeData.light(),
    home: TelaPrincipal(),
    debugShowCheckedModeBanner: false,
  ));
}