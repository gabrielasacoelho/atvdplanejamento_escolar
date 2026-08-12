import 'package:flutter/material.dart';
import 'screens/configuracao_screen.dart';

void main() => runApp(const EventoApp());

class EventoApp extends StatelessWidget {
  const EventoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Planejador de Evento Escolar',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const ConfiguracaoScreen(),
    );
  }
}