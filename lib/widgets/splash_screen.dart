import 'dart:async';
import 'package:flutter/material.dart';
import 'package:voting_system/widget/login.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,

        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 255, 218, 72),

              Color(0xFFE8F4FF),

              Color(0xFF311B92),
            ],

            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,

                child: Padding(
                  padding: const EdgeInsets.only(right: 16, top: 8),

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),

                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.6),

                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: const Text(
                      'v1.0',

                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(),

              Container(
                width: 120,
                height: 120,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),

                  gradient: const LinearGradient(
                    colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
                  ),
                ),

                child: const Icon(
                  Icons.how_to_vote,

                  color: Colors.white,

                  size: 40,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Voting App',

                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              const Text(
                'DIGITAL DEMOCRACY IN YOUR HANDS',

                textAlign: TextAlign.center,

                style: TextStyle(fontSize: 16, letterSpacing: 3),
              ),

              const Spacer(),

              const SizedBox(height: 20),

              const SizedBox(
                width: 50,
                height: 50,

                child: CircularProgressIndicator(strokeWidth: 3),
              ),

              const SizedBox(height: 40),

              const Text(
                '© 2026 Voting App. All rights reserved.',

                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
