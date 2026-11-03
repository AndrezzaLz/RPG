import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/colors.dart';
import '../providers/auth_provider.dart';
import 'custom_button.dart';

/// Form widget for user login and registration with medieval styling.
class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isLoginMode = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _toggleMode() {
    setState(() {
      _isLoginMode = !_isLoginMode;
    });
    context.read<AuthProvider>().clearError();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final AuthProvider auth = context.read<AuthProvider>();
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    if (_isLoginMode) {
      await auth.signInWithEmail(
        email: email,
        password: password,
      );
    } else {
      await auth.signUpWithEmail(
        email: email,
        password: password,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthProvider auth = context.watch<AuthProvider>();

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header / Mode indicator
          Text(
            _isLoginMode ? 'Entrar na Taverna' : 'Novo Recruta da Guilda',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _isLoginMode
                ? 'Informe suas credenciais para continuar sua jornada.'
                : 'Crie sua conta para registrar suas fichas de aventureiro.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 20),

          // Email Field
          _buildTextField(
            controller: _emailController,
            label: 'E-mail do Aventureiro',
            hint: 'exemplo@reino.com',
            icon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (String? value) {
              if (value == null || value.trim().isEmpty) {
                return 'Informe seu e-mail';
              }
              if (!value.contains('@') || !value.contains('.')) {
                return 'Informe um e-mail válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Password Field
          _buildTextField(
            controller: _passwordController,
            label: 'Palavra-Passe (Senha)',
            hint: 'Mínimo de 6 caracteres',
            icon: Icons.lock_outline,
            obscureText: _obscurePassword,
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: AppColors.primaryOrange,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Informe sua senha';
              }
              if (value.length < 6) {
                return 'A senha deve ter no mínimo 6 caracteres';
              }
              return null;
            },
          ),

          // Confirm Password Field (Registration only)
          if (!_isLoginMode) ...[
            const SizedBox(height: 16),
            _buildTextField(
              controller: _confirmPasswordController,
              label: 'Confirmar Palavra-Passe',
              hint: 'Repita sua senha',
              icon: Icons.lock_reset,
              obscureText: _obscurePassword,
              validator: (String? value) {
                if (value != _passwordController.text) {
                  return 'As senhas não coincidem';
                }
                return null;
              },
            ),
          ],
          const SizedBox(height: 16),

          // Error Message Box
          if (auth.errorMessage != null) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.errorRed.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.errorRed, width: 1),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.errorRed,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      auth.errorMessage!,
                      style: const TextStyle(
                        color: AppColors.errorRed,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Primary Orange CustomButton
          CustomButton(
            text: _isLoginMode
                ? 'Entrar na Taverna'
                : 'Criar Ficha de Aventureiro',
            icon: _isLoginMode ? Icons.login : Icons.how_to_reg,
            isLoading: auth.isLoading,
            onPressed: _submit,
          ),
          const SizedBox(height: 14),

          // Mode Switch Toggle
          TextButton(
            onPressed: auth.isLoading ? null : _toggleMode,
            child: Text(
              _isLoginMode
                  ? 'Ainda não possui guilda? Cadastre-se'
                  : 'Já possui registro? Entrar na Taverna',
              style: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
                fontSize: 13,
                decoration: TextDecoration.underline,
              ),
            ),
          ),

          // Guest Explorer Bypass (for local testing/exploration)
          TextButton.icon(
            icon: const Icon(
              Icons.shield,
              size: 16,
              color: AppColors.primaryOrange,
            ),
            label: const Text(
              'Entrar como Aventureiro Convidado (Modo Teste)',
              style: TextStyle(
                color: AppColors.primaryOrange,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            onPressed: auth.isLoading
                ? null
                : () => context.read<AuthProvider>().signInAsGuest(),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(
        color: AppColors.textDark,
        fontSize: 14.5,
        fontWeight: FontWeight.w500,
      ),
      cursorColor: AppColors.primaryOrange,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(
          color: AppColors.textDark,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          color: AppColors.textDark.withValues(alpha: 0.5),
          fontSize: 13,
        ),
        prefixIcon: Icon(icon, color: AppColors.primaryOrange),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.parchmentDim.withValues(alpha: 0.35),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.parchmentDim,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.primaryOrange,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.errorRed,
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: AppColors.errorRed,
            width: 2,
          ),
        ),
      ),
    );
  }
}
