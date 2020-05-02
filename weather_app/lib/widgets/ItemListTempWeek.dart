import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ItemListTempWeek extends StatelessWidget {
  final String data;
  final String temp;
  final Color corText;
  final Color corContainer;
  final String animation;

  const ItemListTempWeek(
      {Key key, this.data, this.temp, this.corText, this.corContainer, this.animation='03d'})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //DateFormat formatDiaNome = DateFormat('EEE');
    DateFormat formatDiaNome = DateFormat.E('pt_BR');
    DateFormat formatDiaMes = DateFormat('dd/MM');
    DateTime dataRecebida = DateTime.parse(data);
    String dataFormatada = formatDiaNome.format(dataRecebida);

    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: corContainer, borderRadius: BorderRadius.circular(15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              
                  Container(
                    width: 100,
                    padding: EdgeInsets.only(left: 20,right: 20,top: 15,bottom: 15),
                    decoration: BoxDecoration(
                        //color: Colors.blue[900],
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                          Colors.blue[900],Colors.purple
                        ]),
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Text(
                        dataFormatada,
                        style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                    ),
                  ),
                  
                
              
              Row(
                children: <Widget>[
                  Container(
                    height: 50,
                    width: 50,
                    child: FlareActor(
                      'assets/weather3.flr',
                      fit: BoxFit.contain,
                      animation: animation,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 15,left: 10),
                    child: Text(
                      '${temp[0]}${temp[1].replaceAll(".", "")}°c',
                      style: TextStyle(fontSize: 20, color: corText, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: 10,
        )
      ],
    );
  }
}
