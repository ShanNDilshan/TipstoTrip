import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:prototype/components/ButtonOne.dart';
import 'package:prototype/components/TextInputArea.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = new TextEditingController();
    Future resetPassword() async {
      try {
        await FirebaseAuth.instance
            .sendPasswordResetEmail(email: emailController.text);
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          text: 'We Sent Password Reset link to your email address',
        );
      } catch (e) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          text: 'error $e',
        );
      }
    }

    return Scaffold(
      appBar: AppBar(),
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
                  'Forgot Password',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 25),
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
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    )),

                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    resetPassword();
                  },
                  child: const ButtonOne(
                    label: "Reset Password",
                    textColor: Colors.white,
                    icon: Icon(Icons.arrow_forward),
                    color: Color.fromRGBO(53, 208, 219, 1),
                  ),
                ),
                // ignore: prefer_const_constructors
              ],
            ),
          ),
        ),
      ),
    );
  }
}
