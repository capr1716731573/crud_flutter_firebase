


import 'package:crud_curso_flutter/preferencias_usuario/preferencias_usuario.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UsuarioProvider{
  //Se lo obtiene en Settings -> General -> Clave de API web
  final String _firebaseToken='AIzaSyAd6VOFK4Zo3gjm3CLCQcCzvavQCw8jFCU';

  //Almacenar las preferencias del usuario
  final _preferenciasUsuario=new PreferenciasUsuario();

  Future<Map<String, dynamic>> loginUsuario( String email, String password) async{
    final authData={
      'email'    : email,
      'password' : password,
      'returnSecureToken' : true
    };

    final resp = await http.post(
      //url de autenticacion firebase
      'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken',
      body: jsonEncode(authData),

    );

    Map<String, dynamic> decodeResp= json.decode(resp.body);

    print(decodeResp);

    //Validar si existe error en la peticion
    if( decodeResp.containsKey('idToken') ){// si contiene el id token
      _preferenciasUsuario.token=decodeResp['idToken'];
      return { 'ok': true, 'token': decodeResp['idToken'] };
    }else{
      return { 'ok':false, 'mensaje': decodeResp['error']['message'] };
    }

  }
  
  Future<Map<String, dynamic>> nuevoUsuario( String email, String password) async{
    final authData={
      'email'    : email,
      'password' : password,
      'returnSecureToken' : true
    };

    final resp = await http.post(
      //url de autenticacion firebase
      'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken',
      body: jsonEncode(authData),

    );

    Map<String, dynamic> decodeResp= json.decode(resp.body);

    print(decodeResp);

    //Validar si existe error en la peticion
    if( decodeResp.containsKey('idToken') ){// si contiene el id token
     _preferenciasUsuario.token=decodeResp['idToken'];
      return { 'ok': true, 'token': decodeResp['idToken'] };
    }else{
      return { 'ok':false, 'mensaje': decodeResp['error']['message'] };
    }

  }
}