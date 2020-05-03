import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/api/weatherAPI.dart';
import 'package:weather_app/util/util.dart' as util;
import 'package:weather_app/widgets/ItemListTempWeek.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _cidadeInformada;
  TextEditingController _controllerCidade = TextEditingController();
  var formatData = DateFormat('EEEE, dd MMMM', 'pt_BR');
  DateTime dataAtual = DateTime.now();
  bool valueSwitch = false;
  bool visibleCidade;
  Color corUmi, corVisi, corVent, corPres, corNuv;
  Color corText, corFundo, corTextList, corContainerItemList;
  bool visibleDetalhes;
  var formatAnoMesDIA = DateFormat("yyyy-MM-dd");
  var formatAnoMes = DateFormat("yyyy-MM-");
  String anoMes;

  setCores() {
    if (valueSwitch == false) {
      corUmi = Colors.blue[100];
      corVisi = Colors.orange[100];
      corVent = Colors.grey[200];
      corPres = Colors.green[100];
      corNuv = Colors.indigo[100];
      corText = Colors.grey[900];
      corFundo = Colors.white;
      corTextList = Colors.grey[900];
      corContainerItemList = Colors.grey[100];
    } else {
      corUmi = Colors.grey[700];
      corVisi = Colors.grey[700];
      corVent = Colors.grey[700];
      corPres = Colors.grey[700];
      corNuv = Colors.grey[700];
      corText = Colors.white;
      corFundo = Colors.grey[900];
      corTextList = Colors.orange[600];
      corContainerItemList = Colors.grey[850];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setCores();
    anoMes = formatAnoMes.format(dataAtual);
    visibleCidade = true;
    visibleDetalhes = true;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: corFundo,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
          'CleanWeather',
          style: TextStyle(
            color: corText,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          Switch(
              value: valueSwitch,
              onChanged: (value) {
                setState(() {
                  valueSwitch = value;
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
                                GestureDetector(
                                  onTap: (){
                                    setState(() {
                                      visibleCidade =false;
                                    });
                                  },
                                  child: Icon(
                                    Icons.location_on,
                                    size: width * 0.08,//30,
                                    color: valueSwitch == false
                                        ? Colors.grey[850]
                                        : Colors.orange[600],
                                  ),
                                ),
                                Visibility(
                                    visible: visibleCidade,
                                    child: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          visibleCidade = false;
                                        });
                                      },
                                      child: Text(
                                        '${dadosJson['name']}',
                                        style: TextStyle(
                                            fontSize: width * 0.09,//40,
                                            fontWeight: FontWeight.bold,
                                            color: corText),
                                      ),
                                    )),
                                Visibility(
                                    visible: !visibleCidade,
                                    child: Expanded(
                                        child: TextField(
                                      autofocus: true,
                                      style: TextStyle(color: corText),
                                      controller: _controllerCidade,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(15))),
                                      onSubmitted: (_) {
                                        setState(() {
                                          if (_controllerCidade.text == null ||
                                              _controllerCidade.text.isEmpty) {
                                            //_cidadeInformada = util.cidadeDefault;
                                          } else {
                                            _cidadeInformada =
                                                _controllerCidade.text;
                                          }
                                          visibleCidade = true;
                                        });
                                      },
                                    ))),
                              ],
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              '       ${formatData.format(dataAtual)}',
                              style: TextStyle(
                                  fontSize: width * 0.04 /*17*/, color: Colors.orange[700]),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height:height * 0.25, //200,
                              width: width,
                              //color: Colors.grey[300],
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                      top: 0,
                                      right: -20,
                                      child: Container(
                                        height: height * 0.22,//200,
                                        width: width * 0.55,//250,
                                        child: FlareActor(
                                          'assets/weather3.flr',
                                          fit: BoxFit.contain,
                                          animation: dadosJson['weather'][0]
                                                  ['icon']
                                              .toString(),
                                        ),
                                      )),
                                  Positioned(
                                    top: 10,
                                    left: 0,
                                    child: Text(
                                      '${dadosJson['main']['temp'].toString()[0]}' +
                                          '${dadosJson['main']['temp'].toString()[1].replaceAll(".", "")}°',
                                      style: TextStyle(
                                          fontSize: width * 0.29, //120,
                                          fontWeight: FontWeight.w600,
                                          color: corText),
                                    ),
                                  ),
                                  Positioned(
                                    top: 140,
                                    left: 10,
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'Min: ${dadosJson['main']['temp_min']}°',
                                          style: TextStyle(
                                              fontSize: width * 0.038,//15,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.grey[400]),
                                        ),
                                        Text(
                                          '/ Max: ${dadosJson['main']['temp_max']}°',
                                          style: TextStyle(
                                              fontSize: width * 0.038,//15,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.grey[400]),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
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
                                  SizedBox(
                                    height: 0,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      /*Text(
                                        'Detalhes',
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold,
                                            color: corText),
                                      ),*/
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            visibleDetalhes = true;
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 500),
                                          padding: visibleDetalhes == true
                                              ? EdgeInsets.all(0)
                                              : EdgeInsets.only(
                                                  left: 25,
                                                  right: 25,
                                                  top: 10,
                                                  bottom: 10),
                                          decoration: BoxDecoration(
                                              border: visibleDetalhes == true
                                                  ? null
                                                  : Border.all(
                                                      color: Colors.orange[600],
                                                      width: 1.2),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Center(
                                            child: Text(
                                              'Detalhes',
                                              style: TextStyle(
                                                  fontSize:
                                                      visibleDetalhes == true
                                                          ? width * 0.05//20
                                                          : width * 0.05,//20,
                                                  color: corText,
                                                  fontWeight:
                                                      visibleDetalhes == true
                                                          ? FontWeight.bold
                                                          : FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            visibleDetalhes = false;
                                          });
                                        },
                                        child: AnimatedContainer(
                                          duration: Duration(milliseconds: 500),
                                          padding: visibleDetalhes == false
                                              ? EdgeInsets.all(0)
                                              : EdgeInsets.only(
                                                  left: 25,
                                                  right: 25,
                                                  top: 10,
                                                  bottom: 10),
                                          decoration: BoxDecoration(
                                              border: visibleDetalhes == false
                                                  ? null
                                                  : Border.all(
                                                      color: Colors.orange[600],
                                                      width: 1.2),
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: Center(
                                            child: Text(
                                              'Previsão',
                                              style: TextStyle(
                                                  fontSize:
                                                      visibleDetalhes == false
                                                          ? width * 0.05//20
                                                          : width * 0.05,//20,
                                                  color: corText,
                                                  fontWeight:
                                                      visibleDetalhes == false
                                                          ? FontWeight.bold
                                                          : FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Container();
                      }
                    }),
              ),
              Container(
                height: visibleDetalhes == false ? 0 : height * 0.4,//400,
                //visible: visibleDetalhes,
                child: Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 0),
                  child: tempHoje(),
                ),
              ),
              Container(
                height: visibleDetalhes == true ? 0 : height * 0.4,//400,
                //visible: visibleDetalhes == false ? true :false,
                child: Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 0),
                  child: tempSemana(_cidadeInformada),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget tempHoje() {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return FutureBuilder(
        future: buscarClima(util.appID,
            _cidadeInformada == null ? util.cidadeDefault : _cidadeInformada),
        builder: (context, snapshot) {
          Map dadosJson = snapshot.data;
          if (snapshot.hasData) {
            return Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: corUmi, borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.blue[200],
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Icon(
                            Icons.invert_colors,
                            color: Colors.blue[800],
                            size: width * 0.08//35,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          'Umidade: ${dadosJson['main']['humidity']}%',
                          style: TextStyle(fontSize: width * 0.045,//20, 
                          color: corText),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: corVisi, borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.orange[200],
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Icon(
                            Icons.wb_sunny,
                            color: Colors.orange[800],
                            size: width * 0.08//35,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          'Visibilidade: ${dadosJson['visibility']} m',
                          style: TextStyle(fontSize: width * 0.045,//20, 
                          color: corText),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: corVent, borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Icon(
                            Icons.gesture,
                            color: Colors.grey[800],
                            size: width * 0.08//35,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          'Ventos: ${dadosJson['wind']['speed']} km/h',
                          style: TextStyle(fontSize: width * 0.045,//20, 
                          color: corText),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: corPres, borderRadius: BorderRadius.circular(15)),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.green[200],
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Icon(
                            Icons.tonality,
                            color: Colors.green[800],
                            size: width * 0.08//35,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          'Pressão At: ${dadosJson['main']['pressure']} hPa',
                          style: TextStyle(fontSize: width * 0.045,//20, 
                          color: corText),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
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
                            borderRadius: BorderRadius.circular(15)),
                        child: Center(
                          child: Icon(
                            Icons.filter_drama,
                            color: Colors.indigo[800],
                            size: width * 0.08//35,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Text(
                          'Nuvens: ${dadosJson['clouds']['all']}%',
                          style: TextStyle(fontSize: width * 0.045,//20, 
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

  Widget tempSemana(String cidade) {
    return FutureBuilder(
        future: buscarListToday(
            util.appID, cidade == null ? util.cidadeDefault : cidade),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Map conteudo = snapshot.data;
            List conteudolist = conteudo['list'];

            double somaTemperaturas = 0;
            int qntdForPercorrido = 0;
            List listDias = [];
            //List listaHJ = [];
            List listDiasUnicos = [];
            List listTemp = [];
            List listTempDIA = [];
            List listMapDataTemp = [];
            List iconList = [];

            conteudolist.forEach((f) {
              if (f.toString().contains("${anoMes}")) {
                listDias
                    .add(formatAnoMesDIA.format(DateTime.parse(f['dt_txt'])));
                //listaHJ.add(f);
              }
            });

            listDiasUnicos = listDias.toSet().toList();

            for (int i = 0; i < listDiasUnicos.length; i++) {
              conteudolist.forEach((f) {
                String dataListaUnica;
                dataListaUnica = listDiasUnicos[i];

                if (f.toString().contains('$dataListaUnica')) {
                  somaTemperaturas = somaTemperaturas +
                      double.parse(
                          f['main']['temp'].toString().replaceAll(',', '.'));
                  if (f.toString().contains('$dataListaUnica 15:00:00')) {
                    iconList.add({
                      'data': '$dataListaUnica 15:00:00',
                      'icon': f['weather'][0]['icon'].toString()
                    });
                  }
                  qntdForPercorrido++;
                }
              });

              listTemp.add(somaTemperaturas);

              print('SOMA Temp:${listDiasUnicos[i]} :$somaTemperaturas');
              print(
                  'Media Temp:${listDiasUnicos[i]} :${(somaTemperaturas / qntdForPercorrido)}');

              listTempDIA.add((somaTemperaturas / qntdForPercorrido).round());
              listMapDataTemp.add({
                'data': listDiasUnicos[i],
                'temp_media':
                    (somaTemperaturas / qntdForPercorrido).toStringAsFixed(2)
              });

              somaTemperaturas = 0;
              qntdForPercorrido = 0;
            }
            print('COMPARACAO DATAS(LIST MAP TEMP e NOW): ${listMapDataTemp[0]['data']}  -  ${formatAnoMesDIA.format(dataAtual)}');
            if(listMapDataTemp[0].toString().contains(formatAnoMesDIA.format(dataAtual))){
              listMapDataTemp.removeAt(0);
            }

            

            print('----------------------');
            print('LISTA TEMP: $listTemp');
            print('LISTA TEMP MEDIA: $listTempDIA');
            print('LIST MAP DIA_TEMP: $listMapDataTemp');

            print('----------------------');
            //iconList.removeAt(0);
            if (iconList.length < 5) {
              iconList.add({'icon': '03d'});
            }

            print('ICON LIST: $iconList');

            return Container(
              //height: 50,
              //color: Colors.grey[300],
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: listMapDataTemp.length,
                itemBuilder: (context, index) {
                  //return Text('${listMapDataTemp[index]['data']} -> ${listMapDataTemp[index]['temp_media']}');
                  return ItemListTempWeek(
                    data: listMapDataTemp[index]['data'].toString(),
                    temp: listMapDataTemp[index]['temp_media'].toString(),
                    corText: corTextList,
                    corContainer: corContainerItemList,
                    animation: iconList[index]['icon'],
                  );
                },
              ),
            );
          } else {
            return Container();
          }
        });
  }
}
