import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:susu/services/auth_service.dart';

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
      resizeToAvoidBottomInset: false,
      //!Also added the resized to prevent the screen from building space for the keyboard which
      //!makes the whole screen raise when you are using keyboardType property in textField
      appBar: AppBar(
        automaticallyImplyLeading: false,
        // title: const Text("Login"),
        // centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      // backgroundColor: Colors.blueAccent,
      body: Container(
        height: 800,
        color: Colors.grey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              height: 635,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                color: Colors.white,
              ),
              child: Stack(
                children: [
                  // Text("Email"),

                  Positioned(
                    left: 8,
                    right: 8,
                    top: 125,
                    child: TextField(
                      controller: controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'user@example.com',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                      ),
                      onEditingComplete: () {
                        setState(() {});
                      },
                    ),
                  ),

                  ///
                  ///

                  //!I have commented this out because I am using the labelText propery in the email
                  Positioned(
                    left: 8,
                    right: 8,
                    top: 195,
                    child: TextField(
                      controller: controllerPassword,
                      keyboardType: TextInputType.text,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Password',
                          hintText: 'Password123',
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)))),
                    ),
                  ),

                  ///
                  ///Continue Button
                  ///
                  Positioned(
                    left: 8,
                    right: 8,
                    top: 265,
                    child: SizedBox(
                        width: 300,
                        height: 50,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black),
                            onPressed: () {
                              //  register();
                              context.go('/homepage');
                            },
                            child: Text("Continue",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                )))),
                  ),
                  Positioned(
                    left: 8,
                    right: 8,
                    bottom: 280,
                    child: Center(
                      child: Text('Forgot password?',
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                            textBaseline: TextBaseline.ideographic,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  )

                  ///
                  ///logo
                  ///
                  ,
                  Positioned(
                    top: 30,
                    left: 8,
                    right: 8,
                    child: Center(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/atom.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),

                  ///
                  ///Enter Your Password
                  ///

                  Positioned(
                    top: 83,
                    left: 8,
                    right: 8,
                    child: Center(
                      child: Text('Enter your password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          )),
                    ),
                  ),

                  ///
                  ///left logo
                  ///
                  Positioned(
                    top: 14,
                    left: 3,
                    // right: 8,
                    child: TextButton(
                      onPressed: () {
                        context.go('/home');
                      },
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(100),
                          ),
                        ),
                        child: Image.asset('assets/images/exit.png',
                            fit: BoxFit.fill),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                    onPressed: () {},
                    child: Text("Continue"))),
          ],
        ),
      ),
    );
  }
}
