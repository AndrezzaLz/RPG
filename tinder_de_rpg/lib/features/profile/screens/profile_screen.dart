import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ficha do Aventureiro (Perfil)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primaryOrange,
              child: Icon(
                Icons.person,
                size: 48,
                color: AppColors.parchment,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aventureiro Anônimo',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.parchment,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Nível 1 • Mestre & Jogador',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.parchmentDim,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: AppColors.parchment,
              ),
              onPressed: () => context.go('/'),
              child: const Text('Voltar ao Mural'),
            ),
          ],
        ),
      ),
    );
  }
}
