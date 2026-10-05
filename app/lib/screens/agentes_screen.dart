import 'package:flutter/material.dart';

import '../models/agente.dart';
import '../services/api_client.dart';

class AgentesScreen extends StatefulWidget {
  const AgentesScreen({super.key});

  @override
  State<AgentesScreen> createState() => _AgentesScreenState();
}

class _AgentesScreenState extends State<AgentesScreen> {
  final ApiClient _apiClient = ApiClient();
  late Future<List<Agente>> _futureAgentes;

  @override
  void initState() {
    super.initState();
    _futureAgentes = _apiClient.listarAgentes();
  }

  Future<void> _recarregar() {
    final futuro = _apiClient.listarAgentes();
    setState(() {
      _futureAgentes = futuro;
    });
    return futuro;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Agentes')),
      body: RefreshIndicator(
        onRefresh: _recarregar,
        child: FutureBuilder<List<Agente>>(
          future: _futureAgentes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Não foi possível carregar os agentes.\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final agentes = snapshot.data ?? const [];
            if (agentes.isEmpty) {
              return LayoutBuilder(
                builder: (context, constraints) => ListView(
                  children: [
                    SizedBox(
                      height: constraints.maxHeight,
                      child: const Center(child: Text('Nenhum agente cadastrado.')),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              itemCount: agentes.length,
              itemBuilder: (context, index) {
                final agente = agentes[index];
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.badge_outlined),
                    title: Text(agente.nome),
                    subtitle: Text(agente.email),
                    trailing: Chip(
                      label: Text(agente.perfil.rotulo),
                      backgroundColor: agente.ativo ? null : Theme.of(context).colorScheme.surface,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
