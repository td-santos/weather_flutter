import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/api/weatherAPI.dart';
import 'package:weather_app/util/util.dart' as util;
import 'package:weather_app/widgets/DialogCidade.dart';
import 'package:weather_app/widgets/ItemListWeather.dart';


class TelaPrincipal extends StatefulWidget {
  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {

  String _cidadeInformada;
  TextEditingController _controllerCidade = TextEditingController();
  bool visibleCidade;
  DateTime data = DateTime.now();
  int hora;

  /*Future _abrirNovaTela(BuildContext context) async {
    Map result = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => NovaCidade()));

    if (result != null && result.containsKey('cidade')) {
      _cidadeInformada = result['cidade'];
      print(_cidadeInformada);
    }
  }

  Future _dialogCidade(BuildContext context) async {
    Map result = showDialog(
        context: context,
        builder: (context) {
          return DialogCidade();
        }) as Map;

    if (result != null && result.containsKey('cidade')) {
      _cidadeInformada = result['cidade'];
      print(_cidadeInformada);
    }
  }*/

  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    visibleCidade = true;

    hora = int.parse("${data.toString().substring(10)[1]}${data.toString().substring(10)[2]}");
    print(hora);
    //print(data.toString().substring(10)[1]);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: hora < 5
                            ? Colors.deepPurple[900]
                            : hora < 18 ? Colors.blue[300] : Colors.deepPurple[900]
      
      ,
      body: SingleChildScrollView(
          child: Stack(
        children: <Widget>[
          Container(
            height: height,
            width: width,
          ),
          Positioned(
              top: -100,
              right: -150,
              child: Container(
                height: 500,
                width: 500,
                decoration: BoxDecoration(
                    color: hora < 5
                            ? Colors.deepPurple[200]
                            : hora < 18 ? Colors.blue[100] : Colors.deepPurple[200],
                    
                    borderRadius: BorderRadius.circular(height * 0.5)),
              )),
          Visibility(
            visible: visibleCidade,
            child: Positioned(
                top: 40,
                child: Container(
                  width: width,
                  child: Center(
                    child: Text(
                      _cidadeInformada == null
                          ? util.cidadeDefault
                          : _cidadeInformada,
                      style: TextStyle(fontSize: 30,
                      color: hora < 5
                            ? Colors.white
                            : hora < 18 ? Colors.black : Colors.white,
                      ),
                    ),
                  ),
                )),
          ),
          Visibility(
            visible: !visibleCidade,
            child: Positioned(
                top: 40,
                right: 20,
                left: 20,
                child: Container(
                  width: width,
                  child: TextField(
                    autofocus: true,
                    controller: _controllerCidade,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    onSubmitted: (_){
                      setState(() {
                        _cidadeInformada = _controllerCidade.text;
                        visibleCidade =true;
                      });
                    },
                  ),
                  
                )),
          ),
          Positioned(
              top: 60,
              right: 10,
              left: 10,
              child: atualizaTemp(_cidadeInformada)),
          Positioned(
              top: 620,
              left: 10,
              right: 10,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        "Previsão para Amanhã:",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  listaToday(_cidadeInformada, DateTime.now().toString())
                ],
              ))
        ],
      )
          /*
              color: 
              hora > 5 
                ? hora > 11 
                  ? hora > 17
                    ?Colors.indigo[900]
                  :Colors.orange
                :Colors.cyan[300],
                  
              : hora < 6
                ?Colors.indigo[900],
                : null
          ),
          
      ),*/
          ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 40),
        child: FloatingActionButton.extended(
          label: Text("Cidade"),
          icon: Icon(
              Icons.search,
              size: 30,
              color: Colors.white,
            ),
            elevation: 0,
            backgroundColor: Colors.indigo,
            /*child: Icon(
              Icons.search,
              size: 50,
              color: Colors.white,
            ),*/
            onPressed: () {
              setState(() {
                visibleCidade = false;
              });
            }),
      ),
    );
  }

  Widget listaToday(String cidade, String data) {
    return FutureBuilder(
        future: buscarListToday(
            util.appID, cidade == null ? util.cidadeDefault : cidade),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map conteudo = snapshot.data;
            var dataConteudo = conteudo['list'][0]['dt_txt'].toString();
            List conteudolist = conteudo['list'];
            List listaHJ = [];

            print('DATA COUNDEUDO: $dataConteudo');
            print('DATA hoje: $data');

            conteudolist.forEach((f) {
              if (f.toString().contains("2020-04-24")) {
                
                print(f['main']['temp']);
                listaHJ.add(f);
              }
            });
            

            return SizedBox(
              height: 125,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: listaHJ.length,
                  itemBuilder: (context, index) {
                    var format = DateFormat("HH:mm");
                    String horario = format.format(
                        DateTime.parse(listaHJ[index]['dt_txt'].toString()));

                    return ItemListWeather(
                      temp: listaHJ[index]['main']['temp'].toString(),
                      animation:
                          listaHJ[index]['weather'][0]['icon'].toString(),
                      horario: horario,
                    );
                    //return Text(listaHJ[index]['main']['temp'].toString());
                  }),
            );
          } else {
            return Container();
          }
        });
  }

  Widget atualizaTemp(String cidade) {
    return FutureBuilder(
        future: buscarClima(
            util.appID, cidade == null ? util.cidadeDefault : cidade),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map conteudo = snapshot.data;
            return Container(
              width: MediaQuery.of(context).size.width,
              //alignment: Alignment.topRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 300,
                    width: 200,
                    child: FlareActor(
                      'assets/weather3.flr',
                      fit: BoxFit.contain,
                      animation: conteudo['weather'][0]['icon'].toString(),
                    ),
                  ),
                  Text(
                    conteudo['main']['temp'].toString()[0] +
                        conteudo['main']['temp']
                            .toString()[1]
                            .replaceAll(".", "") 
                        +"°",
                    //'10c',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                        fontSize: 100,
                        fontWeight: FontWeight.bold,
                        color: hora < 5
                            ? Colors.white
                            : hora < 18 ? Colors.black : Colors.white),
                  ),
                  
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
