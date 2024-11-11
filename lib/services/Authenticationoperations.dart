import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authenticationoperations {
  signInWithGoogleAccountPopup() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential

    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}

class AuthenticationProcess {
  final String email;
  final String password;
  bool isAuthenticated;

  AuthenticationProcess(
      {required this.email,
      required this.password,
      this.isAuthenticated = false});

  login() async {
    try {
      final authentic = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return authentic;
    } catch (e) {
      return "error: $e";
    }
  }
}
