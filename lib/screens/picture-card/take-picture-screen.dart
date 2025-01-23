import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tcg_scanner/constants.dart';
import 'package:tcg_scanner/screens/picture-card/display-picture-screen.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({super.key, required this.camera});

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<String> _saveImage(File image) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final savedImage = await image.copy(imagePath);
      return savedImage.path;
    } catch (e) {
      print("Error saving image: $e");
      rethrow;
    }
  }

  // Função para enviar a imagem para a API
  Future<Map<String, dynamic>> _uploadImage(File image) async {
    String url = '$ipAdress:8080/cards/identify';

    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Cria o arquivo Multipart
    var pic = await http.MultipartFile.fromPath(
      'image',
      image.path,
      contentType: MediaType('image', 'jpeg'),
    );

    // Adiciona o header de autenticação
    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });

    request.files.add(pic);

    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        // Lê o corpo da resposta
        final responseBody = await response.stream.bytesToString();
        final Map<String, dynamic> jsonResponse = json.decode(responseBody);
        print('Imagem enviada com sucesso!');
        print('Resposta: $jsonResponse');
        return jsonResponse; // Retorna o JSON como mapa
      } else {
        print('Erro ao enviar a imagem. Código: ${response.statusCode}');
        throw Exception('Erro ao enviar a imagem.');
      }
    } catch (e) {
      print('Erro: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tire uma foto')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return SizedBox.expand(
              child: CameraPreview(_controller),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryLightColor,
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();

            final savedPath = await _saveImage(File(image.path));

            // Envia a imagem para a API antes de navegar para a próxima tela
            final Map<String, dynamic> cardData = await _uploadImage(File(savedPath));

            if (!context.mounted) return;

            // Navega para a próxima tela com a resposta
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  imagePath: cardData['urlImage'] ?? savedPath,
                  cardData: cardData, // JSON com os dados da carta
                ),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt, color: kPrimaryColor),
      ),
    );
  }
}
