import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/onboarding_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/login_screen.dart';
import '../screens/splashsreen.dart';


class AppRoutes {
  AppRoutes._();
  static const String home = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String homepage = '/homepage';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes:[
  GoRoute(path: AppRoutes.home, builder: (BuildContext context, GoRouterState state) => const SplashScreen()),
  GoRoute(path:AppRoutes.login, builder:(BuildContext context, GoRouterState state) => const LoginScreen()) 
  ],
);
