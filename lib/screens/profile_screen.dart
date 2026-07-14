import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notification_add_outlined, color: Colors.blue),
            iconSize: 28,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset(
                'assets/images/profileImage.jpg',
                height: 56,
                width: 56,
                fit: BoxFit.cover,
              ),
            ),
            title: const Text(
              'Mr.Mark',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
            ),
            subtitle: const Text(
              'Show profile',
              style: TextStyle(fontSize: 14, color: Colors.blue),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.blue),
          ),
          const Divider(height: 32, indent: 16, endIndent: 16),
          const Padding(
            padding: EdgeInsets.only(left: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Settings',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView(
              children: [
                _settingsTile(
                  icon: 'assets/icons/user-circle.png',
                  label: 'Personal information',
                ),
                const Divider(height: 1, indent: 56, endIndent: 16),
                _settingsTile(
                  icon: 'assets/icons/money.png',
                  label: 'Payment and payouts',
                ),
                const Divider(height: 1, indent: 56, endIndent: 16),
                _settingsTile(
                  icon: 'assets/icons/taxes.png',
                  label: 'Taxes',
                ),
                const Divider(height: 1, indent: 56, endIndent: 16),
                _settingsTile(
                  icon: 'assets/icons/shield.png',
                  label: 'Logic & security',
                ),
                const Divider(height: 1, indent: 56, endIndent: 16),
                _settingsTile(
                  icon: 'assets/icons/accessibility.png',
                  label: 'Accessibility',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsTile({required String icon, required String label}) {
    return ListTile(
      onTap: () {},
      leading: Image.asset(icon, height: 24, width: 24),
      title: Text(
        label,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.blue),
    );
  }
}
