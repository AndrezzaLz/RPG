import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/services/supabase_service.dart';

/// Provider for managing authentication state and actions (login/logout).
class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _initSupabaseAuth();
  }

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;
  StreamSubscription<AuthState>? _authSubscription;

  /// Whether a user is currently signed in.
  bool get isAuthenticated => _user != null;

  /// The currently authenticated Supabase [User], if any.
  User? get user => _user;

  /// Whether an authentication request is currently in progress.
  bool get isLoading => _isLoading;

  /// The latest authentication error message, if any.
  String? get errorMessage => _errorMessage;

  void _initSupabaseAuth() {
    if (!SupabaseService.isInitialized) {
      return;
    }

    try {
      final SupabaseClient client = SupabaseService.client;
      _user = client.auth.currentUser;

      _authSubscription = client.auth.onAuthStateChange.listen(
        (AuthState data) {
          _user = data.session?.user;
          notifyListeners();
        },
        onError: (Object error) {
          debugPrint('AuthProvider: Auth state stream error: $error');
        },
      );
    } catch (e) {
      debugPrint('AuthProvider: Could not attach to Supabase auth stream: $e');
    }
  }

  /// Authenticates a user with email and password.
  Future<bool> signInWithEmail({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (!SupabaseService.isInitialized) {
      // In offline / mock development mode without active backend credentials:
      _isLoading = false;
      _errorMessage =
          'Cliente Supabase não inicializado. Verifique as credenciais no .env.';
      notifyListeners();
      return false;
    }

    try {
      final AuthResponse response =
          await SupabaseService.client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      _user = response.user;
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _isLoading = false;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Erro inesperado ao realizar login: $e';
      notifyListeners();
      return false;
    }
  }

  /// Registers a new user with email and password.
  Future<bool> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (!SupabaseService.isInitialized) {
      _isLoading = false;
      _errorMessage =
          'Cliente Supabase não inicializado. Verifique as credenciais no .env.';
      notifyListeners();
      return false;
    }

    try {
      final AuthResponse response = await SupabaseService.client.auth.signUp(
        email: email.trim(),
        password: password,
      );

      _user = response.user;
      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      _isLoading = false;
      _errorMessage = e.message;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Erro inesperado ao cadastrar usuário: $e';
      notifyListeners();
      return false;
    }
  }

  /// Signs out the currently authenticated user.
  Future<void> signOut() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (SupabaseService.isInitialized) {
        await SupabaseService.client.auth.signOut();
      }
    } catch (e) {
      debugPrint('AuthProvider signOut error: $e');
    } finally {
      _user = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clears any current error message.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Signs in a guest / demo user (useful for testing or exploring without credentials).
  void signInAsGuest({String name = 'Aventureiro Convidado'}) {
    _user = User(
      id: 'guest-${DateTime.now().millisecondsSinceEpoch}',
      appMetadata: const <String, dynamic>{'provider': 'guest'},
      userMetadata: <String, dynamic>{'name': name},
      aud: 'authenticated',
      createdAt: DateTime.now().toIso8601String(),
    );
    _errorMessage = null;
    notifyListeners();
  }

  /// Helper method for testing or local mocking of authenticated state.
  void setMockAuthenticated({required bool authenticated}) {
    if (authenticated) {
      signInAsGuest(name: 'Aventureiro Teste');
    } else {
      _user = null;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
