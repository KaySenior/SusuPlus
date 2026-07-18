import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:susu/screens/payment_screen.dart';
import 'package:susu/screens/password_setup_screen.dart';
import 'package:susu/screens/profile_screen.dart';
import 'package:susu/screens/transfer_screen.dart';
import 'package:susu/screens/profile_detail_screen.dart';
import 'package:susu/screens/verification_status_screen.dart';
import 'package:susu/screens/notification_settings_screen.dart';
import 'package:susu/screens/change_password_screen.dart';
import 'package:susu/screens/delete_account_screen.dart';
import 'package:susu/screens/transaction_limits_screen.dart';
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
  static const String payment = '/payment';
  static const String passwordSetup = '/password-setup';
  static const String profile = '/profile';
  static const String forgotPassword = '/forgot-password';
  static const String phoneAuth = '/phone-auth';
  static const String profileDetail = '/profile-detail';
  static const String verificationStatus = '/verification-status';
  static const String notificationSettings = '/notification-settings';
  static const String changePassword = '/change-password';
  static const String deleteAccount = '/delete-account';
  static const String transactionLimits = '/transaction-limits';
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
        path: AppRoutes.payment,
        builder: (BuildContext context, GoRouterState state) {
          final amount = double.tryParse(state.uri.queryParameters['amount'] ?? '') ?? 0;
          return PaymentScreen(amount: amount);
        }),
    GoRoute(
        path: AppRoutes.passwordSetup,
        builder: (BuildContext context, GoRouterState state) {
          final phone = state.extra as String? ?? '';
          return PasswordSetupScreen(phoneNumber: phone);
        }),
    GoRoute(path: AppRoutes.profile, builder: (BuildContext context, GoRouterState state)=> ProfileScreen()),
    GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (BuildContext context, GoRouterState state) =>
            const ForgotPasswordScreen()),
    GoRoute(
        path: AppRoutes.phoneAuth,
        builder: (BuildContext context, GoRouterState state) =>
            const PhoneAuthScreen()),
    GoRoute(
        path: AppRoutes.profileDetail,
        builder: (BuildContext context, GoRouterState state) =>
            const ProfileDetailScreen()),
    GoRoute(
        path: AppRoutes.verificationStatus,
        builder: (BuildContext context, GoRouterState state) =>
            const VerificationStatusScreen()),
    GoRoute(
        path: AppRoutes.notificationSettings,
        builder: (BuildContext context, GoRouterState state) =>
            const NotificationSettingsScreen()),
    GoRoute(
        path: AppRoutes.changePassword,
        builder: (BuildContext context, GoRouterState state) =>
            const ChangePasswordScreen()),
    GoRoute(
        path: AppRoutes.deleteAccount,
        builder: (BuildContext context, GoRouterState state) =>
            const DeleteAccountScreen()),
    GoRoute(
        path: AppRoutes.transactionLimits,
        builder: (BuildContext context, GoRouterState state) =>
            const TransactionLimitsScreen()),
  ],
);
