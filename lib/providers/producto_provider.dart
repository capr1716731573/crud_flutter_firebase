

import 'dart:convert';
import 'dart:io';
import 'package:mime_type/mime_type.dart';
//Libreria http para realizar peticiones
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:crud_curso_flutter/models/producto_model.dart';
import 'package:crud_curso_flutter/preferencias_usuario/preferencias_usuario.dart';

class ProductoProvider{
  final String _url='https://flutter-varios-2ea16.firebaseio.com';

  //Obtengo las variables del LocalStorage del Telefono
  final _preferenciasUsuario= new PreferenciasUsuario();
 

  Future<String> crearProducto( ProductoModel producto) async {
    
    final url='$_url/productos.json?auth=${ _preferenciasUsuario.token  }';
    //aqui utilizamos la funcion productoModelToJson(producto) xq firebase recibe entre sus parmetros en formato string en ves de json
    final resp= await http.post(url, body: productoModelToJson(producto));

    final decodedData = json.decode(resp.body);

    print( 'El decodeData es : ${decodedData['name']}' );

    //Retorno el ID del producto para seguir editando el mismo
    return decodedData['name'];
    //return true;
  }

   Future<bool> editarProducto( ProductoModel producto) async {

    final url='$_url/productos/${producto.id}.json?auth=${ _preferenciasUsuario.token  }';
    //aqui utilizamos la funcion productoModelToJson(producto) xq firebase recibe entre sus parmetros en formato string en ves de json
    final resp= await http.put(url, body: productoModelToJson(producto));

    final decodedData = json.decode(resp.body);

    print( decodedData );

    return true;
  }


  Future<List<ProductoModel>> cargarProductos () async{
    final url='$_url/productos.json?auth=${ _preferenciasUsuario.token  }';

    final resp=await http.get(url);

    final Map<String,dynamic> decodedData= json.decode(resp.body);

    //Lista de Productos
    final List<ProductoModel> productos= new List();

    if(decodedData == null) return [];//si no hay datos retorno lista vacia

    //Si retorna un error y el token expiro retorna una lista vacia
    if ( decodedData['error'] !=null ) return [];

    //Firebase recibe id y producto , debido a que la estructura del json es la siguiente
    /**
     * -LtmKmb8oGYDQS4cvvUD: {disponible: true, titulo: Tamal, valor: 12.5}
     * el id es -LtmKmb8oGYDQS4cvvUD
     * producto es {disponible: true, titulo: Tamal, valor: 12.5}
     * 
     */
    decodedData.forEach((id,prod){
      //ProductoModel.fromJson coge un json de producto y lo guarda en un arreglo
      final prodTemp= ProductoModel.fromJson(prod);

      prodTemp.id=id;
      productos.add(prodTemp);
      
    });

    //print(productos);

    return productos;
  }

  Future<int> borrarProducto(String id) async{
    final url='$_url/productos/$id.json?auth=${ _preferenciasUsuario.token  }';

    final resp= await http.delete(url);

    print(json.decode(resp.body));
    return 1;

  }

  //Subir foto o imagen o cualquier archivo al servidor desde un backend
  Future <String> subirImagen(File imagen) async{
    //url de prueba
    final url= Uri.parse('https://api.cloudinary.com/v1_1/dsfsepyjq/image/upload?upload_preset=jilztxdb');

    //Conocer el tipo de formato de la imagen se utiliza un paquete MIME_TYPE
    final mimeType=mime(imagen.path).split('/');//separa en una lista - image/jpg

    //Tipo de envio al Web Service
    final imageUploadRequest= http.MultipartRequest(
      'POST',
      url
    );

    //Archivo para adjuntar al request
    final file= await http.MultipartFile.fromPath(
      'file',//variable que se envia la imagen en el POSTMAN 
      imagen.path,
      contentType: MediaType( mimeType[0], mimeType[1])
      );

    //Aqui se adjunta el archivo al request
    imageUploadRequest.files.add(file);
    //si quiero adjunta mas pongo
    /*imageUploadRequest.files.add(file);
    imageUploadRequest.files.add(file);
    imageUploadRequest.files.add(file);*/

    //EJECUTAR LA PETICION
    final streamResponse= await imageUploadRequest.send();
    final resp= await http.Response.fromStream(streamResponse);

    //valido la respuesta del webservice
    if( resp.statusCode != 200 && resp.statusCode != 201){
      print('Algo salio mal');
      print(resp.body);
      return null;
    }

    //Paso el json a un array
    final respData = json.decode(resp.body);
    print(respData);

    return respData['secure_url'];

  } 

}