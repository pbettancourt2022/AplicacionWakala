import 'dart:convert';
import 'package:finalproyecto/Listado.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class AgregarWakala extends StatefulWidget {
  int miusuario;
  int totalUsuario;

  AgregarWakala({Key? key, required this.miusuario, required this.totalUsuario}) : super(key: key);

  @override
  State<AgregarWakala> createState() => _AgregarWakalaState();
}

class _AgregarWakalaState extends State<AgregarWakala> {
  final TextEditingController _sectorController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile1;
  XFile? _imageFile2;

  Future<void> _getImage(ImageSource source, int imageNumber) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    setState(() {
      if (imageNumber == 1) {
        _imageFile1 = pickedFile;
      } else {
        _imageFile2 = pickedFile;
      }
    });
  }

  Future<void> _uploadWakala() async {
    if (_sectorController.text.isEmpty ||
        _descripcionController.text.length < 15 ||
        _imageFile1 == null) {
      return;
    }

    try {
      await _postData('sectores', _sectorController.text);
      await _postData('descripciones', _descripcionController.text);
      await _postData('fechas', DateTime.now().toUtc().toIso8601String());
      await _postData('imagenes1', _imageFile1!.path);
      await _postData('imagenes2', _imageFile2?.path ?? ''); 
      await _postDatacoment();
      await _postDataint('sigue', 0); 
      await _postDataint('ya_no', 0);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Listado(miusuario: widget.miusuario, totalUsuario: widget.totalUsuario)),
        );
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _postData(String fieldName, String fieldValue) async {
    final Map<String, String> data = {
      fieldName: fieldValue
    };

    try {
      final http.Response response = await http.post(
        Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/$fieldName'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode != 201) {
        print(response.statusCode);
        throw Exception('Failed to upload $fieldName');
      }
    } catch (e) {
      throw Exception('Error sending $fieldName: $e');
    }
  }
  Future<void> _postDataint(String fieldName, int fieldValue) async {
    final Map<String, int> data = {
      fieldName: fieldValue
    };
    try {
      final http.Response response = await http.post(
        Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/$fieldName'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode != 201) {
        print(response.statusCode);
        throw Exception('Failed to upload $fieldName');
      }
    } catch (e) {
      throw Exception('Error sending $fieldName: $e');
    }
  }
  Future<void> _postDatacoment() async {
    final Map<dynamic, dynamic> data = {
      "comentarios": {
        "1": "Comentarios: "
      }
    };

    try {
      final http.Response response = await http.post(
        Uri.parse('https://54f5-152-74-52-253.ngrok-free.app/api/comentarios'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode != 201) {
        print(response.statusCode);
        throw Exception('Failed to upload comentarios');
      }
    } catch (e) {
      throw Exception('Error sending comentarios: $e');
    }
  }

  @override
  void dispose() {
    _sectorController.dispose();
    _descripcionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Agregar Nuevo Wakala'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextFormField(
                controller: _sectorController,
                decoration: const InputDecoration(labelText: 'Sector *'),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _descripcionController,
                decoration: const InputDecoration(labelText: 'Descripción *'),
                minLines: 5,
                maxLines: 10,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => _getImage(ImageSource.camera, 1),
                    child: const Text('Foto1'),
                  ),
                  ElevatedButton(
                    onPressed: () => _getImage(ImageSource.camera, 2),
                    child: const Text('Foto2'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _imagePreviewWidget(_imageFile1),
              _imagePreviewWidget(_imageFile2),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _uploadWakala,
                child: const Text('Denunciar wakala'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Me arrepentí'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imagePreviewWidget(XFile? imageFile) {
    if (imageFile != null) {
      return Column(
        children: [
          Image.file(File(imageFile.path)),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (imageFile == _imageFile1) {
                  _imageFile1 = null;
                } else {
                  _imageFile2 = null;
                }
              });
            },
            child: const Text('Borrar'),
          ),
        ],
      );
    } else {
      return const SizedBox();
    }
  }
}
