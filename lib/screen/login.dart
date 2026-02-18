import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/profile.dart';
import 'welcome.dart'; // 🔥 เปลี่ยนเป็นไปหน้า Welcome

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('เข้าสู่ระบบ')),

      body: Container(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("อีเมล", style: TextStyle(fontSize: 20)),

                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "กรุณากรอกอีเมล";
                    }
                    return null;
                  },
                  onSaved: (email) {
                    profile.email = email!.trim();
                  },
                ),

                const SizedBox(height: 15),

                const Text("รหัสผ่าน", style: TextStyle(fontSize: 20)),

                TextFormField(
                  obscureText: true,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "กรุณากรอกรหัสผ่าน";
                    }
                    return null;
                  },
                  onSaved: (password) {
                    profile.password = password!.trim();
                  },
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.login),
                    label: const Text(
                      "เข้าสู่ระบบ",
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();

                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                                email: profile.email!,
                                password: profile.password!,
                              );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("เข้าสู่ระบบสำเร็จ")),
                          );

                          // 🔥 ไปหน้า Welcome แทน Home
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WelcomeScreen(),
                            ),
                          );
                        } on FirebaseAuthException catch (e) {
                          String message;

                          if (e.code == 'user-not-found') {
                            message = "ไม่พบบัญชีผู้ใช้นี้";
                          } else if (e.code == 'wrong-password') {
                            message = "รหัสผ่านไม่ถูกต้อง";
                          } else {
                            message = e.message ?? "เกิดข้อผิดพลาด";
                          }

                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text(message)));
                        }
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
