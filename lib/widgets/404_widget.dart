import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      /* appBar: AppBar(
        title: const Text("We seem to have an error"),
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        foregroundColor: Colors.black,
      ), */
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          fit: StackFit.expand,
          children: [
            const Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Text(
                "Oops! Something went wrong.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.blueAccent,
                ),
              ),
            ),
            Positioned(
              bottom: 175,
              left: 0,
              right: 0,
              child: Lottie.asset(
                'assets/404.json',
                repeat: false,
              ),
            ),
            Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: TextButton(
                onPressed: () {
                  context.go('/home');
                },
                child: Text("Go to Home", style: TextStyle(color: Colors.blueAccent),)),)
          ],
        ),
      ),
    );
  }
}
