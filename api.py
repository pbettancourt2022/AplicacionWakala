from flask import Flask, jsonify, request
from pymongo.mongo_client import MongoClient
from pymongo.server_api import ServerApi
import base64

app = Flask(__name__)

uri = "mongodb+srv://pbettancourt2022:G52fSWahF83hGiFS@cluster0.koogju6.mongodb.net/?retryWrites=true&w=majority"
client = MongoClient(uri, server_api=ServerApi('1'))
try:
    client.admin.command('ping')
    print("Pinged your deployment. You successfully connected to MongoDB!")
except Exception as e:
    print(e)
db =  client["demoUnab"]
user_collection =db["users"]
sectores = ["Mi casa", "Udec"]
descripciones = ["Que bonita que es mi casa, me encanta mi casa", "Es muy bonita la Udec pero no me gusta el fin de semestre"]
usuarios = ["Antonio@gmail.com", "Pablo@gmail.com"]
contrasenas = ["1234", "Pass"]
fechas = ["2023-12-01T10:00:00Z", "2023-12-02T12:30:00Z"]
imagenes1 = ["https://ejemplo.com/imagen1.jpg", "https://ejemplo.com/imagen3.jpg"]
imagenes2 = ["https://ejemplo.com/imagen2.jpg", "https://ejemplo.com/imagen4.jpg"]
sigue_ahi_count = [10, 8]
ya_no_esta_count = [5, 3]
comentarios=[
    {"1":"Comentario feo", "2":"Comentario bonito"},
    {"1":"Comentari para el 2", "2": "Comentario para el 2 pero feo"}
]

@app.route("/api/usuariocompro/<string:name>/<int:index>", methods=['GET'])
def get_name(name, index):
    if(usuarios[index]==name):
        return jsonify(name)
    return jsonify({"Mensaje":"No encontrado"}), 404

@app.route("/api/contracompro/<string:contra>/<int:index>", methods=['GET'])
def get_contra(contra, index):
    if(contrasenas[index]==contra):
        return jsonify(contra)
    return jsonify({"Mensaje":"No encontrado"}), 404

@app.route('/api/totalwakalas', methods=['GET'])
def get_totalwakalas():
    total_sectores = len(sectores)
    return str(total_sectores)

@app.route('/api/totalUsuario', methods=['GET'])
def get_totalUsuario():
    total_usuarios = len(usuarios)
    return str(total_usuarios)

@app.route('/api/sectores/<int:index>', methods=['GET'])
def get_sectores(index):
    if (len(sectores)>index):
        return jsonify(sectores[index])
    return jsonify({"Mensaje":"No encontrado"})

@app.route('/api/descripciones/<int:index>', methods=['GET'])
def get_descripciones(index):
    if (len(descripciones)>index):
        return jsonify(descripciones[index])
    return jsonify({"Mensaje":"No encontrado"})

@app.route('/api/usuarios/<int:index>', methods=['GET'])
def get_usuarios(index):
    if (len(usuarios)>index):
        return jsonify(usuarios[index])
    return jsonify({"Mensaje":"No encontrado"})

@app.route('/api/contrasenas/<int:index>', methods=['GET'])
def get_contrasenas(index): 
    if (len(contrasenas)>index):
        return jsonify(contrasenas[index])
    return jsonify({"Mensaje":"No encontrado"})

@app.route('/api/fechas/<int:index>', methods=['GET'])
def get_fechas(index):
    if (len(fechas)>index):
        return jsonify(fechas[index])
    return jsonify({"Mensaje":"No encontrado"})

@app.route('/api/imagenes1/<int:index>', methods=['GET'])
def get_imagenes1(index):
    if (len(imagenes1)>index):
        return jsonify(imagenes1[index])
    return jsonify({"Mensaje":"No encontrado"})

@app.route('/api/imagenes2/<int:index>', methods=['GET'])
def get_imagenes2(index):
    if (len(imagenes2)>index):
        return jsonify(imagenes2[index])
    return jsonify({"Mensaje":"No encontrado"})

@app.route('/api/sigue/<int:index>', methods=['GET'])
def get_sigue_ahi_count(index):
    if (len(sigue_ahi_count)>index):
        return jsonify(sigue_ahi_count[index])
    return jsonify({"Mensaje":"No encontrado"})

@app.route('/api/ya_no/<int:index>', methods=['GET'])
def get_ya_no_esta_count(index):
    if (len(ya_no_esta_count)>index):
        return jsonify(ya_no_esta_count[index])
    return jsonify({"Mensaje":"No encontrado"})

