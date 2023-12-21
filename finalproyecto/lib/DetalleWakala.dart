import 'dart:convert';
import 'package:finalproyecto/Comentarios.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetalleWakala extends StatefulWidget {
  final int indice;
  final int miusuario;
  DetalleWakala({
    Key? key,
    required this.indice,
    required this.miusuario,
  }) : super(key: key);

  @override
  _DetalleWakalaState createState() => _DetalleWakalaState();
}

class _DetalleWakalaState extends State<DetalleWakala> {
  String sectores = "";
  String descripciones = "";
  String usuarios = "";
  String fechas = "";
  //String imagenes1 = "";
  //String imagenes2 = "";
  int sigueAhiCount = 0;
  int yaNoEstaCount = 0;
  List<String> comentarios = [];

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
      var usuarioResponse;
      var sectorResponse = await http.get(Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/sectores/${widget.indice}'));
      var descripcionResponse = await http.get(Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/descripciones/${widget.indice}'));
      var response = await http.get(Uri.parse("https://54f5-152-74-52-253.ngrok-free.app/api/totalUsuario"));
      int totalUsuario = int.parse(response.body);
      if(totalUsuario<=widget.indice){
          usuarioResponse = await http.get(Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/usuarios/${widget.miusuario}'));
          print(usuarioResponse.body);
        }else{
          usuarioResponse = await http.get(Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/usuarios/${widget.indice}'));
          print(usuarioResponse.body);
        }
      var fechaResponse = await http.get(Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/fechas/${widget.indice}'));
      //var imagen1Response = await http.get(Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/imagenes1/${widget.indice}'));
      //var imagen2Response = await http.get(Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/imagenes2/${widget.indice}'));
      var sigueAhiCountResponse = await http.get(Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/sigue/${widget.indice}'));
      var yaNoEstaCountResponse = await http.get(Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/ya_no/${widget.indice}'));
      var comentarioResponse = await http.get(Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/comentarios/${widget.indice}'));
      print(comentarioResponse.body);

      if (sectorResponse.statusCode == 200 &&
          descripcionResponse.statusCode == 200 &&
          usuarioResponse.statusCode == 200 &&
          fechaResponse.statusCode == 200 &&
          //imagen1Response.statusCode == 200 &&
          //imagen2Response.statusCode == 200 &&
          sigueAhiCountResponse.statusCode == 200 &&
          yaNoEstaCountResponse.statusCode == 200 && comentarioResponse.statusCode == 200) {
        var sectorData = json.decode(sectorResponse.body);
        var descripcionData = json.decode(descripcionResponse.body);
        var usuarioData = json.decode(usuarioResponse.body);
        var fechaData = json.decode(fechaResponse.body);
        //var imagen1Data = json.decode(imagen1Response.body);
        //var imagen2Data = json.decode(imagen2Response.body);
        var sigueAhiCountData = json.decode(sigueAhiCountResponse.body);
        var yaNoEstaCountData = json.decode(yaNoEstaCountResponse.body);
        var comentarioData = json.decode(comentarioResponse.body);
        if (comentarioData is Map<String, dynamic>) {
          comentarioData.forEach((key, value) {
            setState(() {
              comentarios.add(value.toString());
            });
          });
        } else {
          print('Los comentarios no se recibieron como se esperaba.');
        }
        setState(() {
          sectores = sectorData;
          descripciones = descripcionData;
          usuarios = usuarioData;
          fechas = fechaData;
          //imagenes1 = imagen1Data;
          //imagenes2 = imagen2Data;
          sigueAhiCount = sigueAhiCountData;
          yaNoEstaCount = yaNoEstaCountData;
        });
      } else {
        print('Error en la solicitud HTTP para el índice ${widget.indice}');
      }
    } catch (e) {
      print('Error al obtener datos: $e');
    }
  }

  Future<void> actualizarContadorSigueAhi(String fieldName, int fieldValue, int indice) async {
    final Map<String, int> data = { fieldName: fieldValue };
    try {
      var response = await http.put(
        Uri.parse("https://54f5-152-74-52-253.ngrok-free.app/api/sigue/$indice"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        print('Sigue ahi count actualizado con éxito');
      } else {
        print('Error al actualizar contador "Sigue ahí": ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> actualizarContadorYaNoEsta(String fieldName, int fieldValue, int indice) async {
    final Map<String, int> data = { fieldName: fieldValue };
    try {
      var response = await http.put(
        Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/ya_no/$indice'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      if (response.statusCode == 200) {
        print('Ya no está count actualizado con éxito');
      } else {
        print('Error al actualizar contador "Ya No Esta": ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(sectores),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(descripciones),
          //Image.network(imagenes1), // Imagen 1
          //Image.network(imagenes2), // Imagen 2
          Text('Usuario: $usuarios'),
          Text('Fecha: ${fechas.toString()}'),
          Row(
            children: [
              ElevatedButton(
                onPressed: () async {
                  sigueAhiCount++;
                  await actualizarContadorSigueAhi('nuevo_valor', sigueAhiCount, widget.indice);
                  setState(() {});
                },
                child: Text('Sigue ahí ($sigueAhiCount)'),
              ),
              ElevatedButton(
                onPressed: () async {
                  yaNoEstaCount++;
                  await actualizarContadorYaNoEsta('nuevo_valor', yaNoEstaCount, widget.indice);
                  setState(() {});
                },
                child: Text('Ya no está ($yaNoEstaCount)'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          FutureBuilder<List<String>>(
            future: fetchComentarios(), 
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(snapshot.data![index]),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text('Error al cargar los comentarios');
              }
              return CircularProgressIndicator(); 
            },
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Comentarios(sector: sectores, indice: widget.indice, miusuario:widget.miusuario),
                ),
              );
            },
            child: const Text('Comentar'),
          ),
        ],
      ),
    );
  }

  Future<List<String>> fetchComentarios() async {
    return comentarios;
  }
}
