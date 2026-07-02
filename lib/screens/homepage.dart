import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(7.0),
          child: CircleAvatar(
            backgroundColor: Colors.grey,
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: 325,
            height: 45,
            child: TextField(
              decoration: InputDecoration(
                  hintText: "Search",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50))),
            ),
          ),
        ),
        actions: [
          CircleAvatar(),
          SizedBox(
            width: 5,
          ),
          CircleAvatar()
        ],
        backgroundColor: Colors.transparent,
      ),
      bottomNavigationBar: NavigationBar(destinations: [
        NavigationDestination(icon: Icon(Icons.home), label: "Home"),
        NavigationDestination(icon: Icon(Icons.send), label: "Send"),
        NavigationDestination(icon: Icon(Icons.savings), label: "Savings"),
        NavigationDestination(icon: Icon(Icons.history), label: "History"),
      ]),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/final.jpg',
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
          Positioned(
              left: 0,
              right: 0,
              bottom: 50,
              child: ListTile(
                tileColor: Colors.black,
              )),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(
                  top: 24, left: 20, right: 20, bottom: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(),
            ),
          )
        ],
      ),
    );
  }
}
