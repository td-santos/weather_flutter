import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/api/weatherAPI.dart';
import 'package:weather_app/util/util.dart' as util;

import 'ItemListTempWeek.dart';

class PrevisaoSemanal extends StatelessWidget {
  final String cidade;
  final Color corTextList, corContainerItemList;

  PrevisaoSemanal(
      {Key key, this.cidade, this.corTextList, this.corContainerItemList})
      : super(key: key);

  String anoMes;

  var formatAnoMes = DateFormat("yyyy-MM-");
  var formatAnoMesDIA = DateFormat("yyyy-MM-dd");
  DateTime dataAtual = DateTime.now();

  @override
  Widget build(BuildContext context) {
    anoMes = formatAnoMes.format(dataAtual);

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
            print(
                'COMPARACAO DATAS(LIST MAP TEMP e NOW): ${listMapDataTemp[0]['data']}  -  ${formatAnoMesDIA.format(dataAtual)}');
            if (listMapDataTemp[0]
                .toString()
                .contains(formatAnoMesDIA.format(dataAtual))) {
              listMapDataTemp.removeAt(0);
            }
            if(listMapDataTemp.length >5){
              listMapDataTemp.removeLast();
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
