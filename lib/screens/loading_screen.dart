import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Load extends StatelessWidget{
  const Load({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Lottie.asset('assets/loading.json'),
      ),
    );
  }
}