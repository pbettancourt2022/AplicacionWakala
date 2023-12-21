import 'dart:convert';

import 'package:finalproyecto/DetalleWakala.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Comentarios extends StatefulWidget {
  final int indice;
  final String sector;
  final int miusuario;

  const Comentarios({Key? key, required this.indice, required this.sector, required this.miusuario}) : super(key: key);

  @override
  _ComentariosState createState() => _ComentariosState();
}

class _ComentariosState extends State<Comentarios> {
  final TextEditingController _comentarioController = TextEditingController();
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
          
      
      var comentarioResponse = await http.get(Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/comentarios/${widget.indice}'));
      print(comentarioResponse.body);

      if (comentarioResponse.statusCode == 200) {
      

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
      } else {
        print('Error en la solicitud HTTP para el índice ${widget.indice}');
      }
    
    } catch (e) {
      print('Error al obtener datos dygdhkdfjg: $e');
    }
  }
  Future<void> addComentario(int index, String comentario) async {
    var cantidad_comentariosResponse = await http.get(Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/cantidad_comentarios/$index'));
    int totalcoment = int.parse(cantidad_comentariosResponse.body);
    totalcoment++;
    print(totalcoment);
    print(index);
  final Map<String, dynamic> data = {
    "comentario": {totalcoment.toString(): comentario},
    "indice": index
  };

  try {
    final http.Response response = await http.post(
      Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/comentariosyalisto'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      print('Comentario agregado');
    } else {
      print('Error al agregar el comentario: ${response.statusCode}');
    }
  } catch (e) {
    print('Error al enviar el comentario: $e');
  }
}
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, true);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Comentarios - ${widget.sector}'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: comentarios.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(comentarios[index]),
                    );
                  },
                ),
              ),
              TextField(
                controller: _comentarioController,
                maxLines: null, 
                decoration: const InputDecoration(
                  hintText: 'Añadir comentario...',
                  suffixIcon: Icon(Icons.comment),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  final nuevoComentario = _comentarioController.text;
                  if (nuevoComentario.isNotEmpty) {
                    addComentario(widget.indice, nuevoComentario);

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Comentario guardado')),
                    );

                    Future.delayed(const Duration(seconds: 2), () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetalleWakala(
                          indice: widget.indice,
                          miusuario: widget.miusuario,
                        ),),
                        );
                    });
                  }
                },
                child: const Text('Agregar comentario'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }
}
