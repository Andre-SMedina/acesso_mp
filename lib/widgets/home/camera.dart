import 'dart:convert';
import 'dart:typed_data';
import 'package:acesso_mp/helpers/std_values.dart';
import 'package:acesso_mp/widgets/home/image_border.dart';
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

      setState(() {
        capturedImage = bytes;
      });

      controller!.dispose();
      controller = null;
    } catch (err) {
      debugPrint(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (controller != null && controller!.value.isInitialized)
            ImageBorder(
                height: StdValues.imgHeight1,
                width: StdValues.imgWidth1,
                widget: SizedBox(
                    height: StdValues.imgHeight1,
                    width: StdValues.imgWidth1,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(35),
                        child: CameraPreview(controller!)))),
          if (capturedImage == null && controller == null)
            ImageBorder(
              height: StdValues.imgHeight1,
              width: StdValues.imgWidth2,
              widget: Container(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage('assets/cam.png'),
                )),
              ),
            ),
          if (capturedImage != null && controller == null)
            ImageBorder(
              height: StdValues.imgHeight1,
              width: StdValues.imgWidth1,
              widget: ClipRRect(
                borderRadius: BorderRadius.circular(35),
                child: Image.memory(
                  capturedImage!,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: (controller == null) ? 180 : 210,
            child: MyButton(
              icon: Icons.camera_alt_outlined,
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
