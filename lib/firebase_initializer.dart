import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

class FirebaseInitializer extends StatelessWidget {
  const FirebaseInitializer({required this.widget, super.key});
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform
        ),
        builder: (context, snapshot){
          if(snapshot.hasData){
            // return const Text('Yay you\'re connected to firebase');
            return widget;
          }
          return const CircularProgressIndicator();
        }
    );
  }
}
