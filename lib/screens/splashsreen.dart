import 'package:go_router/go_router.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/material.dart';
import 'package:susu/services/auth_service.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final user = await AuthService.signInWithGoogle();
      if (user != null && context.mounted) {
        context.go('/homepage');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google sign-in failed. Please try again.')),
        );
      }
    }
  }

  Future<void> _signInWithApple(BuildContext context) async {
    try {
      final user = await AuthService.signInWithApple();
      if (user != null && context.mounted) {
        context.go('/homepage');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Apple sign-in failed. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/final.jpg',
            fit: BoxFit.fitWidth,
            alignment: Alignment.topCenter,
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(
                  top: 24, left: 20, right: 20, bottom: 25),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'appLogo',
                      child: Image.asset(
                        'assets/images/atom.png',
                        width: 30,
                        height: 30,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'SusuPlus is a digital susu and group savings platform with MoMo integration, automated contributions, transparent ledgers.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SignInWithAppleButton(
                          onPressed: () => _signInWithApple(context),
                          height: 50,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(15)),
                          text: 'Continue with Apple',
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => _signInWithGoogle(context),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 50),
                            side: const BorderSide(color: Color(0xFFDADCE0)),
                            elevation: 0,
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/g_logo.png',
                                height: 20,
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Continue with Google',
                                style: TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 400,
                          height: 50,
                          child: Container(
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    backgroundColor: Color(0xFFCBCBCB),
                                    foregroundColor: Colors.black,
                                  ),
                                  onPressed: () {
                                    context.go('/login');
                                  },
                                  child: const Text(
                                    "Continue with Email",
                                    style: TextStyle(fontSize: 19),
                                  ))),
                        ),
                        Row(
                          children: [
                            const SizedBox(width: 25,),
                            Text(
                              "By continuing you agree to Susu's",
                              style: TextStyle(fontWeight: FontWeight(250)),
                            ),
                            Text("Terms of Use",
                                style: TextStyle(fontWeight: FontWeight(500)))
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
