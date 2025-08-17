import 'package:flutter/material.dart';
import 'package:flutter_application_1/Animation/FadeSlideAnimation.dart' show FadeSlideAnimation;
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 150),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FadeSlideAnimation(
                beginOffset: const Offset(0, -0.2),
                child: Column(
                  children: [
                    Image.asset('assets/image12.png', height: 150),
                    const SizedBox(height: 12),
                    const Text(
                      'Login',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            
              FadeSlideAnimation(
                beginOffset: const Offset(0, 0.2),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      icon: Image.asset('assets/image12.png', height: 22),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: const BorderSide(color: Colors.black12),
                        ),
                        elevation: 4,
                      ),
                      label: const Text(
                        'Sign in with Google',
                        style: TextStyle(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      onPressed: () async {
                        await auth.signInWithGoogle();
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}