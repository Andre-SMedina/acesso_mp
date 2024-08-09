import 'package:acesso_mp/pages/home_page.dart';
import 'package:acesso_mp/pages/login_page.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
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

  runApp(const MyApp());
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
                side: const BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
                elevation: 3,
                textStyle: const TextStyle(color: Colors.black))),
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(color: Colors.white, fontSize: 28),
          backgroundColor: Color.fromARGB(255, 14, 0, 167),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(borderSide: BorderSide()),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 2, color: Color.fromARGB(255, 14, 0, 167)),
          ),
        ),
        textTheme: const TextTheme(
            headlineLarge:
                TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) => HomePage(
              cameras: cameras,
            ),
      },
    );
  }
}
