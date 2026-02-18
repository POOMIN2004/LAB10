import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({Key? key}) : super(key: key);

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Welcome")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("อีเมลของคุณคือ", style: TextStyle(fontSize: 22)),

              const SizedBox(height: 10),

              Text(
                user?.email ?? "ไม่พบอีเมล",
                style: const TextStyle(fontSize: 20),
              ),

              const SizedBox(height: 30),

              ElevatedButton(
                child: const Text("ออกจากระบบ"),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
