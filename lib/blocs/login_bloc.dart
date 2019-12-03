//Controla el flujo de informacion que pasa por el formulario login


import 'dart:async';

import 'package:crud_curso_flutter/blocs/validators.dart';
//Libreria RxJs
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators{
  //Creo los streams de tipo privado
  //Streams cuando no se utiliza la libreria RXjs
  /*final _emailController  = StreamController<String>.broadcast();
  final _passwordController   = StreamController<String>.broadcast();*/

  //Streams con la libreria RXjs
  final _emailController  = BehaviorSubject<String>();
  final _passwordController   = BehaviorSubject<String>();

  //////////Como es un metodo privado para insertar y recuperar valores los hago atraves del setter and getter
  
  //Insertar valores Set
  //Funcion que recibe (String)
  Function(String) get changeEmail    => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  //Recuperar datos del stream GET
  Stream<String> get emailStream => _emailController.stream.transform(validarEmail);
  Stream<String> get passwordStream => _passwordController.stream.transform(validarPassword);

  //Stream para enviar un valor de true y false
  //este Stream combina el resultado del emailStream y passwordStream
  //si en los dos hay datos validos que cumplen retorna un true caso contrario un false
  Stream<bool> get formularioValidoStream => 
    Observable.combineLatest2(emailStream, passwordStream, (emailValido,passwordValido) => true);
  

  //Retornar el valor del emailStream y passwordStream
  String get emailValor => _emailController.value;
  String get passwordValor => _passwordController.value;

  //Cerrar el metodo cuando ya no se los necesite, es como un garbage colector
  dispose(){
    _emailController?.close();
    _passwordController?.close();
  }
}