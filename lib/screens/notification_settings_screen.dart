import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _push = true;
  bool _email = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF2F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEEF2F9),
        elevation: 0,
        title: const Text(
          'Notification',
          style: TextStyle(fontSize: 18, color: Colors.black87, fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Push notifications'),
                    value: _push,
                    onChanged: (v) => setState(() => _push = v),
                    secondary: const Icon(PhosphorIcons.bell, color: Colors.black54),
                  ),
                  const Divider(height: 1, indent: 56, endIndent: 16),
                  SwitchListTile(
                    title: const Text('Email notifications'),
                    value: _email,
                    onChanged: (v) => setState(() => _email = v),
                    secondary: const Icon(PhosphorIcons.envelope, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}