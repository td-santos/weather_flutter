import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class ItemListWeather extends StatelessWidget {

  final String temp;
  final String animation;
  final String horario;
  final bool dia;

  const ItemListWeather({Key key, this.temp, this.animation, this.horario, this.dia}) : super(key: key);

  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 10),
      child: Container(
        padding: EdgeInsets.all(10),
        height: 100,
        width: 70,
        decoration: BoxDecoration(
          color: dia == true ? Colors.orange[300] :Colors.indigo[700],
          borderRadius: BorderRadius.circular(17)
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[

            Text(horario,style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),),
            
            Padding(
              padding: EdgeInsets.only(top: 5),
              child: Container(
                    height: 50,
                    width: 50,
                    child: FlareActor(
                      'assets/weather.flr',
                      fit: BoxFit.contain,
                      animation: animation,
                    ),
                  ),
            ),
            Padding(padding: EdgeInsets.only(top: 5),
            child: Text(temp[0]+temp[1].replaceAll(".", "") +'°C',style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
            ),),
            )

          ],
        ),
      ),
    );
  }
}