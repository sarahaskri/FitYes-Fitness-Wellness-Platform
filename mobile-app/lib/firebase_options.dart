
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCfsqBRMpJF0_ZBd1OMGLeZxx59-sruRDQ',
    appId: '1:709810362183:web:d66118ff5cd3ca01309e62',
    messagingSenderId: '709810362183',
    projectId: 'pushnotofaction',
    authDomain: 'pushnotofaction.firebaseapp.com',
    storageBucket: 'pushnotofaction.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCb6zS9VJS09qtUkRfqENQ7QDyeghIGqw8',
    appId: '1:709810362183:android:1195ca415f14acca309e62',
    messagingSenderId: '709810362183',
    projectId: 'pushnotofaction',
    storageBucket: 'pushnotofaction.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB_R2OQCuICWl3C2vbiEm_tjDrOkXDS65k',
    appId: '1:709810362183:ios:5854568019ce0156309e62',
    messagingSenderId: '709810362183',
    projectId: 'pushnotofaction',
    storageBucket: 'pushnotofaction.firebasestorage.app',
    iosClientId: '709810362183-82qega714301f205c0rgfc3ru6cafeg6.apps.googleusercontent.com',
    iosBundleId: 'com.example.fityes',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB_R2OQCuICWl3C2vbiEm_tjDrOkXDS65k',
    appId: '1:709810362183:ios:5854568019ce0156309e62',
    messagingSenderId: '709810362183',
    projectId: 'pushnotofaction',
    storageBucket: 'pushnotofaction.firebasestorage.app',
    iosClientId: '709810362183-82qega714301f205c0rgfc3ru6cafeg6.apps.googleusercontent.com',
    iosBundleId: 'com.example.fityes',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCfsqBRMpJF0_ZBd1OMGLeZxx59-sruRDQ',
    appId: '1:709810362183:web:b16f5128cc6d307a309e62',
    messagingSenderId: '709810362183',
    projectId: 'pushnotofaction',
    authDomain: 'pushnotofaction.firebaseapp.com',
    storageBucket: 'pushnotofaction.firebasestorage.app',
  );

}