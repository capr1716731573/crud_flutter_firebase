
import 'package:crud_curso_flutter/blocs/provider.dart';
import 'package:flutter/material.dart';
import 'dart:io';

//Plugins para fotos 
import 'package:image_picker/image_picker.dart';


//simport 'package:crud_curso_flutter/providers/producto_provider.dart';
import 'package:crud_curso_flutter/blocs/utils.dart' as claseUtils;
import 'package:crud_curso_flutter/models/producto_model.dart';

class ProductoPage extends StatefulWidget {

  @override
  _ProductoPageState createState() => _ProductoPageState();
}

class _ProductoPageState extends State<ProductoPage> {
  //Key para el Form, para ejecutar el _submit()
  final formKey= GlobalKey<FormState>();

  //Key del Scaffold para que reconozaca el snackBar
  final scaffoldKey= GlobalKey<ScaffoldState>();

  //Instancia de ProductoModel para enlazar a los TextInputField
  ProductoModel productoModel= new ProductoModel();

  //Bandera para saber si estoy guardando el registro y bloquear el boto guardar
  // y de esta manera no permitir aplastar 
  bool _estaGuardando=false;

  //Instancia del provider para hacer peticiones CRUD
  //final ProductoProvider _productoProvider= new ProductoProvider();

  //Implementacion con streams
  ProductosBloc productosBloc;

  //Variable de tipo File para almacenar la foto tanto de  la camara como de la galeria
  File foto;


  @override
  Widget build(BuildContext context) {
    //inicializar bloc y con esto tengo acceso a ella en todos los lugares de mi app
    productosBloc= Provider.productosBloc(context);

    //Capturo los argumentos que vienen desde otra pagina
    final ProductoModel productoData= ModalRoute.of(context).settings.arguments;

    if(productoData != null){
      productoModel=productoData;
    }

    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('Producto'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.photo_size_select_actual),
            onPressed: _seleccionarFoto,
          ),
          IconButton(
            icon: Icon(Icons.camera_alt),
            onPressed: _tomarFoto,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15.0),
          child: Form(
            key: formKey,
            child: Column(
              children: <Widget>[
                _mostrarFoto(),
                _crearNombre(context),
                _crearPrecio(context),
                _crearDisponible(context),
                _crearBoton(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  /*
    IMPORTANTE 
    en cada TextFormField para enlazar al ProductoModel se debe 
    1) en la propiedad initialValue: productoModel.nombre
    2) en la propiedad onSaved(), este propiedad se ejecuta despues de validator, es decir si pasa la validacion
    se guardan los datos dentro del TextFormField
    3) Para que se coja los valores asignados en la propiedad onSaved de cada control al hacer el submit del formulario,
    se debe ejecutar la siguiente linea en el _submit ====> formKey.currentState.save();
  
  */

  Widget _crearNombre(BuildContext context) {
    return TextFormField(
      initialValue: productoModel.titulo,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
        labelText: 'Producto'
      ),
      //Se ejecuta despues de pasar el "validator"
      onSaved: (valorIngresado) => productoModel.titulo=valorIngresado,
      validator: (valorIngresado){
        if(valorIngresado.length < 3){
          return 'Ingrese un nombre valido';
        }else{
          return null;//si la validacion retorna null, es que ha pasado la validacion
        }
      } ,
    );
  }

  Widget _crearPrecio(BuildContext context) {
    return TextFormField(
      initialValue: productoModel.valor.toString(),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(
        labelText: 'Precio: '
      ),
      onSaved: (valorIngresado) => productoModel.valor=double.parse(valorIngresado),
      validator: (valorIngresado){
        if(claseUtils.esNumero(valorIngresado)){
          return null;
        }else{ return 'Solo numeros!!!';}
      },
    );
  }

  Widget _crearDisponible(BuildContext context){
    return SwitchListTile(
      value: productoModel.disponible,
      title: Text('Disponible'),
      activeColor: Theme.of(context).primaryColor,
      onChanged: (valorIngresado) => setState((){
        productoModel.disponible=valorIngresado;
      }),
    );
  }

  Widget _crearBoton(BuildContext context) {
    return RaisedButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0)
      ),
      label: Text('Guardar'),
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
      icon: Icon(Icons.save),
      onPressed: (_estaGuardando) ? null : _submit,
    );
  }

  //funcion ue ejecuta el submit del formulario, por medio de una key que se le asigna al widget Form
  //el submit se ejecuta si pasa todas las validaciones similar a html
  void _submit() async {
    String mensaje;

    //Si la validacion del formulario es false, no ejecuta nada del codigo de abajo
    //para que se ejecute debe pasar todas las validaciones del form

    if( !formKey.currentState.validate()) return;

    //Se ejecuta si la validacion del form en cada campo a pasado
    formKey.currentState.save();

    //Redibuja el boton de guardar para que se bloquee si esta guardando
    setState(() { _estaGuardando=true; });

    //Aqui guardo la foto y actualizo el url del registro
    if( foto != null){
      productoModel.fotoUrl= await productosBloc.subirFoto(foto);
    }

    if(productoModel.id != null){
      //Actualiza el registro
      productosBloc.editarProducto(productoModel);
      mensaje='Registro Actualizado!!';
       
        //Navigator.pop(context);
    }else{
      //Crea el registro
      //crear producto en BDD de Firebase por medio del Provider
      //Retorno el id del producto, para que la proxima que aplaste el boton sea para editar
      productosBloc.crearProducto(productoModel);
      
      mensaje='Registro Creado!!';

    }

    //Muestro el SnackBar
    mostrarSnackBar(mensaje);
    Navigator.pop(context);

    //Desbloquea el boton despues de guardar
    setState(() { _estaGuardando=false; });

    //Solo si actualizo regreso a la pantalla home si creo un registro nuevo sigo editandolo
    //if(productoModel.id != null){{
      
    //}

    //si pasa la validacion se ejecuta todo lo de abajo
    print('Se ejecuto el submit!!!!!!!!!');

  }

  void mostrarSnackBar(String mensaje){
    final mensajeSnackBar= SnackBar(
      content: Text(mensaje),
      duration: Duration(milliseconds: 1500),

    );

    //se debe colocar el key del scaffold donde quiero mostrarlo
    scaffoldKey.currentState.showSnackBar(mensajeSnackBar);
  }


  /*
   * METODO DE PARA MANIPULAR LA GALERIA TANTO EN SELECCIONAR FOTO O TOMAR FOTO
   */

  Widget _mostrarFoto(){
    final noImg = Image(
      image: AssetImage(foto?.path ?? 'assets/no-image.png'),
      height: 300.0,
      fit: BoxFit.cover,
    );
    

    if( productoModel.fotoUrl != null){
      
      return FadeInImage(
        image: NetworkImage(productoModel.fotoUrl),
        placeholder: AssetImage('assets/jar-loading.gif'),
        height: 300.0,
        width: double.infinity,
        fit: BoxFit.cover,
      ); 
    }else{
      
      return ( foto == null)
          ? noImg
          : Image.file( foto , height: 300.0, fit: BoxFit.cover,);
    }
  }

  _seleccionarFoto() async{
   _procesarImagenFoto(ImageSource.gallery);
  }

  _tomarFoto() async{
    _procesarImagenFoto(ImageSource.camera);
  }

  _procesarImagenFoto( ImageSource imagenSource) async{
    foto = await ImagePicker.pickImage(
      source: imagenSource
    );

    if( foto != null){
      //limpieza
      productoModel.fotoUrl=null;
    }

    setState(() {});
  }


}