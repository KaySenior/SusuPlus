import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class Login2 extends StatefulWidget {
  const Login2({super.key});

  @override
  State<Login2> createState() => _Login2State();
}

class _Login2State extends State<Login2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        backgroundColor: Colors.grey,
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: Offset(0, 4))
                  ]),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: SvgPicture.asset('assets/images/arrow-left.svg'),
                  ),
                ),
                CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: SvgPicture.asset('assets/images/x.svg'),
                )
              ],
            ),
            CircleAvatar(backgroundColor: Colors.transparent, child: Image.asset('assets/images/atom.png')),
            Text(
              'Enter your password',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight(500)),
            ),
            Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextField(
                  decoration: InputDecoration(
                      labelText: 'Email',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                  decoration: InputDecoration(
                      labelText: 'Password',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15))),
                ),
                const SizedBox(
                  height: 15,
                ),
                SizedBox(
                    width: 400,
                    height: 50,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white),
                        onPressed: () {},
                        child: Text(
                          'Continue',
                          style: TextStyle(fontSize: 18),
                        ))),
                TextButton(
                    onPressed: () {
                      context.go('/home');
                    },
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight(
                            500,
                          )),
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
