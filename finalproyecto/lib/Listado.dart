import 'dart:convert';
import 'package:finalproyecto/AgregarWakala.dart';
import 'package:finalproyecto/DetalleWakala.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Listado extends StatefulWidget {
  int miusuario;
  int totalUsuario;

  Listado({
    Key? key,
    required this.miusuario, required this.totalUsuario,
     }) : super(key: key);

  @override
  State<Listado> createState() => _ListadoState();
}

class _ListadoState extends State<Listado> {
  List<String> sectores = [];
  List<String> descripciones = [];
  List<String> usuarios = [];
  List<String> fechas = [];
  List<String> imagenes1 = [];
  List<String> imagenes2 = [];
  List<int> sigueAhiCount = [];
  List<int> yaNoEstaCount = [];

  @override
  void initState() {
    super.initState();
    fetchWakalas();
  }

  Future<void> fetchWakalas() async {
    var response = await http.get(Uri.parse("https://54f5-152-74-52-253.ngrok-free.app/api/totalwakalas"));
    print(response.body);
    int totalWakalas = int.parse(response.body);

    try {
      for (var i = 0; i < totalWakalas; i++) {
        var usuarioResponse;
        var sectorResponse = await http.get(Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/sectores/$i'));
        print(sectorResponse.body);
        var descripcionResponse = await http.get(Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/descripciones/$i'));
        print(descripcionResponse.body);
        var response = await http.get(Uri.parse("https://54f5-152-74-52-253.ngrok-free.app/api/totalUsuario"));
        int totalUsuario = int.parse(response.body);
        print(widget.miusuario);
        print(totalUsuario);
        print("es igual a $i");
        if(totalUsuario<=i){
          usuarioResponse = await http.get(Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/usuarios/${widget.miusuario}'));
          print(usuarioResponse.body);
        }else{
          usuarioResponse = await http.get(Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/usuarios/$i'));
          print(usuarioResponse.body);
        }
        var fechaResponse = await http.get(Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/fechas/$i'));
        print(fechaResponse.body);
        var imagen1Response = await http.get(Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/imagenes1/$i'));
        print(imagen1Response.body);
        var imagen2Response = await http.get(Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/imagenes2/$i'));
        print(imagen2Response.body);
        var sigueAhiCountResponse = await http.get(Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/sigue/$i'));
        print(sigueAhiCountResponse.body);
        var yaNoEstaCountResponse = await http.get(Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/ya_no/$i'));
        print(yaNoEstaCountResponse.body);
        print('Sector $i: ${sectorResponse.body}');
        print('Descripción $i: ${descripcionResponse.body}');

        
        if (sectorResponse.statusCode == 200 &&
            descripcionResponse.statusCode == 200 &&
            usuarioResponse.statusCode == 200 &&
            fechaResponse.statusCode == 200 &&
            imagen1Response.statusCode == 200 &&
            imagen2Response.statusCode == 200 &&
            sigueAhiCountResponse.statusCode == 200 &&
            yaNoEstaCountResponse.statusCode == 200) {
          var sectorData = json.decode(sectorResponse.body);
          var descripcionData = json.decode(descripcionResponse.body);
          var usuarioData = json.decode(usuarioResponse.body);
          var fechaData = json.decode(fechaResponse.body);
          var imagen1Data = json.decode(imagen1Response.body);
          var imagen2Data = json.decode(imagen2Response.body);
          var sigueAhiCountData = json.decode(sigueAhiCountResponse.body);
          var yaNoEstaCountData = json.decode(yaNoEstaCountResponse.body);
          
          setState(() {
            sectores.add(sectorData);
            descripciones.add(descripcionData);
            usuarios.add(usuarioData);
            fechas.add(fechaData);
            imagenes1.add(imagen1Data);
            imagenes2.add(imagen2Data);
            sigueAhiCount.add(sigueAhiCountData);
            yaNoEstaCount.add(yaNoEstaCountData);
          });
        } else {
          print('Error en la solicitud HTTP para el índice $i');
        }
      }
    } catch (e) {
      print('Error al obtener datos dygdhkdfjg: $e');
    }
  }
  Future<void> _navigateToAddWakala() async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => AgregarWakala(miusuario: widget.miusuario, totalUsuario: widget.totalUsuario),
    ),
  );

  if (result != null && result is bool && result) {
    fetchWakalas();
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Wakalas'),
      ),
      body: ListView.builder(
        itemCount: sectores.length,
        itemBuilder: (context, index) {
          
          if(widget.totalUsuario<=index){
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalleWakala(
                            indice: index,
                            miusuario: widget.miusuario,
                          ),
                        ),
                      );
                    },
                    
                    child: Text('Sector: ${sectores[index]}, por ${usuarios[widget.miusuario]} ${fechas[index]}'),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            );
          }else{
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalleWakala(
                            indice: index,
                            miusuario: widget.miusuario,
                          ),
                        ),
                      );
                    },
                    
                    child: Text('Sector: ${sectores[index]}, por ${usuarios[index]} ${fechas[index]}'),
                  ),
                  SizedBox(height: 8),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AgregarWakala(miusuario: widget.miusuario, totalUsuario: widget.totalUsuario),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
