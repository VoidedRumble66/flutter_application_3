import 'package:flutter_application_3/theme/tema.dart';
import 'package:flutter/material.dart';

Drawer menu(BuildContext context) {
  return Drawer(
    backgroundColor: MiTema.verde,
    child: Column(
      children: [
        _encabezado(context),
        _opcion1(context),
        _opcion2(context),
        _opcion3(context),
        _opcion4(context),
        const Divider(),
        _salir(context),
      ],
    ),
  );
}

Widget _encabezado(BuildContext context) {
  return DrawerHeader(
    child: ListTile(
      title: Text(
        'Estadías - UTSelva',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontStyle: FontStyle.italic,
          color: MiTema.crema,
        ),
      ),
      subtitle: Text('admin', style: TextStyle(color: MiTema.crema)),
    ),
  );
}

Widget _opcion1(BuildContext context) {
  return _opcion(Icons.access_alarm, 'Opción 1', () {
    Navigator.pop(context);
    SnackBar mensaje = const SnackBar(content: Text('Opción 1'));
    ScaffoldMessenger.of(context).showSnackBar(mensaje);
  });
}

Widget _opcion2(BuildContext context) {
  return _opcion(Icons.adobe_outlined, 'Opción 2', () {
    Navigator.pop(context);
    SnackBar mensaje = const SnackBar(content: Text('Opción 2'));
    ScaffoldMessenger.of(context).showSnackBar(mensaje);
  });
}

Widget _opcion3(BuildContext context) {
  return _opcion(Icons.auto_fix_normal_rounded, 'Opción 3', () {
    Navigator.pop(context);
    SnackBar mensaje = const SnackBar(content: Text('Opción 3'));
    ScaffoldMessenger.of(context).showSnackBar(mensaje);
  });
}

Widget _opcion4(BuildContext context) {
  return _opcion(Icons.border_vertical_outlined, 'Opción 4', () {
    Navigator.pop(context);
    SnackBar mensaje = const SnackBar(content: Text('Opción 4'));
    ScaffoldMessenger.of(context).showSnackBar(mensaje);
  });
}

Widget _salir(BuildContext context) {
  return _opcion(Icons.exit_to_app, 'Salir', () {
    Navigator.pop(context);
    SnackBar mensaje = const SnackBar(content: Text('Salir'));
    ScaffoldMessenger.of(context).showSnackBar(mensaje);
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  });
}

Widget _opcion(IconData icono, String texto, Function() accion) {
  return MenuItemButton(
    leadingIcon: Icon(icono, color: MiTema.crema),
    onPressed: accion,
    child: Text(texto, style: TextStyle(color: MiTema.crema)),
  );
}
