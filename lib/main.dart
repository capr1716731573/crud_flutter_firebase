import 'package:flutter/material.dart';
import 'package:crud_curso_flutter/blocs/provider.dart';
import 'package:crud_curso_flutter/pages/home_page.dart';
import 'package:crud_curso_flutter/pages/login_page.dart';
import 'package:crud_curso_flutter/pages/producto_page.dart';
import 'package:crud_curso_flutter/pages/registro_page.dart';
import 'package:crud_curso_flutter/preferencias_usuario/preferencias_usuario.dart';
 
void main() async {
  final preferenciasUsuario = new PreferenciasUsuario();
  await preferenciasUsuario.initPrefs(); 
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();
    print('El token ahorita es: ${prefs.token}');

    return Provider(
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {   
          'home'     : (BuildContext context) => HomePage(),
          'login'    : (BuildContext context) => LoginPage(),
          'registro'    : (BuildContext context) => RegistroPage(),
          'producto' : (BuildContext context) => ProductoPage()
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple
        ),
      ) ,
    ); 
    
    
    
   
  }
}