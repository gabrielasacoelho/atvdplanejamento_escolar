import 'package:flutter/material.dart';
import '../models/atividade_data.dart';

class ResumoScreen extends StatelessWidget {
  final AtividadeData dados;
  const ResumoScreen({super.key, required this.dados});

  @override
  Widget build(BuildContext context) {
    final avisos = dados.avisos;
    final situacaoPronta = avisos.isEmpty;
    final progresso = dados.etapasConcluidas / 7;

    return Scaffold(
      appBar: AppBar(title: const Text('Resumo e Análise')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSituacaoGeral(situacaoPronta, avisos),
          const SizedBox(height: 24),
          _buildBarraPreparacao(progresso),
          const SizedBox(height: 24),
          _buildTabelaInformacoes(situacaoPronta),
        ],
      ),
    );
  }
  Widget _buildSituacaoGeral(bool situacaoPronta, List<String> avisos) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: situacaoPronta ? Colors.green.withOpacity(0.15) : Colors.orange.withOpacity(0.15),
        border: Border.all(color: situacaoPronta ? Colors.green : Colors.orange, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(situacaoPronta ? Icons.check_circle : Icons.warning_amber_rounded,
              color: situacaoPronta ? Colors.green : Colors.orange, size: 32),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  situacaoPronta ? 'Pronta para cadastro' : 'Requer atenção',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: situacaoPronta ? Colors.green[800] : Colors.orange[800],
                  ),
                ),
                if (!situacaoPronta)
                  ...avisos.map((a) => Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text('• $a', style: const TextStyle(fontSize: 13)),
                      )),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildBarraPreparacao(double progresso) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Preparação do cadastro', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progresso,
            minHeight: 14,
            backgroundColor: Colors.grey[300],
            color: Colors.indigo,
          ),
        ),
        const SizedBox(height: 4),
        Text('${dados.etapasConcluidas} de 7 etapas concluídas (${(progresso * 100).round()}%)'),
      ],
    );
  }
  Widget _buildTabelaInformacoes(bool situacaoPronta) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Informações da atividade', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 8),
        Table(
          border: TableBorder.all(color: Colors.grey.shade300),
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1.4),
          },
          children: [
            _linha('Atividade', dados.nome),
            _linha('Responsável', dados.responsavel),
            _linha('Local', dados.local),
            _linha('Tipo', dados.tipo ?? '-'),
            _linha('Duração', dados.duracaoFormatada),
            _linha('Capacidade', '${dados.capacidade.round()} participantes'),
            _linha('Classificação', dados.classificacao),
            _linha('Recursos ativos', '${dados.recursosAtivos}'),
            _linha('Situação', situacaoPronta ? 'Pronta para cadastro' : 'Requer atenção'),
          ],
        ),
      ],
    );
  }

  TableRow _linha(String chave, String valor) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(chave, style: const TextStyle(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(valor, softWrap: true),
        ),
      ],
    );
  }
}