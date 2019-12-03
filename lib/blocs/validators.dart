//Este archivo retorna StreanTransformer, permitiendo que a traves de ese Stream en caso de pasar una validacion
//ejecutar el metodo sink.add para incorporar el dato que se esta validando el Stream de salida

import 'dart:async';

class Validators{

  //Validar si la informacion cumple con el req para ser un password
  final validarPassword= StreamTransformer<String, String>.fromHandlers(
    handleData: (textoAValidar, sink){
      if(textoAValidar.length >= 6){
        sink.add(textoAValidar);
      }else{
        sink.addError('El password debe tener mínimo 6 caractéres.');
      }
    }
  );

  //Validar si la informacion cumple con el req para ser un email
  //aqui se utiliza un pattern para compara si el texto que fluye a traves del stream 
  final validarEmail= StreamTransformer<String, String>.fromHandlers(
    handleData: (textoAValidar, sink){
      Pattern patternEmail = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp expresionRegular=new RegExp(patternEmail);

      if(expresionRegular.hasMatch(textoAValidar)){
        sink.add(textoAValidar);
      }else{
        sink.addError('El texto ingresado no es un email.');
      }
    }
  );


}