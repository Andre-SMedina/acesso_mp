import 'dart:convert';
import 'dart:typed_data';
import 'package:acesso_mp/widgets/my_button.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:hive/hive.dart';

class CameraApp extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Function alert;
  const CameraApp({super.key, required this.cameras, required this.alert});

  @override
  State<CameraApp> createState() => CameraAppState();
}

class CameraAppState extends State<CameraApp> {
  CameraController? controller;
  Uint8List? capturedImage;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // Função para inicializar a câmera
  Future<void> initializeCamera() async {
    controller = CameraController(widget.cameras[0], ResolutionPreset.low);
    await controller!.initialize();
    setState(() {});
  }

  // Função para capturar a imagem
  Future<void> captureImage(BuildContext context) async {
    try {
      if (controller == null || !controller!.value.isInitialized) {
        return;
      }

      if (controller!.value.isTakingPicture) {
        // Se já estiver tirando uma foto, saia
        return;
      }

      // é usado para capturar uma imagem usando a câmera controlada pelo controller
      final XFile imageFile = await controller!.takePicture();
      // o conteúdo do arquivo de imagem é lido como uma matriz de bytes
      final bytes = await imageFile.readAsBytes();
      // Essa matriz de bytes é então convertida em uma representação base64
      final base64Image = base64Encode(bytes);

      var box = Hive.box('db');
      box.put('image', base64Image);

      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setString('capturedImage', base64Image);

      setState(() {
        capturedImage = bytes;
      });

      // **Descartar o controlador após capturar a imagem**
      controller!.dispose();
      controller = null;
    } catch (e) {
      // ZshowDialogs.alert(context, 'A aplicação apresentou erro');
      widget.alert();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        children: [
          if (controller != null && controller!.value.isInitialized)
            SizedBox(
              height: 250, // Definindo a altura explicitamente
              width: 300, // Definindo a largura explicitamente
              child: CameraPreview(controller!),
            ),
          if (capturedImage == null && controller == null)
            const Icon(
              Icons.person_outline_outlined,
              size: 200,
            ),
          if (capturedImage != null && controller == null)
            SizedBox(
              height: 250,
              width: 300,
              child: Image.memory(
                capturedImage!,
                fit: BoxFit.cover,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0, bottom: 4.0),
            child: MyButton(
              callback: () {
                if (controller == null) {
                  initializeCamera();
                } else {
                  captureImage(context);
                }
              },
              text: controller == null ? 'Ligar Câmera' : 'Capturar Imagem',
            ),
          ),
        ],
      ),
    );
  }
}
