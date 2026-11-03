import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'core/constants/colors.dart';
import 'core/router/app_router.dart';
import 'core/services/supabase_service.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/matchmaking/providers/matchmaking_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // Allows running gracefully in test environments or before .env is populated
  }

  await SupabaseService.initialize();

  runApp(const TinderDeRpgApp());
}

class TinderDeRpgApp extends StatelessWidget {
  const TinderDeRpgApp({
    super.key,
    this.authProvider,
    this.matchmakingProvider,
  });

  final AuthProvider? authProvider;
  final MatchmakingProvider? matchmakingProvider;

  @override
  Widget build(BuildContext context) {
    final Widget app = Builder(
      builder: (BuildContext innerContext) {
        final AuthProvider auth = innerContext.watch<AuthProvider>();

        return MaterialApp.router(
          title: 'Tinder de RPG',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: AppColors.darkBrown,
            colorScheme: const ColorScheme(
              brightness: Brightness.dark,
              primary: AppColors.primaryOrange,
              onPrimary: AppColors.parchment,
              secondary: AppColors.parchment,
              onSecondary: AppColors.darkBrown,
              surface: AppColors.darkBrown,
              onSurface: AppColors.parchment,
              error: AppColors.errorRed,
              onError: AppColors.parchment,
            ),
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.darkBrown,
              foregroundColor: AppColors.parchment,
              elevation: 0,
              centerTitle: true,
              titleTextStyle: TextStyle(
                color: AppColors.parchment,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryOrange,
                foregroundColor: AppColors.parchment,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            outlinedButtonTheme: OutlinedButtonThemeData(
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.parchment,
                side: const BorderSide(color: AppColors.primaryOrange),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            cardTheme: CardThemeData(
              color: AppColors.darkBrownCard,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: AppColors.primaryOrange, width: 0.5),
              ),
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: AppColors.parchment),
              bodyMedium: TextStyle(color: AppColors.parchment),
              bodySmall: TextStyle(color: AppColors.parchmentDim),
              titleLarge: TextStyle(
                color: AppColors.parchment,
                fontWeight: FontWeight.bold,
              ),
              titleMedium: TextStyle(color: AppColors.parchment),
              titleSmall: TextStyle(color: AppColors.parchmentDim),
            ),
          ),
          routerConfig: AppRouter.getRouter(auth),
        );
      },
    );

    // If providers are already supplied higher in the widget tree, reuse them
    try {
      if (context.read<AuthProvider?>() != null) {
        return app;
      }
    } catch (_) {
      // No provider above, proceed to wrap
    }

    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => authProvider ?? AuthProvider(),
        ),
        ChangeNotifierProvider<MatchmakingProvider>(
          create: (_) => matchmakingProvider ?? MatchmakingProvider(),
        ),
      ],
      child: app,
    );
  }
}
