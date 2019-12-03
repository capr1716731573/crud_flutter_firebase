
import 'package:flutter/material.dart';
import 'package:crud_curso_flutter/models/producto_model.dart';
import 'package:crud_curso_flutter/providers/producto_provider.dart';

class HomePage extends StatelessWidget {
  final _productoProvider=new ProductoProvider();
  @override
  Widget build(BuildContext context) {
    //final bloc=Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: _crearListado(),
      floatingActionButton: _crearFABBoton(context),
    );
  }
  
  Widget _crearListado() {
    return FutureBuilder(
      future: _productoProvider.cargarProductos(),
      builder: (BuildContext context, AsyncSnapshot<List<ProductoModel>> snapshot) {
        //preguntar si hay informacion
        if(snapshot.hasData){
          final productos=snapshot.data;

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (BuildContext context, int index) => _crearItem(context,productos[index])
          );
        }else{
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
  
  //Crear Item del Listado
  Widget _crearItem(BuildContext context, ProductoModel producto) {
    return Dismissible(
          key: UniqueKey(),
          background: Container(
            color: Colors.red,
          ),
          onDismissed: (direccion){
            _productoProvider.borrarProducto(producto.id);
          },
          child: Card(
            child: Column(
              children: <Widget>[
                //Hay articulo que no tienen imagenes entonces valido con un operador ternario
                ( producto.fotoUrl == null )
                ? Image(image: AssetImage('assets/no-image.png'),)
                : FadeInImage(
                  image: NetworkImage( producto.fotoUrl ),
                  placeholder: AssetImage('assets/jar-loading.gif'),
                  height: 300.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                ListTile(
                  title: Text('${producto.titulo} - ${producto.valor}'),
                  subtitle: Text('${ producto.id }'),
                  onTap: () => Navigator.pushNamed(context, 'producto',arguments: producto),
                ),

              ],
            ),
          )
    );
  }

  //ListTile(
  //  title: Text('${producto.titulo} - ${producto.valor}'),
  //  subtitle: Text('${ producto.id }'),
  //  onTap: () => Navigator.pushNamed(context, 'producto',arguments: producto),
  //),

  Widget _crearFABBoton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: ()=> Navigator.pushNamed(context, 'producto'),
    );
  }


}