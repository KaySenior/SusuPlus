import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Signup"),
      ),
      body: const Center(
        child: Text("Signup Screen"),
      ),
    );
  }
}