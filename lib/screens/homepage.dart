import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome to SusuPlus"), centerTitle: true,
      backgroundColor: Colors.blueAccent.shade100,
      ),
      drawer: SafeArea(
        child: Drawer(
          child: Column(
            children: [
              ListTile(
                title: Text("Home"),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(destinations: [
        NavigationDestination(icon: Icon(Icons.home), label: "Home"),
        NavigationDestination(icon: Icon(Icons.send), label: "Send"),
        NavigationDestination(icon: Icon(Icons.savings), label: "Savings"),
        NavigationDestination(icon: Icon(Icons.history), label: "History"),
      ]),
      body: Module(),
    );
  }
}

class Module extends StatefulWidget {
  const Module({super.key});

  @override
  State<Module> createState() => _ModuleState();
}

class _ModuleState extends State<Module> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      color: Color(identityHashCode(#FFFDD0)),
      width: 400,
      height: 200,
      child: Column(
        children: [
          Text("Your balance is", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}