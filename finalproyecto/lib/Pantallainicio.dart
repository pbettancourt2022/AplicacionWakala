import 'dart:convert';
import 'package:finalproyecto/Listado.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Pantallainicio extends StatefulWidget {
  const Pantallainicio({Key? key}) : super(key: key);

  @override
  State<Pantallainicio> createState() => LoginScreenState();
}

class LoginScreenState extends State<Pantallainicio> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();

  String _usuario = '';
  String _contrasena = '';

  @override
  void dispose() {
    _usuarioController.dispose();
    _contrasenaController.dispose();
    super.dispose();
  }

  Future<void> comprobarusuario(String dato, String valor) async {
    final Map<String, dynamic> datos = {
      dato: valor,
    };

    final http.Response response = await http.get(
      Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/usuariocompro/$valor'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 201) {
      print('$dato guardado con éxito');
    } else {
      print('Error al guardar $dato');
    }
  }
  Future<void> comprobarcontra(String dato, String valor) async {
    final Map<String, dynamic> datos = {
      dato: valor,
    };

    final http.Response response = await http.get(
      Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/contracompro/$valor'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 201) {
      print('$dato guardado con éxito');
    } else {
      print('Error al guardar $dato');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wakala'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Image.asset(
                'assets/Wakala.png',
                height: 350,
                width: 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 100),
              TextField(
                controller: _usuarioController,
                onChanged: (value) {
                  setState(() {
                    _usuario = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Usuario',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _contrasenaController,
                onChanged: (value) {
                  setState(() {
                    _contrasena = value;
                  });
                },
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    
                    final usuario = _usuarioController.text;
                    final contrasena = _contrasenaController.text;

                    print('Usuario: $_usuario');
                    print('Contraseña: $_contrasena');
                    print('Campos verificados correctamente');
                    var response = await http.get(Uri.parse("https://54f5-152-74-52-253.ngrok-free.app/api/totalUsuario"));
                    int totalUsuario = int.parse(response.body);
                    print(response.body);
                    if (usuario.isNotEmpty && contrasena.isNotEmpty) {
                      bool aux= false;
                      int miusuario=0;
                      for(int i=0;i<totalUsuario;i++){
                        final responseUsuario = await http.get(
                          Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/usuariocompro/$usuario/$i'),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                        );

                        final responseContra = await http.get(
                          Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/contracompro/$contrasena/$i'),
                          headers: <String, String>{
                            'Content-Type': 'application/json; charset=UTF-8',
                          },
                        );
                        print("${responseUsuario.body} = $usuario");
                        print("${responseContra.body} = $contrasena");
                        if (responseUsuario.statusCode == 200 && responseContra.statusCode == 200) {
                          aux=true;
                          miusuario=i;
                        }
                      }
                        if (aux) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Listado(
                              miusuario: miusuario,
                              totalUsuario: totalUsuario,
                            )),
                          );
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Advertencia'),
                                  content: const Text('Usuario no encontrado'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Aceptar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          print('Error al verificar usuario o contraseña');
                        }
                      
                    } else {
                      print('El usuario o la contraseña están vacíos');
                    }
                  
                  },
                  child: const Text('Ingresar'),
                ),
                const SizedBox(height: 20),
                const Text(
                'Pablo Bettancourt',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }
}