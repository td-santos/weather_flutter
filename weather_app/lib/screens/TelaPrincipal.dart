import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/api/weatherAPI.dart';
import 'package:weather_app/util/util.dart' as util;

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
  var formatDia = DateFormat("dd");
  var formatAnoMes = DateFormat("yyyy-MM-");
  var formatAnoMesDIA = DateFormat("yyyy-MM-dd");
  int diaSeguinte;
  String anoMes;
  Color corScaffold,
      corContainer,
      corTextoCidade,
      corFloatButtom,
      corTemperatura;
  bool corItemListDia;

  
  setarCoresDiaNoite(int horaAtual) {
    if (horaAtual < 5) {
      corScaffold = Colors.deepPurple[900];
      corContainer = Colors.deepPurple[200];
      corTextoCidade = Colors.deepPurple[200];
      corFloatButtom = Colors.indigo[700];
      corTemperatura = Colors.indigo[700];
      corItemListDia = false;
    } else if (horaAtual < 18) {
      corScaffold = Colors.cyan[300];//Colors.orange[300];
      corContainer = Colors.white;
      corTextoCidade = Colors.white;
      corFloatButtom = Colors.orange[300];
      corTemperatura = Colors.orange[400];
      corItemListDia = true;
    } else {
      corScaffold = Colors.deepPurple[900];
      corContainer = Colors.deepPurple[200];
      corTextoCidade = Colors.deepPurple[200];
      corFloatButtom = Colors.indigo[700];
      corTemperatura = Colors.indigo[700];
      corItemListDia = false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    visibleCidade = true;

    hora = int.parse(
        "${data.toString().substring(10)[1]}${data.toString().substring(10)[2]}");
    print(hora);
    diaSeguinte = int.parse(formatDia.format(data)) + 1;
    anoMes = formatAnoMes.format(data);
    print('DIA ATUAL : $diaSeguinte');
    setarCoresDiaNoite(hora);

    //print(data.toString().substring(10)[1]);
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: corScaffold,
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
                    color: corContainer,
                    borderRadius: BorderRadius.circular(height * 0.5)),
              )),
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
                    onSubmitted: (_) {
                      setState(() {
                        if (_controllerCidade.text == null ||
                            _controllerCidade.text.isEmpty) {
                          //_cidadeInformada = util.cidadeDefault;
                        } else {
                          _cidadeInformada = _controllerCidade.text;
                        }
                        visibleCidade = true;
                      });
                    },
                  ),
                )),
          ),
          Positioned(
              top: 60,
              right: 10,
              //left: 0,
              child: atualizaTemp(_cidadeInformada)
          ),
          Positioned(
              top: 620,
              left: 10,
              right: 10,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Próximo dia em: ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          width: 0,
                        ),
                        Text(
                          _cidadeInformada == null
                              ? util.cidadeDefault
                              : _cidadeInformada,
                          style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: corTextoCidade),
                        ),
                      ],
                    ),
                  ),
                  listaToday(_cidadeInformada, DateTime.now().toString())
                ],
              )
          )
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 40),
        child: FloatingActionButton.extended(
            label: Text("   Cidade   "),
            icon: Icon(
              Icons.search,
              size: 30,
              color: Colors.white,
            ),
            elevation: 0,
            backgroundColor: corFloatButtom,
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
            List conteudolist2 = conteudo['list'];
            List listaHJ = [];

            print('DATA COUNDEUDO: $dataConteudo');
            print('DATA hoje: $data');
            print('AnoMesDiaSeguinte: ${anoMes}${diaSeguinte}');

            String diaSeguinte2;
            if(diaSeguinte.toString().length ==1){
              diaSeguinte2 ='0$diaSeguinte';
            }else{
              diaSeguinte2=diaSeguinte.toString();
            }

            //Dias da semana

            double a=0;
            int b =0;
            List listDias=[];
            List listDiasUnicos=[];
            List listTemp=[];
            List listTempDIA=[];            
            List listMapDataTemp=[];
            
            
            conteudolist.forEach((f) {
              if (f.toString().contains("${anoMes}")){                
                  listDias.add(formatAnoMesDIA.format(DateTime.parse(f['dt_txt'])));
                  listaHJ.add(f);
                  //a = a + double.parse(f['main']['temp'].toString().replaceAll(',', '.'));                
              }
            });

            listDiasUnicos =listDias.toSet().toList();
            print('LISTA DiasUnicos: $listDiasUnicos');
            print('LENGTH: ${listDias.length}');           

            
             for(int i = 0 ;i<listDiasUnicos.length;i++){
               conteudolist.forEach((f){
                 String dataTeste;                 
                 dataTeste =listDiasUnicos[i];

                 if(f.toString().contains('$dataTeste')){
                   
                   a = a + double.parse(f['main']['temp'].toString().replaceAll(',', '.'));
                   b++;
                 }
                 
               });
               listTemp.add(a);
               print('SOMA Temp:${listDiasUnicos[i]} :$a');
               print('Media Temp:${listDiasUnicos[i]} :${(a/b)}');
               listTempDIA.add((a/b).toStringAsFixed(2));               
               listMapDataTemp.add({'data':listDiasUnicos[i],'temp_media':(a/b).toStringAsFixed(2)});
               a=0;
               b=0;
             }            

            //print('SOMA TempMAX: $a');
            //print('MediaMAX: ${a/listaHJ.length}');            
            listMapDataTemp.removeAt(0);
            print('----------------------');
            print('LISTA TEMP: $listTemp');
            print('LISTA TEMP MEDIA: $listTempDIA');
            print('LIST MAP DIA_TEMP: $listMapDataTemp');

            
            

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
                        dia: corItemListDia);
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
                mainAxisAlignment: MainAxisAlignment.start,
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
                              .replaceAll(".", ""),// +"°",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 140,
                        fontWeight: FontWeight.w200,
                        color: corTemperatura,
                      )
                  ),
                  Text("°",
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: corTemperatura,
                        height: 0
                      )
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
