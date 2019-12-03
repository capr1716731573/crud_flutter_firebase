//Provider que va a contener todos los widget y va a poder 
//heredar e instaciar os bloc u otros variables de los widgets a todos los widgets de la app
//Es un widget heredado

//Conclusion este va a ser el Widget principal o raiz de toda la App

import 'package:flutter/material.dart';
import 'package:crud_curso_flutter/blocs/login_bloc.dart';
export 'package:crud_curso_flutter/blocs/login_bloc.dart';

class Provider extends InheritedWidget{
  //PATRON SINGLETON PARA CONSERVAR DATOS A PESAR DE HOTRELOAD
  static Provider _instancia;

  //Contructor de Patron Singleton
  factory Provider({Key key, Widget child}){
    if(_instancia == null){
      _instancia=new Provider._internal(key: key, child: child);
    }
    return _instancia;
  }

 //Constructor2
  Provider._internal({Key key, Widget child}):super(key:key, child:child);



  //Instancio LoginBloc
  final loginBloc= LoginBloc();

  
  //Metodo donde digo que todos los cambios en al algun widget sea notificado a todos los widgets
  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  //Metodo para instanciar y recuperar LoginBloc
  static LoginBloc of (BuildContext context){
    return ( context.inheritFromWidgetOfExactType(Provider) as Provider).loginBloc;
  }

  

}