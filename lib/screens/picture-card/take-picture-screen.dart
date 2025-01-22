import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
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
  Future<void> _uploadImage(File image) async {
    String url =
        'https://27be-2804-29b8-50d4-825e-e078-4999-5b88-73ab.ngrok-free.app/cards/identify';

    var request = http.MultipartRequest('POST', Uri.parse(url));

    // Usando o MediaType corretamente
    var pic = await http.MultipartFile.fromPath(
      'image',
      image.path,
      contentType:
          MediaType('image', 'jpeg'), // Ou 'image', 'png' dependendo da imagem
    );

    // Adiciona o header de autenticação
    request.headers.addAll({
      'Authorization':
          'Bearer eyJhbGciOiJSUzI1NiJ9.eyJzdWIiOiJhZG1pbkBlbWFpbC5jb20iLCJzY29wZSI6ImFkbWluIiwiaXNzIjoic2VsZiIsImV4cCI6MTczNzUwOTI0MSwiaWF0IjoxNzM3NTA1NjQxLCJ1c2VySWQiOjJ9.nzkWvbd14CdzN5-BjzCUAAn_-I8XSTPyc_nzQEFgv0cEG4RY-JZaTPufcJUmI_QiWa-5ZtWxpluytaFAbYGZuR-9iVMxkvAvANJm5zeyQogoR5a6uFP46N2pUAz6bpyWBK8zEegag8BaQcr63UuKAIjDMVhAxi7SCOWXT01lDvD5RdBZHi8C-Oh41hn-Jl3BvIuF2Nr09rrmdCnf7oRBSB1Wlr5JheG7yr4-jXsEyrN9-TnQwFqw5w48y2pD9nyPlE6lQyzlxLF0MZVrnBYbGN68ZYzn9btGYMuC2J7z58fD-tQv4NAmUTVoZ5_q-vN45jQlY_xJL0UxbCGE75NZuA',
    });

    request.files.add(pic);

    var response = await request.send();
    if (response.statusCode == 200) {
      print('Imagem enviada com sucesso!');
    } else {
      print('Erro ao enviar a imagem.');
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
        onPressed: () async {
          try {
            await _initializeControllerFuture;
            final image = await _controller.takePicture();

            final savedPath = await _saveImage(File(image.path));

            // Envia a imagem para a API antes de navegar para a próxima tela
            // await _uploadImage(File(savedPath));

            if (!context.mounted) return;

            await Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    DisplayPictureScreen(imagePath: savedPath),
              ),
            );
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
