import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:prototype/pages/MainPage.dart';

import 'package:prototype/pages/authentication/SignUpPageTwo.dart';

class CheckData extends StatefulWidget {
  const CheckData({super.key});

  @override
  State<CheckData> createState() => _CheckDataState();
}

class _CheckDataState extends State<CheckData> {
  @override
  void initState() {
    super.initState();
    checkFirebaseUserData();
  }

  checkFirebaseUserData() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(await FirebaseAuth.instance.currentUser!.email)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document exists on the database');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(),
          ),
        );
      } else {
        // Redirect to Signup Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignUpPageTwo(),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text("Loading..."),
      ),
    );
  }
}
