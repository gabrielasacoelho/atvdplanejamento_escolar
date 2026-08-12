import 'package:flutter/material.dart';

class AtividadeData {
  String nome = '';
  String responsavel = '';
  String local = '';
  String? tipo;
  double duracao = 60;
  double capacidade = 20;
  Map<String, bool> recursos = {
    'Projetor': false,
    'Computadores': false,
    'Sistema de som': false,
    'Acesso à internet': false,
    'Mesas adicionais': false,
  };
  bool recursosAnalisados = false; 
  static const Map<String, IconData> icones = {
    'Oficina': Icons.build,
    'Palestra': Icons.mic,
    'Exposição': Icons.museum,
    'Competição': Icons.emoji_events,
    'Apresentação cultural': Icons.theater_comedy,
  };

  static const Map<String, Color> cores = {
    'Oficina': Colors.teal,
    'Palestra': Colors.blue,
    'Exposição': Colors.purple,
    'Competição': Colors.orange,
    'Apresentação cultural': Colors.pink,
  };

  String get classificacao {
    final c = capacidade.round();
    if (c <= 20) return 'Atividade pequena';
    if (c <= 50) return 'Atividade média';
    return 'Atividade grande';
  }

  int get recursosAtivos => recursos.values.where((v) => v).length;

  String get duracaoFormatada {
    final total = duracao.round();
    final horas = total ~/ 60;
    final minutos = total % 60;
    if (horas == 0) return '$minutos minutos';
    if (minutos == 0) return horas == 1 ? '1 hora' : '$horas horas';
    final textoHoras = horas == 1 ? '1 hora' : '$horas horas';
    return '$textoHoras e $minutos minutos';
  }

  List<String> get avisos {
    final lista = <String>[];
    if (recursos['Computadores'] == true && capacidade > 30) {
      lista.add('Verifique se o laboratório possui computadores suficientes.');
    }
    if (tipo == 'Competição' && duracao < 60) {
      lista.add('Competições devem ter duração mínima de 60 minutos.');
    }
    if (tipo == 'Apresentação cultural' && recursos['Sistema de som'] != true) {
      lista.add('Sistema de som é recomendado para apresentações culturais.');
    }
    if (capacidade > 50 && recursos['Mesas adicionais'] != true) {
      lista.add('Atividade grande sem mesas adicionais.');
    }
    return lista;
  }

  List<String> get camposFaltando {
    final faltando = <String>[];
    if (nome.trim().isEmpty) faltando.add('nome da atividade');
    if (responsavel.trim().isEmpty) faltando.add('responsável');
    if (local.trim().isEmpty) faltando.add('sala ou local');
    if (tipo == null) faltando.add('tipo de atividade');
    if (capacidade < 5 || capacidade > 100) faltando.add('quantidade de participantes');
    return faltando;
  }

  bool get pronta => camposFaltando.isEmpty;

  int get etapasConcluidas {
    int n = 0;
    if (nome.trim().isNotEmpty) n++;
    if (responsavel.trim().isNotEmpty) n++;
    if (local.trim().isNotEmpty) n++;
    if (tipo != null) n++;
    if (duracao >= 15 && duracao <= 180) n++;
    if (capacidade >= 5 && capacidade <= 100) n++;
    if (recursosAnalisados) n++;
    return n;
  }
}