@app.route('/api/sectores', methods=['POST'])
def add_sector():
    new_sector = request.json.get('sectores', '')
    sectores.append(new_sector)
    return jsonify({'message': 'Sector agregado'}), 201

@app.route('/api/descripciones', methods=['POST'])
def add_descripcion():
    new_descripcion = request.json.get('descripciones', '')
    descripciones.append(new_descripcion)
    return jsonify({'message': 'Descripción agregada'}), 201

@app.route('/api/usuarios', methods=['POST'])
def add_usuario():
    new_usuario = request.json.get('usuarios', '')
    usuarios.append(new_usuario)
    return jsonify({'message': 'Usuario agregado'}), 201

@app.route('/api/contrasenas', methods=['POST'])
def add_contrasena():
    new_contrasena = request.json.get('contrasenas', '')
    contrasenas.append(new_contrasena)
    return jsonify({'message': 'Contrasena agregada'}), 201

@app.route('/api/fechas', methods=['POST'])
def add_fechas():
    new_fechas = request.json.get('fechas', '')
    fechas.append(new_fechas)
    return jsonify({'message': 'Fechas agregado'}), 201

@app.route('/api/imagenes1', methods=['POST'])
def add_imagenes1():
    new_imagenes1 = request.json.get('imagenes1', '')
    imagenes1.append(new_imagenes1)
    return jsonify({'message': 'Imagenes1 agregado'}), 201

@app.route('/api/imagenes2', methods=['POST'])
def add_imagenes2():
    new_imagenes2 = request.json.get('imagenes2', '')
    imagenes2.append(new_imagenes2)
    return jsonify({'message': 'Imagenes2 agregado'}), 201

@app.route('/api/sigue', methods=['POST'])
def add_sigue_ahi_count():
    new_sigue_ahi_count = request.json.get('sigue', '')
    sigue_ahi_count.append(new_sigue_ahi_count)
    return jsonify({'message': 'Sigue_ahi_count agregado'}), 201

@app.route('/api/ya_no', methods=['POST'])
def add_ya_no_esta_count():
    new_ya_no_esta_count = request.json.get('ya_no', '')
    ya_no_esta_count.append(new_ya_no_esta_count)
    return jsonify({'message': 'Ya_no_esta_count agregado'}), 201

@app.route('/api/comentarios', methods=['POST'])
def add_comentarios():
    new_comentario = request.json.get('comentarios', {})
    comentarios.append(new_comentario)
    return jsonify({'message': 'Comentario agregado'}), 201

@app.route('/api/comentariosyalisto', methods=['POST'])
def add_comentariosyalisto():
    new_comentariosyalisto = request.json.get('comentario', {})
    indice_lista = request.json.get('indice', None)  # Obtener el índice de la lista de comentarios

    if indice_lista is None or not isinstance(indice_lista, int):
        return jsonify({'error': 'Se requiere un índice válido'}), 400

    if indice_lista <= len(comentarios):
        comentarios[indice_lista].update(new_comentariosyalisto)
        return jsonify({'message': 'Comentario agregado en el índice proporcionado'}), 201
    else:
        return jsonify({'error': 'El índice de la lista de comentarios no existe'}), 404

@app.route('/api/cantidad_comentarios/<int:indice>', methods=['GET'])
def obtener_cantidad_comentarios_indice(indice):
    if indice < len(comentarios):
        cantidad = len(comentarios[indice])
        return jsonify(cantidad), 200
    else:
        return jsonify({'error': 'El índice especificado no existe'}), 404



@app.route('/api/comentarios', methods=['GET'])
def get_comentarios():
    return jsonify(comentarios)

@app.route('/api/comentarios/<int:index>', methods=['GET'])
def get_comentariosuno(index):
    if (len(comentarios)>index):
        return jsonify(comentarios[index])
    return jsonify({"Mensaje":"No encontrado"})

@app.route('/api/sigue/<int:index>', methods=['PUT'])
def update_sigue_ahi_count(index):
    if (len(sigue_ahi_count) > index):
        nuevo_valor = request.json.get('nuevo_valor')
        sigue_ahi_count[index] = nuevo_valor
        return jsonify({"message": "Sigue ahi count actualizado"}), 200
    return jsonify({"Mensaje": "No encontrado"}), 404

@app.route('/api/ya_no/<int:index>', methods=['PUT'])
def update_ya_no_esta_count(index):
    if (len(ya_no_esta_count) > index):
        nuevo_valor = request.json.get('nuevo_valor')
        ya_no_esta_count[index] = nuevo_valor
        return jsonify({"message": "Ya no está count actualizado"}), 200
    return jsonify({"Mensaje": "No encontrado"}), 404

if __name__ == '__main__':
    app.run(debug=True)
