import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Service responsible for initializing and providing the Supabase client.
abstract final class SupabaseService {
  static bool _initialized = false;

  /// Returns true if the Supabase client has been initialized.
  static bool get isInitialized => _initialized;

  /// Returns the active [SupabaseClient] instance.
  /// Throws an [AssertionError] if [initialize] has not been called.
  static SupabaseClient get client {
    return Supabase.instance.client;
  }

  /// Initializes the Supabase client using environment variables.
  ///
  /// Priority:
  /// 1. `EXPO_PUBLIC_SUPABASE_URL` / `EXPO_PUBLIC_SUPABASE_ANON_KEY`
  /// 2. `SUPABASE_URL` / `SUPABASE_ANON_KEY`
  static Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    final String url = dotenv.maybeGet('EXPO_PUBLIC_SUPABASE_URL') ??
        dotenv.maybeGet('SUPABASE_URL') ??
        '';

    final String anonKey = dotenv.maybeGet('EXPO_PUBLIC_SUPABASE_ANON_KEY') ??
        dotenv.maybeGet('SUPABASE_ANON_KEY') ??
        '';

    if (url.isEmpty || anonKey.isEmpty) {
      debugPrint(
        'SupabaseService: Credentials not found or empty in environment. '
        'Set EXPO_PUBLIC_SUPABASE_URL and EXPO_PUBLIC_SUPABASE_ANON_KEY in .env.',
      );
      return;
    }

    try {
      await Supabase.initialize(
        url: url,
        publishableKey: anonKey,
      );
      _initialized = true;
      debugPrint('SupabaseService: Client initialized successfully.');
    } catch (error) {
      debugPrint('SupabaseService initialization error: $error');
    }
  }
}
