import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:susu/screens/transfer_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/login_screen.dart';
import '../screens/homepage.dart';
import '../screens/settings.dart';
import '../screens/loading_screen.dart';
import '../screens/splashsreen.dart';
import '../screens/transfer_screen.dart';

class AppRoutes {
  AppRoutes._();
  static const String home = '/';
  static const String login = '/login';
  static const String registration = '/registration';
  static const String homepage = '/homepage';
  static const String error = '/error';
  static const String settings = '/settings';
  static const String loading = '/loading';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
        path: AppRoutes.home,
        builder: (BuildContext context, GoRouterState state) =>
            const SplashScreen()),
    GoRoute(
        path: AppRoutes.login,
        builder: (BuildContext context, GoRouterState state) =>
            const LoginScreen()),
    GoRoute(
        path: AppRoutes.registration,
        builder: (BuildContext context, GoRouterState state) => Registration()),
    GoRoute(
        path: AppRoutes.homepage,
        builder: (BuildContext context, GoRouterState state) => HomeScreen()),
    GoRoute(
        path: AppRoutes.settings,
        builder: (BuildContext context, GoRouterState state) => Settings()),
    GoRoute(
        path: AppRoutes.loading,
        builder: (BuildContext context, GoRouterState state) => const Load()),
  ],
);
