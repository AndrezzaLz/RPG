import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../matchmaking/widgets/parchment_card.dart';
import '../widgets/auth_form.dart';

/// Screen responsible for authenticating adventurers into the RPG guild.
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBrown,
      appBar: AppBar(
        backgroundColor: AppColors.darkBrown,
        foregroundColor: AppColors.parchment,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Taverna dos Exploradores',
          style: TextStyle(
            color: AppColors.parchment,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Guild Emblem / Header Icon
                Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.darkBrownCard,
                    border: Border.all(
                      color: AppColors.primaryOrange,
                      width: 2.5,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x66000000),
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.shield,
                      size: 44,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                ),

                // Parchment Card containing the medieval AuthForm
                const ParchmentCard(
                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 24),
                  child: AuthForm(),
                ),

                const SizedBox(height: 20),
                const Text(
                  'Tinder de RPG • Conectando mestres e jogadores',
                  style: TextStyle(
                    color: AppColors.parchmentDim,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
