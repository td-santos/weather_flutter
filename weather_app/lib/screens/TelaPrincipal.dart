import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

import 'package:weather_app/api/weatherAPI.dart';
import 'package:weather_app/util/util.dart' as util;

import 'NovaCidade.dart';

class TelaPrincipal extends StatefulWidget {
  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  String _cidadeInformada;
  TextEditingController _controllerCidade = TextEditingController();

  Future _abrirNovaTela(BuildContext context) async {
    Map result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => NovaCidade()));

        if(result != null && result.containsKey('cidade')){
          _cidadeInformada = result['cidade'];
          print(_cidadeInformada);
        }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              //colors: [Colors.orange,Colors.orange, Colors.orange[600],Colors.red,Colors.brown[900],Colors.black]),
              //colors: [Colors.cyan[300],Colors.cyan[100],Colors.cyan[200],Colors.cyan[700],Colors.cyan[900],Colors.black]),
              colors: [Colors.indigo[900],Colors.deepPurple[900],Colors.deepPurple[700],Colors.purple[700],Colors.deepPurple[700],Colors.deepPurple[900],Colors.indigo[900]]),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 60, left: 15, right: 15),
              child: Row(
                children: <Widget>[
                  Flexible(
                      child: TextField(
                    controller: _controllerCidade,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                  )),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: GestureDetector(
                      onTap: (){
                        _abrirNovaTela(context);
                      },
                      child: Icon(
                        Icons.cloud_queue,
                        size: 40,
                      ),
                    ),
                  ),
                  
                ],
              ),
            ),
            Padding(
                    padding: EdgeInsets.only(top: 15,right: 15),
                    child: atualizaTemp(_cidadeInformada),
                  ),
            
          ],
        ),
      ),
    );
  }

  Widget atualizaTemp(String cidade) {
    return FutureBuilder(
        future: buscarClima(
            util.appID, cidade == null ? util.cidadeDefault : cidade),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map conteudo = snapshot.data;
            return Container(
              width: double.infinity,
              //alignment: Alignment.topRight,
              child: Column(
                children: <Widget>[
                  Container(
                    height: 400,
                    //width: 200,
                    child: FlareActor('assets/weather2.flr',
                    fit: BoxFit.contain,
                    animation: conteudo['weather'][0]['icon'].toString(),),
                    
                    
                  ),
                  ListTile(
                    
                    title: Text(
                      conteudo['main']['temp'].toString()[0]+conteudo['main']['temp'].toString()[1].replaceAll(".", "")+ "°c",
                      //'10c',
                      textAlign:TextAlign.end ,
                      style: TextStyle(fontSize: 100),
                    ),
                    subtitle: Text(cidade == null ?util.cidadeDefault : cidade,textAlign: TextAlign.end,),
                  )
                ],
              ),
            );
          } else {
            return Container(
              child: Text('Deu Ruim Heim !'),
            );
          }
        });
  }
}

