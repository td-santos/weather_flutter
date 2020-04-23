import 'package:flutter/material.dart';

class NovaCidade extends StatelessWidget {

  var _novaCidadeController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.cyan[300],
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text('Nova Cidade'),
        ),
        body: Container(
          child: Center(
            child: Column(
              children: <Widget>[

                TextField(
                  controller: _novaCidadeController,
                  decoration: InputDecoration(
                    hintText: 'digite a cidade'
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 10),
                  child: FlatButton(
                    onPressed: (){
                      Navigator.pop(context,{
                        'cidade': _novaCidadeController.text
                      });
                    }, 
                    textColor: Colors.white,
                    color: Colors.cyan,
                    child: Text('Mostra o tempo')), 
                  )

              ],
            ),
          ),
        ));
  }
}
