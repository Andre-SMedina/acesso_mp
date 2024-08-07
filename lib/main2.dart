import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  try {
    await Supabase.initialize(
      url: 'https://volhccyinzyybaunrryp.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZvbGhjY3lpbnp5eWJhdW5ycnlwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjI5NzY3MDIsImV4cCI6MjAzODU1MjcwMn0.sgT59XcSgDosrQ1Q8XgFHMhDH5fKhz0UEQFkrOLl6v0',
    );

    await Supabase.instance.client.auth
        .signInWithPassword(email: 'admin@acessomp.com', password: '123');

    final supabase = Supabase.instance.client;

    // await supabase.from('visitors').insert({
    //   'name': 'jorge',
    //   'cpf': '222',
    //   'rg': '3',
    //   'phone': '3',
    //   'job': 'gari'
    // });

    var result = await supabase.from('visitors').select().eq('name', 'andre');
    print(result);
  } catch (e) {
    debugPrint('Erro enviado: ${e.toString()}');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Testando Supabase'),
        ),
      ),
    );
  }
}
