import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pombo-Correio (Chat)'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.forum_outlined,
              size: 64,
              color: AppColors.primaryOrange,
            ),
            const SizedBox(height: 16),
            const Text(
              'Mensagens da Guilda',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.parchment,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Suas conversas com grupos e mestres aparecerão aqui.',
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
