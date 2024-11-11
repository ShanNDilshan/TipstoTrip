import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prototype/pages/authentication/CheckData.dart';
import 'package:prototype/pages/authentication/Splash.dart';

class AuthBase extends StatefulWidget {
  const AuthBase({super.key});

  @override
  State<AuthBase> createState() => _AuthBaseState();
}

class _AuthBaseState extends State<AuthBase> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text("Loading"),
            );
          }

          if (snapshot.hasData) {
            return CheckData();
          } else {
            return AuthPage();
          }
        },
      ),
    );
  }
}
