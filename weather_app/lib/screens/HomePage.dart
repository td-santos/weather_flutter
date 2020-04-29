import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/api/weatherAPI.dart';
import 'package:weather_app/util/util.dart' as util;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _cidadeInformada;
  var formatData = DateFormat('EEEE, dd MMMM');
  DateTime dataAtual = DateTime.now();
  bool valueSwitch =false;
  Color corUmi,corVisi,corVent,corPres,corNuv;
  Color corText,corFundo;

  setCores(){
    if(valueSwitch == false ){
      corUmi=Colors.blue[100];
      corVisi=Colors.orange[100];
      corVent=Colors.grey[200];
      corPres=Colors.green[100];
      corNuv=Colors.indigo[100];
      corText = Colors.grey[900];
      corFundo = Colors.white;

    }else{
      corUmi=Colors.grey[700];
      corVisi=Colors.grey[700];
      corVent=Colors.grey[700];
      corPres=Colors.grey[700];
      corNuv=Colors.grey[700];
      corText = Colors.white;
      corFundo = Colors.grey[900];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCores();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'CleanWeather',
          style: TextStyle(color: corText, ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          Switch(
            value: valueSwitch, 
            onChanged: (value){
              setState(() {
                valueSwitch =value;
                setCores();
                //ThemeData.dark();
              });
            })
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          height: height,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 30, right: 30, top: 20),
                child: FutureBuilder(
                    future: buscarClima(
                        util.appID,
                        _cidadeInformada == null
                            ? util.cidadeDefault
                            : _cidadeInformada),
                    builder: (context, snapshot) {
                      Map dadosJson = snapshot.data;
                      if (snapshot.hasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            
                            Row(
                              children: <Widget>[
                                Icon(Icons.location_on,size: 30,color: valueSwitch == false ? Colors.grey[850]:Colors.orange[600],),
                                Text(
                                  '${dadosJson['name']}',
                                  style: TextStyle(
                                      fontSize: 40, fontWeight: FontWeight.bold, color: corText),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '       ${formatData.format(dataAtual)}',
                              style: TextStyle(fontSize: 17,color: Colors.orange[700]),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 200,
                              width: width,
                              //color: Colors.grey[300],
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    top: 0,
                                    right: -20,
                                    child: Container(
                                      height: 200,
                                      width: 250,
                                      child: FlareActor(
                                        'assets/weather3.flr',
                                        fit: BoxFit.contain,
                                        animation: dadosJson['weather'][0]['icon'].toString(),
                                        ),
                                    )
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 0,
                                    child: Text(
                                      '${dadosJson['main']['temp'].toString()[0]}${dadosJson['main']['temp'].toString()[1].replaceAll(".", "")}°',
                              
                                      style: TextStyle(fontSize: 120,fontWeight: FontWeight.w600,color: corText),
                                    ),
                                  ),
                                  Positioned(
                                    top: 140,
                                    left: 10,
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'Min: ${dadosJson['main']['temp_min']}°',
                                          style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300,color: Colors.grey[400]),
                                        ),
                                        Text(
                                          '/ Max: ${dadosJson['main']['temp_max']}°',
                                          style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300,color: Colors.grey[400]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  
                                ],
                              ),
                            ),
                            SizedBox(height: 20,),
                            Container(
                              //padding: EdgeInsets.only(left: 10,right: 10),
                              decoration: BoxDecoration(
                                //color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                               /* boxShadow: [BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 0),
                                  spreadRadius: 0,
                                  blurRadius: 7
                                )]*/
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: 30,),
                            Text('Detalhes',style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: corText
                            ),),
                            SizedBox(height: 20,),
                            Container(
                              decoration: BoxDecoration(
                                color: corUmi,
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.blue[200],
                                      borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Center(child: Icon(Icons.invert_colors,color: Colors.blue[800],size: 35,),),
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 15),
                                    child: Text('Umidade: ${dadosJson['main']['humidity']}%',style: TextStyle(
                                      fontSize: 20,
                                      color: corText
                                    ),),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              decoration: BoxDecoration(
                                color: corVisi,
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.orange[200],
                                      borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Center(child: Icon(Icons.wb_sunny,color: Colors.orange[800],size: 35,),),
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 15),
                                    child: Text('Visibilidade: ${dadosJson['visibility']} m',style: TextStyle(
                                      fontSize: 20,
                                      color: corText
                                    ),),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              decoration: BoxDecoration(
                                color: corVent,
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Center(child: Icon(Icons.gesture,color: Colors.grey[800],size: 35,),),
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 15),
                                    child: Text('Ventos: ${dadosJson['wind']['speed']} km/h',style: TextStyle(
                                      fontSize: 20,
                                      color: corText
                                    ),),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              decoration: BoxDecoration(
                                color: corPres,
                                borderRadius: BorderRadius.circular(15)
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.green[200],
                                      borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Center(child: Icon(Icons.tonality,color: Colors.green[800],size: 35,),),
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 15),
                                    child: Text('Pressão At: ${dadosJson['main']['pressure']} hPa',style: TextStyle(
                                      fontSize: 20,
                                      color: corText
                                    ),),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              decoration: BoxDecoration(
                                color: corNuv,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.indigo[200],
                                      borderRadius: BorderRadius.circular(15)
                                    ),
                                    child: Center(child: Icon(Icons.filter_drama,color: Colors.indigo[800],size: 35,),),
                                  ),
                                  Padding(padding: EdgeInsets.only(left: 15),
                                    child: Text('Nuvens: ${dadosJson['clouds']['all']}%',style: TextStyle(
                                      fontSize: 20,
                                      color: corText
                                    ),),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 30,),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
