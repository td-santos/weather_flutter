import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart'as http;

Future<Map> buscarClima(String appID,String cidade)async{
  String urlAPI ='http://api.openweathermap.org/data/2.5/weather?q=${cidade}&appid=${appID}&units=metric';
  http.Response response = await http.get(urlAPI);

  if(response.statusCode == 200){
    return json.decode(response.body);
  }else{
    throw Exception("FALHA NA CHAMADA DA API");
  }
}

Future<Map> buscarListToday(String appID,String cidade)async{
  String urlAPI ='http://api.openweathermap.org/data/2.5/forecast?q=${cidade}&appid=${appID}&units=metric';
  http.Response response = await http.get(urlAPI);

  if(response.statusCode == 200){
    return json.decode(response.body);
  }else{
    throw Exception("FALHA NA CHAMADA DA API");
  }
}