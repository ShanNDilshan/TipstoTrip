import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:prototype/components/ButtonOne.dart';
import 'package:prototype/components/TextInputArea.dart';
import 'package:prototype/pages/HomePage.dart';
import 'package:prototype/pages/MainPage.dart';
import 'package:prototype/pages/authentication/SignUp.dart';
import 'package:prototype/pages/authentication/forgot_password_page.dart';

import 'package:prototype/services/Authenticationoperations.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future signInWithGoogleAccountPopup() async {
      try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        // Obtain the auth details from the request
        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        await FirebaseAuth.instance.signInWithCredential(credential);

        Navigator.pop(context);
      } catch (e) {
        print(e);
      }

      // Once signed in, return the UserCredential
    }

    Future SignInWithEmailPasswordFirebaseAuth() async {
      print(passwordController.text);
      final isValid = _formKey.currentState!.validate();
      if (isValid) {
        try {
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text,
            password: passwordController.text,
          );
          Navigator.pop(context);
        } on FirebaseAuthException catch (e) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            text: e.code,
          );
        }
      }
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 150,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Center(
                  child: Text(
                    'Hey Travelers Tips are  Next To You',
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                const Text(
                  'sign in',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 35),
                ),
                const SizedBox(
                  height: 15,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextInputArea(
                          label: "Email Address",
                          typeOfTextAreaToValidate: "email",
                          type: TextInputType.emailAddress,
                          isPassword: false,
                          icon: const Icon(Icons.person_2_outlined),
                          TextEditingController: emailController,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextInputArea(
                          label: "Your password",
                          typeOfTextAreaToValidate: "password",
                          isPassword: true,
                          type: TextInputType.visiblePassword,
                          icon: const Icon(Icons.lock_outline),
                          TextEditingController: passwordController,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ForgotPasswordPage(),
                                    ),
                                  );
                                },
                                child: const Text("Forgot Password?")),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () {
                            SignInWithEmailPasswordFirebaseAuth();
                          },
                          child: const ButtonOne(
                            label: "SIGN IN",
                            textColor: Colors.white,
                            icon: Icon(Icons.arrow_forward),
                            color: Color.fromRGBO(53, 208, 219, 1),
                          ),
                        ),
                      ],
                    )),

                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text(
                    "OR",
                    style: TextStyle(fontSize: 20, color: Colors.grey[600]),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                InkWell(
                  onTap: () {
                    signInWithGoogleAccountPopup();
                  },
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromARGB(255, 247, 246, 246),
                            spreadRadius: 5,
                            blurRadius: 5)
                      ],
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(),
                            Image.asset('assets/images/google.png'),
                            const Text(
                              "Login with Google",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromARGB(255, 247, 246, 246),
                          spreadRadius: 5,
                          blurRadius: 5)
                    ],
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(),
                          Image.asset('assets/images/facebook.png'),
                          const Text(
                            "Login with Facebook",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // ignore: prefer_const_constructors
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUp(),
                          ),
                        );
                      },
                      child: const Text(
                        "SignUp",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
