import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:susu/screens/profile_screen.dart';
import 'package:susu/screens/transfer_screen.dart';
import '../screens/signup_screen.dart';
import '../screens/registration_screen.dart';
import '../screens/homepage.dart';
import '../screens/settings.dart';
import '../screens/loading_screen.dart';
import '../screens/splashsreen.dart';
import '../screens/phone_auth_screen.dart';
import '../screens/forgot_password_screen.dart';

class AppRoutes {
  AppRoutes._();
  static const String home = '/';
  static const String login = '/login';
  static const String registration = '/registration';
  static const String homepage = '/homepage';
  static const String error = '/error';
  static const String settings = '/settings';
  static const String loading = '/loading';
  static const String transfer = '/transfer';
  static const String profile = '/profile';
  static const String forgotPassword = '/forgot-password';
  static const String phoneAuth = '/phone-auth';
}

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  redirect: (context, state) {
    final uri = state.uri.toString();
    if (uri.contains('firebaseauth') || uri.contains('googleusercontent')) {
      return AppRoutes.home;
    }
    return null;
  },
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
        builder: (BuildContext context, GoRouterState state) => HomeTab()),
    GoRoute(
        path: AppRoutes.settings,
        builder: (BuildContext context, GoRouterState state) => Settings()),
    GoRoute(
        path: AppRoutes.loading,
        builder: (BuildContext context, GoRouterState state) => const Load()),
    GoRoute(
        path: AppRoutes.transfer,
        builder: (BuildContext context, GoRouterState state) =>
            TransferScreen()),
    GoRoute(
        path: AppRoutes.profile,
        builder: (BuildContext context, GoRouterState state) =>
            ProfileScreen()),
    GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (BuildContext context, GoRouterState state) =>
            const ForgotPasswordScreen()),
    GoRoute(
        path: AppRoutes.phoneAuth,
        builder: (BuildContext context, GoRouterState state) =>
            const PhoneAuthScreen()),
  ],
);
