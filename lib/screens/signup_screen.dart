import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Enter your details"),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Stack(children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Email"),
                TextField(
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
                Text("Password"),
                TextField(
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
                Text("Repeat Password"),
                TextField(
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
                Text("Ghana Card"),
                TextField(
                  decoration: InputDecoration(border: OutlineInputBorder()),
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                    width: 300,
                    height: 50,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.all(Colors.tealAccent.shade100),
                      ),
                        onPressed: () {
                          context.go('/homepage');
                        }, child: Text("Confirm"))),
              ),
            ),
          ]),
        ));
  }
}
