import 'package:flutter/material.dart';
import 'package:smartfarm/firebase_options.dart';
import 'package:smartfarm/screens/page.dart';
import 'package:smartfarm/screens/auth.dart';
import 'package:smartfarm/screens/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartfarm/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  var initializeApp = Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeApp;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Farm Connexion',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 57, 115, 41)),
      ),
      home: const AuthScreen(),
    );
  }
}
