import 'package:flutter/material.dart';
//Validacion para ver si es un numero

bool esNumero(String s){
  if(s.isEmpty ) return false;

  final n= num.tryParse(s);
  //si el valor no se puede transformar en un numero es false caso contrario es true
  return (n == null ) ? false : true;
}

//ejecuta un widget

void mostrarAlerta( BuildContext context, String mensaje){
  showDialog(
    context: context,
    builder: (context){
      return AlertDialog(
        title: Text('Información incorrecta'),
        content: Text(mensaje),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),//cierro el dialogo
          )
        ],
      );
    }
  );
}