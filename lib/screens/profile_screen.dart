import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import '../services/auth_service.dart';
import 'profile_detail_screen.dart';
import 'verification_status_screen.dart';
import 'notification_settings_screen.dart';
import 'change_password_screen.dart';
import 'delete_account_screen.dart';
import 'transaction_limits_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF2F9),
      appBar: AppBar(
      backgroundColor: const Color(0xFFEEF2F9),
        elevation: 0,
        leading: const BackButton(),
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: const [],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            leading: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.grey[200],
              backgroundImage: AuthService.getCurrentUser()?.photoURL != null
                  ? NetworkImage(AuthService.getCurrentUser()!.photoURL!)
                  : null,
              child: AuthService.getCurrentUser()?.photoURL == null
                  ? const Icon(PhosphorIcons.userCircle, size: 32, color: Colors.grey)
                  : null,
            ),
            title: Text(
              AuthService.getCurrentUser()?.displayName ?? 'User',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            subtitle: const Text(
              'Show profile',
              style: TextStyle(fontSize: 14, color: Colors.blue),
            ),
          ),
          const Divider(height: 32, indent: 16, endIndent: 16),
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Accounts',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      children: [
                        _settingsTile(icon: PhosphorIcons.userCircle, label: 'Your profile', screen: const ProfileDetailScreen()),
                        _settingsTile(icon: PhosphorIcons.shieldCheck, label: 'Account verification status', screen: const VerificationStatusScreen()),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Security',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  child: Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    child: Column(
                      children: [
                        _settingsTile(icon: PhosphorIcons.bell, label: 'Notification', screen: const NotificationSettingsScreen()),
                        _settingsTile(icon: PhosphorIcons.lock, label: 'Change password', screen: const ChangePasswordScreen()),
                        _settingsTile(icon: PhosphorIcons.trash, label: 'Delete account', screen: const DeleteAccountScreen()),
                        _settingsTile(icon: PhosphorIcons.arrowsLeftRight, label: 'Transaction limits', screen: const TransactionLimitsScreen()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Log out',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsTile({required IconData icon, required String label, required Widget screen}) {
    return ListTile(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      leading: Icon(icon, size: 24, color: Colors.black54),
      title: Text(
        label,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
    );
  }
}
