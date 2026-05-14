import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:susu/screens/onboarding_screen.dart';


void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(245, 245, 245, 242),
        title: const Text("SuSuPlus"),
      ),
        body: Center(
          child: Lottie.asset(
            'assets/a.json',
            width: 300,
            height: 300,
          )
        )
      )
    );
  }
}