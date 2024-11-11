import 'package:flutter/material.dart';
import 'package:prototype/components/ButtonOne.dart';
import 'package:prototype/pages/authentication/SignIn.dart';
import 'package:prototype/pages/authentication/SignUp.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 150,
                ),
              ),
              const Text(
                "Hey Travelers Tips are  Next To You",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignInPage(),
                    ),
                  );
                },
                child: const ButtonOne(
                  label: "Sign In",
                  textColor: Colors.black,
                  icon: Icon(Icons.arrow_forward),
                  color: Color.fromRGBO(53, 208, 219, 1),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUp(),
                    ),
                  );
                },
                child: const ButtonOne(
                  label: "Sign Up",
                  textColor: Colors.black,
                  icon: Icon(Icons.arrow_forward),
                  color: Color.fromRGBO(53, 208, 219, 1),
                ),
              ),
              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }
}
