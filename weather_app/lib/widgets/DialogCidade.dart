import 'package:flutter/material.dart';

class DialogCidade extends StatelessWidget {
  var _controllerCidade = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      content: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25), color: Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: 20,
                  left: 15,
                  right: 15,
                ),
                child: Text('Cidade'),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  left: 15,
                  right: 15,
                ),
                child: TextField(
                  controller: _controllerCidade,
                  decoration: InputDecoration(
                      hintText: 'informe a cidade ',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                  onSubmitted: (_) {
                    Navigator.pop(context, {'cidade': _controllerCidade.text});
                  },
                ),
              ),
              SizedBox(
                height: 50,
              )
            ],
          ),
        ),
      ),
    );
  }
}
