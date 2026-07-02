import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:susu/services/auth_service.dart';
<<<<<<< HEAD
import 'package:go_router/go_router.dart';
=======
>>>>>>> main

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
  void dispose() {
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
<<<<<<< HEAD
      resizeToAvoidBottomInset: false,
      //!Also added the resized to prevent the screen from building space for the keyboard which
      //!makes the whole screen raise when you are using keyboardType property in textField
      // appBar: AppBar(
      //   title: const Text("Login"),
      //   centerTitle: true,
      // ),
      backgroundColor: const Color.fromARGB(255, 157, 171, 179),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 350,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                color: Colors.white.withAlpha(50)),
            child: Stack(
              children: [
                // Text("Email"),
                //!I have commented this out because I am using the labelText propery in the email
                Positioned(
                  left: 8,
                  right: 8,
                  bottom: 480,
                  child: TextField(
                    controller: controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'user@example.com',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(80))),
                    ),
                    onEditingComplete: () {
                      setState(() {});
                    },
                  ),
                ),
                // Text("Password"),
                //!same too here

                Positioned(
                  left: 8,
                  right: 8,
                  bottom: 410,
                  child: TextField(
                    controller: controllerPassword,
                    keyboardType: TextInputType.text,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Password123',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(80)))),
                  ),
                ),
                Positioned(
                  bottom: 340,
                  left: 18,
                  child: SizedBox(
                      width: 300,
                      height: 50,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueGrey),
                          onPressed: () {
                            //  register();
                            context.go('/homepage');
                          },
                          child: Text("Continue"))),
                ),
                Positioned(
                  left: 110,
                  // right: 20,
                  bottom: 300,
                  child: Text('Forgot password?',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      )),
                )

                //, Text('Term of Use'),
                // Text('Privacy Policy')
              ],
            ),
          ),
        ],
=======
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
                setState(() {});
              },
            ),
            Text("Password"),
            TextField(
              obscureText: true,
              keyboardType: TextInputType.text,
              controller: controllerPassword,
              decoration: InputDecoration(
                  hintText: 'Password123', border: OutlineInputBorder()),
            ),
            SizedBox(
                width: 300,
                height: 50,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey),
                    onPressed: () {
                      register();
                      // context.go('/homepage');
                    },
                    child: Text("Continue"))),
          ],
        ),
>>>>>>> main
      ),
    );
  }
}
