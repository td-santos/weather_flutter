import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/api/weatherAPI.dart';
import 'package:weather_app/util/util.dart' as util;
import 'package:weather_app/widgets/DetalhesHoje.dart';
import 'package:weather_app/widgets/ItemListTempWeek.dart';
import 'package:weather_app/widgets/PrevisaoSemanal.dart';

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
      corUmi = Colors.grey[850];
      corVisi = Colors.grey[850];
      corVent = Colors.grey[850];
      corPres = Colors.grey[850];
      corNuv = Colors.grey[850];
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
            fontSize: width * 0.05,
            color: corText.withOpacity(0.7),
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
        physics: ClampingScrollPhysics(),
        child: Container(
          //height: height,
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: width * 0.1, right: width * 0.1, top: width * 0.04),
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
                                  onTap: () {
                                    setState(() {
                                      visibleCidade = false;
                                    });
                                  },
                                  child: Icon(
                                    Icons.location_on,
                                    size: width * 0.08, //30,
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
                                            fontSize: width * 0.09, //40,
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
                              height: width * 0.009,
                            ),
                            Text(
                              '       ${formatData.format(dataAtual)}',
                              style: TextStyle(
                                  fontSize: width * 0.04 /*17*/,
                                  color: Colors.orange[700]),
                            ),
                            SizedBox(
                              height: width * 0.01,
                            ),
                            Container(
                              height: height * 0.25, //200,
                              width: width,
                              //color: Colors.grey[300],
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                      top: 0,
                                      right: -20,
                                      child: Container(
                                        height: height * 0.22, //200,
                                        width: width * 0.55, //250,
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
                                    top: width * 0.33,//140,
                                    left: 5,
                                    child: Row(
                                      children: <Widget>[
                                        Text(
                                          'Min: ${dadosJson['main']['temp_min']}°',
                                          style: TextStyle(
                                              fontSize: width * 0.038, //15,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.grey[400]),
                                        ),
                                        Text(
                                          '/ Max: ${dadosJson['main']['temp_max']}°',
                                          style: TextStyle(
                                              fontSize: width * 0.038, //15,
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
                              height: width * 0.03,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
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
                                                          ? width * 0.05 //20
                                                          : width * 0.05, //20,
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
                                                          ? width * 0.05 //20
                                                          : width * 0.05, //20,
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
                                    height: width * 0.03,
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
                height: visibleDetalhes == false ? 0 : height * 0.5, //400,
                //visible: visibleDetalhes,
                child: Padding(
                  padding: EdgeInsets.only(left: 30, right: 30, top: 0),
                  child: DetalhesHoje(
                    cidade: _cidadeInformada,
                    corNuv: corNuv,
                    corPres: corPres,
                    corText: corText,
                    corUmi: corUmi,
                    corVent: corVent,
                    corVisi: corVisi,
                  ), //tempHoje(),
                ),
              ),
              Container(
                height: visibleDetalhes == true ? 0 : height * 0.6, //400,
                //visible: visibleDetalhes == false ? true :false,
                child: Padding(
                    padding: EdgeInsets.only(left: 30, right: 30, top: 0),
                    child: PrevisaoSemanal(
                      cidade: _cidadeInformada,
                      corContainerItemList: corContainerItemList,
                      corTextList: corTextList,
                    ) //tempSemana(_cidadeInformada),
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
}
