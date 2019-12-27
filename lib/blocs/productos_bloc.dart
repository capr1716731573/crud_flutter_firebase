import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:crud_curso_flutter/models/producto_model.dart';
import 'package:crud_curso_flutter/providers/producto_provider.dart';

class ProductosBloc {

  //voy a crear ds streams uno va a ser e; stream de productos para cargar la informacion
  // y el segundo va a ser un stream bandera el cual funcione en toda la app y me sriva com bandera para bloquear botones etc
  final _productosController = new BehaviorSubject<List<ProductoModel>>();
  final _cargandoController = new BehaviorSubject<bool>();

  final _productosProvider = new ProductoProvider();

  //Escuchar los streams
  Stream<List<ProductoModel>> get productosStream => _productosController.stream;
  Stream<bool> get cargandoStream => _cargandoController.stream;


  void cargarProductos() async {
    final productos = await _productosProvider.cargarProductos();
    _productosController.sink.add(productos);
  }

  void crearProducto ( ProductoModel producto ) async {

    //primero pongo el stream de bandera en true para que sepan que estoy cargando
    _cargandoController.sink.add(true);
    await _productosProvider.crearProducto(producto);
    _cargandoController.sink.add(false);

  }

  Future<String> subirFoto ( File foto ) async {

    //primero pongo el stream de bandera en true para que sepan que estoy cargando
    _cargandoController.sink.add(true);
    final fotoUrl= await _productosProvider.subirImagen(foto);
    _cargandoController.sink.add(false);
    return fotoUrl;

  }

  
  void editarProducto ( ProductoModel producto ) async {

    //primero pongo el stream de bandera en true para que sepan que estoy cargando
    _cargandoController.sink.add(true);
    await _productosProvider.editarProducto(producto);
    _cargandoController.sink.add(false);

  }

   void borrarProducto ( String id ) async {

    //primero pongo el stream de bandera en true para que sepan que estoy cargando
    await _productosProvider.borrarProducto(id);

  }

  dispose(){
    _productosController?.close();
    _cargandoController?.close();
  }

}