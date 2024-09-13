import 'package:acesso_mp/helpers/std_values.dart';
import 'package:acesso_mp/pages/control_pages.dart';
import 'package:acesso_mp/pages/login_page2.dart';
import 'package:acesso_mp/services/x_provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  //garante que o binding do Flutter esteja inicializado antes de executar qualquer código que dependa dele. No Flutter, o binding é a ponte entre o código Dart e a plataforma subjacente (Android ou iOS). Ele é responsável por fornecer acesso a recursos do sistema, como a câmera, armazenamento, rede, etc.
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(fileName: '../../.env');
  // String apiUrl =
  //     const String.fromEnvironment('URL_SUPABASE', defaultValue: 'default_key');
  // String apiKey =
  //     const String.fromEnvironment('ANONKEY', defaultValue: 'default_key');

  await Supabase.initialize(
      // url: dotenv.env['URL_SUPABASE']!,
      // anonKey: dotenv.env['ANONKEY']!,
      // url: apiUrl,
      // anonKey: apiKey,
      url: 'https://volhccyinzyybaunrryp.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZvbGhjY3lpbnp5eWJhdW5ycnlwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjI5NzY3MDIsImV4cCI6MjAzODU1MjcwMn0.sgT59XcSgDosrQ1Q8XgFHMhDH5fKhz0UEQFkrOLl6v0');

  await Hive.openBox('db');
  await Hive.box('db').putAll({'visitor': '', 'image': ''});

  try {
    cameras = await availableCameras();
  } catch (e) {
    debugPrint('Erro ao acessar câmera! $e');
  }

  runApp(ChangeNotifierProvider(
      create: (context) => XProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Acesso MP',
      theme: ThemeData(
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                elevation: 3,
                textStyle: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255)))),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 28),
          backgroundColor: Color.fromARGB(255, 14, 0, 167),
        ),
        scrollbarTheme: ScrollbarThemeData(
          thumbColor: WidgetStateColor.resolveWith((context) {
            return StdValues.btnBlue; // or any other color you want
          }),
          thickness: WidgetStateProperty.all(12),
        ),
        textTheme: const TextTheme(
            headlineLarge:
                TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage2(),
        '/home': (context) => ControlPages(
              cameras: cameras,
            ),
      },
    );
  }
}
