import 'package:flutter/material.dart';

import '../models/agente.dart';
import '../theme/app_colors.dart';
import 'agentes_screen.dart';
import 'estabelecimentos_screen.dart';
import 'ocorrencias_screen.dart';

/// Tela inicial: logo do app e menu de navegação pras demais telas.
class HomeScreen extends StatelessWidget {
  final Agente agenteLogado;

  const HomeScreen({super.key, required this.agenteLogado});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              const Spacer(),
              Image.asset(
                'assets/icons/logo.png',
                height: 200,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  width: 200,
                  decoration: const BoxDecoration(
                    color: AppColors.azul,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.health_and_safety, color: AppColors.branco, size: 96),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Vigilância sanitária de Ribeirão Preto',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                      color: AppColors.azul,
                      letterSpacing: 0.4,
                    ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              _ItemMenu(
                leading: Image.asset('assets/icons/marca.png', width: 28, height: 28),
                titulo: 'Ocorrências',
                subtitulo: 'Casos, inspeções e evidências',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => OcorrenciasScreen(agenteLogado: agenteLogado)),
                  );
                },
              ),
              const SizedBox(height: 12),
              _ItemMenu(
                leading: Image.asset('assets/icons/icon_estabelecimento.png', width: 28, height: 28),
                titulo: 'Estabelecimentos',
                subtitulo: 'Locais sujeitos a inspeção',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => EstabelecimentosScreen(agenteLogado: agenteLogado)),
                  );
                },
              ),
              const SizedBox(height: 12),
              _ItemMenu(
                leading: Image.asset('assets/icons/icon_info.png', width: 28, height: 28),
                titulo: 'Agentes',
                subtitulo: 'Fiscais, chefes e administrativos',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AgentesScreen()));
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemMenu extends StatelessWidget {
  final Widget leading;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  const _ItemMenu({
    required this.leading,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                leading,
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(titulo, style: Theme.of(context).textTheme.titleMedium),
                      Text(subtitulo, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
