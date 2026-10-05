import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'agentes_screen.dart';
import 'estabelecimentos_screen.dart';
import 'ocorrencias_screen.dart';

/// Tela inicial: logo do app e menu de navegação pras demais telas.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                height: 120,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 120,
                  width: 120,
                  decoration: const BoxDecoration(
                    color: AppColors.azul,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.health_and_safety, color: AppColors.branco, size: 64),
                ),
              ),
              const SizedBox(height: 16),
              Text('visa-campo', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(
                'Vigilância sanitária de Ribeirão Preto',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              _ItemMenu(
                icone: Icons.assignment_outlined,
                titulo: 'Ocorrências',
                subtitulo: 'Casos, inspeções e evidências',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const OcorrenciasScreen()));
                },
              ),
              const SizedBox(height: 12),
              _ItemMenu(
                icone: Icons.store_outlined,
                titulo: 'Estabelecimentos',
                subtitulo: 'Locais sujeitos a inspeção',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const EstabelecimentosScreen()));
                },
              ),
              const SizedBox(height: 12),
              _ItemMenu(
                icone: Icons.badge_outlined,
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
  final IconData icone;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  const _ItemMenu({
    required this.icone,
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
                Icon(icone, color: AppColors.azul),
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
