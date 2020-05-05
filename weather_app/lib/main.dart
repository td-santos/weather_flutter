import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:weather_app/screens/HomePage.dart';
import 'package:weather_app/screens/Splash.dart';
import 'package:weather_app/screens/TelaPrincipal.dart';

main(List<String> args) {
  

  initializeDateFormatting('pt_BR',null).then((_){
    runApp(MaterialApp(
      //home: Splash(),
    home: HomePage(),
    theme: ThemeData.light(),
    //home: TelaPrincipal(),
    debugShowCheckedModeBanner: false,
  ));
  });
}