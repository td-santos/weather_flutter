import 'package:flutter/material.dart';
import 'package:weather_app/api/weatherAPI.dart';
import 'package:weather_app/util/util.dart' as util;

class DetalhesHoje extends StatelessWidget {
  final String cidade;
  final Color corUmi, corText, corVisi, corVent, corPres, corNuv;

  const DetalhesHoje(
      {Key key,
      this.cidade,
      this.corUmi,
      this.corText,
      this.corVisi,
      this.corVent,
      this.corPres,
      this.corNuv})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: buscarClima(
            util.appID, cidade == null ? util.cidadeDefault : cidade),
        builder: (context, snapshot) {

          Map dadosJson = snapshot.data;

          if (snapshot.hasData) {
            return ListView(
              children: <Widget>[
                Container(
                  
                  decoration: BoxDecoration(
                      color: corUmi, borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(width * 0.022),
                        decoration: BoxDecoration(
                            color: Colors.blue[200],
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Icon(Icons.invert_colors,
                              color: Colors.blue[800], size: width * 0.08 //35,
                              ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          'Umidade: ${dadosJson['main']['humidity']}%',
                          style: TextStyle(
                              fontSize: width * 0.04, //20,
                              color: corText),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: width * 0.02,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: corVisi, borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(width * 0.022),
                        decoration: BoxDecoration(
                            color: Colors.orange[200],
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Icon(Icons.wb_sunny,
                              color: Colors.orange[800],
                              size: width * 0.08 //35,
                              ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          'Visibilidade: ${dadosJson['visibility']} m',
                          style: TextStyle(
                              fontSize: width * 0.04, //20,
                              color: corText),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: width * 0.02,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: corVent, borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(width * 0.022),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Icon(Icons.gesture,
                              color: Colors.grey[800], size: width * 0.08 //35,
                              ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          'Ventos: ${dadosJson['wind']['speed']} km/h',
                          style: TextStyle(
                              fontSize: width * 0.04, //20,
                              color: corText),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: width * 0.02,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: corPres, borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(width * 0.022),
                        decoration: BoxDecoration(
                            color: Colors.green[200],
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Icon(Icons.tonality,
                              color: Colors.green[800], size: width * 0.08 //35,
                              ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          'Pressão At: ${dadosJson['main']['pressure']} hPa',
                          style: TextStyle(
                              fontSize: width * 0.04, //20,
                              color: corText),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: width * 0.02,
                ),
                Container(
                  decoration: BoxDecoration(
                    color: corNuv,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(width * 0.022),
                        decoration: BoxDecoration(
                            color: Colors.indigo[200],
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Icon(Icons.filter_drama,
                              color: Colors.indigo[800],
                              size: width * 0.08 //35,
                              ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          'Nuvens: ${dadosJson['clouds']['all']}%',
                          style: TextStyle(
                              fontSize: width * 0.04, //20,
                              color: corText),
                        ),
                      )
                    ],
                  ),
                )
              ],
            );
          } else {
            return Container();
          }
        });
  }
}
