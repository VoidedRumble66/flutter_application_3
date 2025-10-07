import 'package:flutter_application_3/theme/tema.dart';
import 'package:flutter_application_3/view/inicio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: MiTema.temaApp(context),
      home: const MyHomePage(title: 'Mi App'),
      routes: {
        '/inicio': (context) => const VistaInicio(title: 'Inicio'),
        '/login': (context) => const MyHomePage(title: 'UTSelva - Estadías'),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _ctrlEmail = TextEditingController();
  final TextEditingController _ctrlPwd = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 50),
        child: _columna(),
      ),
    );
  }

  Widget _columna() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _iconoPersona(),
        _txtEmail(),
        _txtPassword(),
        _divisor(),
        _boton(),
      ],
    );
  }

  Widget _iconoPersona() {
    return Icon(Icons.person, size: 100, color: MiTema.verde);
  }

  Widget _txtEmail() {
    return TextField(
      controller: _ctrlEmail,
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: "Email",
        labelStyle: TextStyle(fontSize: 24, color: MiTema.cafeRojizo),
      ),
    );
  }

  Widget _txtPassword() {
    return TextField(
      controller: _ctrlPwd,
      textAlign: TextAlign.center,
      obscureText: true,
      decoration: InputDecoration(
        labelText: "Contraseña",
        labelStyle: TextStyle(fontSize: 24, color: MiTema.cafeRojizo),
      ),
    );
  }

  Widget _divisor() {
    return const Divider(height: 30, color: Color.fromARGB(0, 0, 0, 0));
  }

  Widget _boton() {
    return TextButton.icon(
      onPressed: _ingresar,
      style: ButtonStyle(
        backgroundColor: WidgetStateColor.resolveWith((states) => MiTema.verde),
        shape: const WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        ),
      ),
      icon: const Icon(Icons.door_front_door, size: 34),
      label: const Text("Ingresar", style: TextStyle(fontSize: 24)),
    );
  }

  void _ingresar() {
    //PENDIENTE: vincular a la bd y validar correctamente
    //Por el momento se valida con admin / 4dm1n
    String txt = 'Usuario y/o contraseña incorrecta';
    if (_ctrlEmail.value.text == 'admin' && _ctrlPwd.value.text == '4dm1n') {
      //Usuario válido
      txt = 'Bienvenido';
      Navigator.pushNamed(context, '/inicio');
    }
    SnackBar mensaje = SnackBar(content: Text(txt));
    ScaffoldMessenger.of(context).showSnackBar(mensaje);
  }
}
