import 'package:flutter/material.dart';
import '../models/atividade_data.dart';
import 'resumo_screen.dart';

class ConfiguracaoScreen extends StatefulWidget {
  const ConfiguracaoScreen({super.key});

  @override
  State<ConfiguracaoScreen> createState() => _ConfiguracaoScreenState();
}

class _ConfiguracaoScreenState extends State<ConfiguracaoScreen> {
  AtividadeData dados = AtividadeData();

  final nomeCtrl = TextEditingController();
  final respCtrl = TextEditingController();
  final localCtrl = TextEditingController();

  void limparFormulario() {
    setState(() {
      dados = AtividadeData();
      nomeCtrl.clear();
      respCtrl.clear();
      localCtrl.clear();
    });
  }

  void selecionarTipo(String tipo) {
    setState(() {
      dados.tipo = tipo;
  
      if (tipo == 'Palestra') {
        dados.recursos['Projetor'] = true;
      }
    });
  }

  void finalizar() {
    if (!dados.pronta) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Faltam preencher: ${dados.camposFaltando.join(', ')}.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ResumoScreen(dados: dados)),
    );
  }

  @override
  void dispose() {
    nomeCtrl.dispose();
    respCtrl.dispose();
    localCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuração da Atividade')),
      drawer: _buildDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildInformacoesIniciais(),
          const SizedBox(height: 20),
          _buildTipoAtividade(),
          const SizedBox(height: 20),
          _buildDuracao(),
          const SizedBox(height: 12),
          _buildRecursos(),
          const SizedBox(height: 20),
          _buildCapacidade(),
          const SizedBox(height: 20),
          _buildPreVisualizacao(),
          const SizedBox(height: 12),
          Text('Etapas concluídas: ${dados.etapasConcluidas} de 7',
              style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 80),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: finalizar,
        icon: const Icon(Icons.fact_check),
        label: Text('Analisar - ${dados.etapasConcluidas} de 7'),
      ),
    );
  }
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            child: Text('Feira Escolar', style: TextStyle(color: Colors.white, fontSize: 22)),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Nova atividade'),
            onTap: () {
              limparFormulario();
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.description),
            title: const Text('Atividade atual'),
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(dados.nome.isEmpty
                      ? 'Nenhuma atividade configurada ainda.'
                      : 'Atividade atual: ${dados.nome}'),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.cleaning_services),
            title: const Text('Limpar formulário'),
            onTap: () {
              limparFormulario();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Formulário limpo com sucesso.')),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Sobre o evento'),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Sobre o evento'),
                  content: const Text(
                      'Feira escolar com apresentações, oficinas e exposições. '
                      'Use este app para configurar e analisar cada atividade antes do cadastro.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Fechar')),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
  Widget _buildInformacoesIniciais() {
    return Column(
      children: [
        TextField(
          controller: nomeCtrl,
          decoration: const InputDecoration(labelText: 'Nome da atividade', border: OutlineInputBorder()),
          onChanged: (v) => setState(() => dados.nome = v),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: respCtrl,
          decoration: const InputDecoration(labelText: 'Nome do responsável', border: OutlineInputBorder()),
          onChanged: (v) => setState(() => dados.responsavel = v),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: localCtrl,
          decoration: const InputDecoration(labelText: 'Sala ou local', border: OutlineInputBorder()),
          onChanged: (v) => setState(() => dados.local = v),
        ),
      ],
    );
  }
  Widget _buildTipoAtividade() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Tipo de atividade', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AtividadeData.icones.keys.map((tipo) {
            final selecionado = dados.tipo == tipo;
            return ChoiceChip(
              label: Text(tipo),
              avatar: Icon(AtividadeData.icones[tipo], size: 18),
              selected: selecionado,
              onSelected: (_) => selecionarTipo(tipo),
            );
          }).toList(),
        ),
      ],
    );
  }
  Widget _buildDuracao() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Duração da atividade', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text(dados.duracaoFormatada, style: const TextStyle(fontSize: 18, color: Colors.indigo)),
        Slider(
          value: dados.duracao,
          min: 15,
          max: 180,
          divisions: (180 - 15) ~/ 5,
          label: dados.duracaoFormatada,
          onChanged: (v) => setState(() => dados.duracao = v),
        ),
        if (dados.tipo == 'Competição' && dados.duracao < 60)
          const Padding(
            padding: EdgeInsets.only(bottom: 8),
            child: Text(
              '⚠ Competições devem ter duração mínima de 60 minutos.',
              style: TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
  Widget _buildRecursos() {
    return Column(
      children: [
        Card(
          child: ExpansionTile(
            title: const Text('Recursos necessários'),
            subtitle: Text('${dados.recursosAtivos} recurso(s) ativado(s)'),
            onExpansionChanged: (aberto) {
              setState(() => dados.recursosAnalisados = true);
            },
            children: dados.recursos.keys.map((recurso) {
              return SwitchListTile(
                title: Text(recurso),
                value: dados.recursos[recurso]!,
                onChanged: (v) => setState(() => dados.recursos[recurso] = v),
                subtitle: recurso == 'Sistema de som' &&
                        dados.tipo == 'Apresentação cultural' &&
                        dados.recursos['Sistema de som'] != true
                    ? const Text('Recomendado para este tipo de atividade',
                        style: TextStyle(color: Colors.orange))
                    : null,
              );
            }).toList(),
          ),
        ),
        if (dados.recursos['Computadores'] == true && dados.capacidade > 30)
          const Padding(
            padding: EdgeInsets.only(top: 8),
            child: Text(
              '⚠ Verifique se o laboratório possui computadores suficientes.',
              style: TextStyle(color: Colors.red),
            ),
          ),
      ],
    );
  }
  Widget _buildCapacidade() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quantidade máxima de participantes',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        Text('${dados.capacidade.round()} participantes — ${dados.classificacao}',
            style: const TextStyle(fontSize: 16, color: Colors.indigo)),
        Slider(
          value: dados.capacidade,
          min: 5,
          max: 100,
          divisions: 95,
          label: '${dados.capacidade.round()}',
          onChanged: (v) => setState(() => dados.capacidade = v),
        ),
      ],
    );
  }

  Widget _buildPreVisualizacao() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Pré-visualização', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(vertical: dados.tipo == null ? 4 : 0),
          decoration: BoxDecoration(
            color: (dados.tipo == null ? Colors.grey : AtividadeData.cores[dados.tipo]!).withOpacity(0.12),
            border: Border.all(
              color: dados.tipo == null ? Colors.grey : AtividadeData.cores[dados.tipo]!,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(dados.tipo == null ? 8 : 16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: dados.tipo == null ? 2 : 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(dados.tipo == null ? Icons.help_outline : AtividadeData.icones[dados.tipo],
                      color: dados.tipo == null ? Colors.grey : AtividadeData.cores[dados.tipo]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      dados.nome.isEmpty ? 'Nome da atividade' : dados.nome,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text('Tipo: ${dados.tipo ?? 'não selecionado'}'),
              Text('Duração: ${dados.duracaoFormatada}'),
              Text('Participantes: ${dados.capacidade.round()} (${dados.classificacao})'),
              Text('Recursos ativados: ${dados.recursosAtivos}'),
              if (dados.tipo == null)
                const Text('Selecione um tipo para ver mais detalhes.', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      ],
    );
  }
}