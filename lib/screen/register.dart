import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/profile.dart';
import 'home.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final Profile profile = Profile();

  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FirebaseApp>(
      future: firebase,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text("Error")),
            body: Center(child: Text(snapshot.error.toString())),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(title: const Text("สร้างบัญชีผู้ใช้")),
            body: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("อีเมล", style: TextStyle(fontSize: 20)),

                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "กรุณากรอกอีเมล";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        profile.email = value ?? "";
                      },
                    ),

                    const SizedBox(height: 15),

                    const Text("รหัสผ่าน", style: TextStyle(fontSize: 20)),

                    TextFormField(
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.length < 6) {
                          return "รหัสผ่านต้องอย่างน้อย 6 ตัว";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        profile.password = value ?? "";
                      },
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.app_registration),
                        label: const Text(
                          "ลงทะเบียน",
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();

                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                    email: profile.email!,
                                    password: profile.password!,
                                  );

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("สมัครสมาชิกสำเร็จ"),
                                ),
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomeScreen(),
                                ),
                              );
                            } on FirebaseAuthException catch (e) {
                              String message = e.message ?? "เกิดข้อผิดพลาด";

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
          );
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
