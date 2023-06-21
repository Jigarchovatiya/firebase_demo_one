import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'git_hub_log_in.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  addUser() async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(email: email.text, password: password.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        debugPrint("your password is too weak");
      } else if (e.code == "e-mail is used once") {
        debugPrint("this email has already an account logged in ");
      }
    } catch (e) {
      debugPrint("error $e");
    }
  }

  User? person;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign UP Screen"), backgroundColor: Colors.white70),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: TextField(
              controller: email,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'E-mail',
                hintText: 'Enter E-mail',
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(15),
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
                hintText: 'Enter Password',
              ),
            ),
          ),
          ElevatedButton(
            child: const Text('Sign in to Git hub'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GitHubLogIn(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
