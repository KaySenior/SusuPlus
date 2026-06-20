import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login"), centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Email"),
            TextField(
              decoration: InputDecoration(
                  hintText: 'user@example.com', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20,),
            Text("Password"),
            TextField(
              decoration: InputDecoration(
                  hintText: 'Password123', border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
    );
  }
}
