import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_demo_one/view/sign_up_screen/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../data/models/user_model.dart';
import '../../utils/utils.dart';
import '../home_screen.dart';

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key}) : super(key: key);

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  UserCredential? userCredential;
  User? user;

  FirebaseFirestore firebaseFireStore = FirebaseFirestore.instance;

  Utils utils = Utils();
  UserModel userModel = UserModel();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool pass = true;

  void signUpTextButton() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white10,
        title: const Text("Log In Screen"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(15),
                  child: TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'E-mail',
                      hintText: 'Enter Email Address',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextField(
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter Password',
                    ),
                  ),
                ),
                ElevatedButton(
                  child: const Text('Sign In'),
                  onPressed: () {
                    loginUser();
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    debugPrint("googleUser -->$googleUser");

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    user = userCredential!.user;
    debugPrint("User Data -->  $user");
    utils.showSnackBar(context, message: "Login Successfully.");
  }

  Future<UserCredential> signInWithGitHub() async {
    // Create a GitHubSignIn instance
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
      clientId: "a9df22eeaceb96806120",
      clientSecret: "c6c127e2b2b242b19c43100d8c40bca722800a63",
      redirectUrl: 'https://my-project.firebaseapp.com/__/auth/handler',
    );
    debugPrint("github SignIn -->  $GitHubSignIn");

    // Trigger the sign-in flow
    final result = await gitHubSignIn.signIn(context);

    // Create a credential from the access token
    final githubAuthCredential = GithubAuthProvider.credential(result.token!);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(githubAuthCredential);
  }

  loginUser() async {
    try {
      await firebaseAuth
          .signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      )
          .then((value) {
        debugPrint("value -> ${value.user}");
        user = value.user;
        if (user!.emailVerified) {
          debugPrint("User is LogIn.");
          user = value.user;
          getUser();
        } else {
          debugPrint("Please Verify The Email.");
          utils.showSnackBar(
            context,
            message: "please verify you Email or Resent The Mail",
            label: 'Resent',
            onPressed: () => value.user!.sendEmailVerification(),
          );
        }
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
        utils.showSnackBar(
          context,
          message: "No User Found For That Email",
        );
      } else if (e.code == 'wrong-password') {
        debugPrint("wrong password provided for that user.");
        utils.showSnackBar(
          context,
          message: "Your Password Is Incorrect. Please, Check Your Password And Try Again.",
        );
      }
    }
  }

  getUser() {
    CollectionReference users = firebaseFireStore.collection('user');
    users.doc(user!.uid).get().then((value) {
      debugPrint(
        "User Added --> ${jsonEncode(
          value.data(),
        )}",
      );
      userModel = userModelFromJson(
        jsonEncode(
          value.data(),
        ),
      );
      utils.showSnackBar(context, message: "LogIn SuccessFully");
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }).catchError(
      (error) {
        debugPrint("Failed to Add User : $error");
      },
    );
  }
}
