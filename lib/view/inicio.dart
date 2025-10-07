import 'package:flutter_application_3/model/entrega.dart';
import 'package:flutter_application_3/theme/tema.dart';
import 'package:flutter_application_3/utils/formatos.dart';
import 'package:flutter_application_3/view/bottom.dart';
import 'package:flutter_application_3/view/menu.dart';
import 'package:flutter/material.dart';

class VistaInicio extends StatefulWidget {
  const VistaInicio({super.key, required this.title});

  final String title;

  @override
  State<VistaInicio> createState() => _VistaInicioState();
}

class _VistaInicioState extends State<VistaInicio> {
  int bottomIndex = 0;
  late List<Entrega> entregas;

  @override
  void initState() {
    entregas = Entrega.all();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 50),
        child: _paginaActual(),
      ),
      drawer: menu(context),
      bottomNavigationBar: menuBottom(context, bottomIndex, updateIndex()),
    );
  }

  Function updateIndex() {
    return (val) => setState(() {
          bottomIndex = val;
        });
  }

  Widget _paginaActual() {
    if (bottomIndex == 0) {
      return _pagina1();
    } else if (bottomIndex == 1) {
      return _pagina2();
    } else {
      return const Text('Ninguno');
    }
  }

  Widget _pagina1() {
    return ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            minVerticalPadding: 40,
            shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: MiTema.cafeClaro, width: 2)),
            leading: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), color: MiTema.verde),
              child: Text(
                '#${entregas[index].numero}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(Formatos.fecha(entregas[index].fecha)),
            subtitle: Text(entregas[index].descripcion),
            trailing: const Text(
              '--.-',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          );
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: MiTema.crema,
          );
        },
        itemCount: entregas.length);
  }

  Widget _pagina2() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _fotoAsesor(),
        _nombreAsesor(),
        _telefonoAsesor(),
        _emailAsesor()
      ],
    ));
  }

  Widget _fotoAsesor() {
    return const Icon(
      Icons.person_pin,
      size: 200,
    );
  }

  Widget _nombreAsesor() {
    return const Text(
      'Reynolds Bonifaz',
      style: TextStyle(fontSize: 20),
    );
  }

  Widget _telefonoAsesor() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 70),
      leading: const Icon(
        Icons.phone,
        size: 30,
      ),
      title: const Text(
        '91912345678',
        style: TextStyle(fontSize: 20),
      ),
      onTap: () {
        SnackBar mensaje = const SnackBar(content: Text('Llamar a asesor'));
        ScaffoldMessenger.of(context).showSnackBar(mensaje);
      },
    );
  }

  Widget _emailAsesor() {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      leading: const Icon(
        Icons.email,
        size: 30,
      ),
      title: const Text(
        'rbonifaz@laselva.edu.mx',
        style: TextStyle(fontSize: 20),
      ),
      onTap: () {
        SnackBar mensaje = const SnackBar(content: Text('Correo a asesor'));
        ScaffoldMessenger.of(context).showSnackBar(mensaje);
      },
    );
  }
}
