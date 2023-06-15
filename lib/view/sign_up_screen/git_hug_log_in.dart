import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:github_sign_in/github_sign_in.dart';

class GitHubLogIn extends StatefulWidget {
  const GitHubLogIn({super.key});

  @override
  State<GitHubLogIn> createState() => _GitHubLogInState();
}

class _GitHubLogInState extends State<GitHubLogIn> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  Future<UserCredential> signInWithGitHub(context) async {
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
      clientId: "2c800db50d40bad491ba",
      clientSecret: "60c1cc007185ed40a46af38c7209036e9185943b",
      redirectUrl: 'https://fir-app-cc404.firebaseapp.com/__/auth/handler',
    );
    final result = await gitHubSignIn.signIn(context);
    final githubAuthCredential = GithubAuthProvider.credential(result.token!);

    return await FirebaseAuth.instance.signInWithCredential(githubAuthCredential);
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white30,
      body: !isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = false;
                      });
                      try {
                        await signInWithGitHub(context);
                      } on FirebaseAuthException catch (e) {
                        debugPrint(e.message);
                      }
                    },
                    child: const Text("Sign in with Git hub"),
                  ),
                ],
              ),
            )
          : const Center(
              child: CircularProgressIndicator(
                color: Colors.indigo,
              ),
            ),
    );
  }
}
