import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screens/auth_screen.dart';
import '../../features/chat/screens/chat_screen.dart';
import '../../features/matchmaking/screens/swipe_screen.dart';
import '../../features/profile/screens/profile_screen.dart';

/// Application router configuration using GoRouter with authentication guards.
abstract final class AppRouter {
  static AuthProvider? _authProvider;
  static GoRouter? _routerInstance;

  /// Default router instance.
  static GoRouter get router => getRouter();

  /// Retrieves or builds a [GoRouter] bound to an [AuthProvider].
  static GoRouter getRouter([AuthProvider? authProvider]) {
    if (authProvider != null) {
      if (_routerInstance == null || _authProvider != authProvider) {
        _authProvider = authProvider;
        _routerInstance = createRouter(authProvider);
      }
      return _routerInstance!;
    }

    _authProvider ??= AuthProvider();
    _routerInstance ??= createRouter(_authProvider!);
    return _routerInstance!;
  }

  /// Builds a new [GoRouter] with authentication protection.
  static GoRouter createRouter(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: '/',
      refreshListenable: authProvider,
      redirect: (BuildContext context, GoRouterState state) {
        final bool isAuthenticated = authProvider.isAuthenticated;
        final bool isGoingToLogin = state.matchedLocation == '/login';

        // If unauthenticated, redirect to '/login' unless already heading there
        if (!isAuthenticated) {
          return isGoingToLogin ? null : '/login';
        }

        // If authenticated and tries to open login page, redirect to home
        if (isGoingToLogin) {
          return '/';
        }

        // Allow navigation to the requested route
        return null;
      },
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          name: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return const SwipeScreen();
          },
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const AuthScreen();
          },
        ),
        GoRoute(
          path: '/chat',
          name: 'chat',
          builder: (BuildContext context, GoRouterState state) {
            return const ChatScreen();
          },
        ),
        GoRoute(
          path: '/profile',
          name: 'profile',
          builder: (BuildContext context, GoRouterState state) {
            return const ProfileScreen();
          },
        ),
      ],
    );
  }
}
