import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () {},
            title: Text("Account details"),
          ),
          ListTile(
            onTap: () {},
            title: Text("Change account details"),
          ),
          ListTile(
            onTap: () {},
            title: Text("Delete account"),
          ),
        ],
      ),
    );
  }
}
