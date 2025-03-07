// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBE8ktVRYCYyUujjAzQg3WdAk7q6q1ivYk',
    appId: '1:829145040440:android:a3bafecf23aa3f9c4048cd',
    messagingSenderId: '829145040440',
    projectId: 'tipstotrip-4075f',
    storageBucket: 'tipstotrip-4075f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAJuJsJK9xGFM4PGk9flzj_yOnAJCzZlAk',
    appId: '1:829145040440:ios:ab642b51c70a54ce4048cd',
    messagingSenderId: '829145040440',
    projectId: 'tipstotrip-4075f',
    storageBucket: 'tipstotrip-4075f.appspot.com',
    androidClientId:
        '829145040440-6qas2l14bppn1nqfg8f76qu3md9u46sr.apps.googleusercontent.com',
    iosClientId:
        '829145040440-g0cjmf7nual1hatdrbeg7mccj5ud8l19.apps.googleusercontent.com',
    iosBundleId: 'com.example.prototype',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCwsd8SyT_ZmytCwr_zfLjsUyGRcEAt41Y',
    appId: '1:829145040440:web:49a7c78f01683b7b4048cd',
    messagingSenderId: '829145040440',
    projectId: 'tipstotrip-4075f',
    authDomain: 'tipstotrip-4075f.firebaseapp.com',
    storageBucket: 'tipstotrip-4075f.appspot.com',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAJuJsJK9xGFM4PGk9flzj_yOnAJCzZlAk',
    appId: '1:829145040440:ios:ab642b51c70a54ce4048cd',
    messagingSenderId: '829145040440',
    projectId: 'tipstotrip-4075f',
    storageBucket: 'tipstotrip-4075f.appspot.com',
    androidClientId:
        '829145040440-6qas2l14bppn1nqfg8f76qu3md9u46sr.apps.googleusercontent.com',
    iosClientId:
        '829145040440-g0cjmf7nual1hatdrbeg7mccj5ud8l19.apps.googleusercontent.com',
    iosBundleId: 'com.example.prototype',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCwsd8SyT_ZmytCwr_zfLjsUyGRcEAt41Y',
    appId: '1:829145040440:web:60180c2006b78bbb4048cd',
    messagingSenderId: '829145040440',
    projectId: 'tipstotrip-4075f',
    authDomain: 'tipstotrip-4075f.firebaseapp.com',
    storageBucket: 'tipstotrip-4075f.appspot.com',
  );
}
