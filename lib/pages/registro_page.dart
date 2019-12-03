import 'package:flutter/material.dart';
import 'package:crud_curso_flutter/blocs/provider.dart';
import 'package:crud_curso_flutter/providers/usuario_provider.dart';
import 'package:crud_curso_flutter/blocs/utils.dart' as utils;

class RegistroPage extends StatelessWidget {

  final usuarioProvider= new UsuarioProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _crearFondo(context),
          _loginForm(context)
        ],
      )
    );
  }

  Widget _crearFondo(BuildContext context) {
    final tamanoPantalla = MediaQuery.of(context).size;
    //Fondo cuadro morado
    final fondoMorado=Container(
      height: tamanoPantalla.height * 0.4,//40% de la pantalla
      width: double.infinity,
      //Permite dar un Backgroud Dgradado
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            Color.fromRGBO(235, 117, 14, 1.0),
            Color.fromRGBO(253, 120, 3, 1.0)
          ]
        ) 
      ),
    );

    //Circulos de Adorno del cuadro morado
    final circulo= Container(
      width: 100.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        color: Color.fromRGBO(255, 255, 255, 0.05)
      ),
    );

    return Stack(
      children: <Widget>[
        fondoMorado,
        //Creo los circulos en diferentes posiciones con el widget Positioned
        Positioned(top: 90.0, left: 30.0, child: circulo,),
        Positioned(top: -40.0, right: -30.0, child: circulo,),
        Positioned(bottom: -50.0, right: -10.0, child: circulo,),
        Positioned(bottom: 120.0, right: 20.0, child: circulo,),
        Positioned(bottom: -50.0, left: -20.0, child: circulo,),

        //Creo el Logo y la etiqueta
        Container(
          padding: EdgeInsets.only(top: tamanoPantalla.height * 0.12),
          child: Column(
            children: <Widget>[
              Icon(Icons.directions_railway, color: Colors.white, size:100.0),
              SizedBox(height: 10.0, width: double.infinity,),
              Text('Registro', style: TextStyle(color: Colors.white, fontSize: 25.0),)
            ],
          ),
        )
      ],
    );

  }

  ///**************************************************************** */
  ///****************   FORMULARIO LOGIN ******************/    
  ///**************************************************************** */
  
  Widget _loginForm(BuildContext context) {
    final tamanoPantalla= MediaQuery.of(context).size;
    //Variable del Provider que almacena los bloc que a su vez almacena los streams que almacena la informacion
    //en este caso usaremos el bloc de login para manejar los datos del login
    final bloc= Provider.of(context);

    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          //Espacio desde el inicio del top de la pantalla incluyendo el notch de los telefonos HUAWEI Y IPHONE
          SafeArea(
            child: Container(
              height: 200.0,
            ),
          ),
          Container(
            width: tamanoPantalla.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 30.0),
            padding: EdgeInsets.symmetric(vertical: 50.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5.0),
              //Sombra del Formulario
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 3.0,
                  offset: Offset(0.0, 5.0),
                  spreadRadius: 3.0
                )
              ]
            ),
            child: Column(
              children: <Widget>[
                //Titulo de Arriba
                Text('Crear Cuenta', style: TextStyle(fontSize: 20.0),),
                //Espacio separador de elementos del formulario similar a <br>
                SizedBox(height: 40.0,),
                //Crear caja de texto de email
                _crearEmail(bloc),
                 SizedBox(height: 30.0,),
                 _crearPassword(bloc),
                 SizedBox(height: 30.0,),
                 _crearBoton(bloc)
              ],
            ),
          ),
         FlatButton(
           child: Text('Ya tienes cuenta ? Login'),
           onPressed: () => Navigator.pushReplacementNamed(context, 'login'),
         ),
        ],
      ),
    );
  }

  Widget _crearEmail(LoginBloc loginBloc) {
    return StreamBuilder(
      stream: loginBloc.emailStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email, color: Colors.orangeAccent,),
              hintText: 'ejemplo@correo.com',
              labelText: 'Correo Electrónico',
              counterText: snapshot.data,
              errorText: snapshot.error
            ),
            onChanged: (value) => loginBloc.changeEmail(value),
          ),
        );
      },
    );    
  }

  Widget _crearPassword(LoginBloc loginBloc) {
    return StreamBuilder(
      stream: loginBloc.passwordStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock, color: Colors.orangeAccent,),
              labelText: 'Contraseña',
              counterText: snapshot.data,
              errorText: snapshot.error
            ),
            //otra manera de hacer onChanged
            onChanged: loginBloc.changePassword,
          ),
        );
      },
    );

  }

  Widget  _crearBoton(LoginBloc loginBloc) {
    return StreamBuilder(
      stream: loginBloc.formularioValidoStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
       return RaisedButton(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80.0, vertical: 15.0),
            child: Text('Guardar'),
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          elevation: 0.0,
          color: Colors.deepOrangeAccent,
          textColor: Colors.white,
          //si existe el true en el formularioValidoStream ejecuta cualquier codigo dentro de la funcion (){} caso contrario null(boton desactivado)
          onPressed: snapshot.hasData ? () => _metodoRegister(context, loginBloc) : null
        );
      },
    );

    
  }

  _metodoRegister(BuildContext context, LoginBloc bloc) async {
    Map info  = await usuarioProvider.nuevoUsuario(bloc.emailValor, bloc.passwordValor);
    
   if( info['ok'] ){
    Navigator.pushReplacementNamed(context, 'home');
   }else{
     utils.mostrarAlerta(context, info['mensaje']);//mando el error de firebase
   }
  }
}