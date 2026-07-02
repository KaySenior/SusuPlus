import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:susu/services/auth_service.dart';
import '../core/auth_service.dart';
import 'package:go_router/go_router.dart';

final authService = AuthService();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  @override
  void dispose(){
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

   void register() async {
    final email = controllerEmail.text.trim();
    final password = controllerPassword.text.trim();

    if (email.isEmpty || password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Enter a valid email and a password of at least 6 characters',
          ),
        ),
      );
      return;
    }

    try {
      await authService.createAccount(email: email, password: password);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Registration successful')));
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      print('CODE: ${e.code}');
      print('MESSAGE: ${e.message}');
      print('FULL: $e');
    } catch (e) {
      print('NON-FIREBASE ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Email"),
            TextField(
              keyboardType: TextInputType.emailAddress,
              controller: controllerEmail,
              decoration: InputDecoration(
                  hintText: 'user@example.com', border: OutlineInputBorder()),
              onEditingComplete: () {
                setState(() {
                });
              },
            ),
          
          
            Text("Password"),
            TextField(
              controller: controllerPassword,
              decoration: InputDecoration(
                  hintText: 'Password123', border: OutlineInputBorder()),
            ),
            SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                    onPressed: () {
                     register();
                     /* context.go('/homepage');*/},
                    child: Text("Continue"))),
          ],
        ),
      ),
    );
  }
}
