import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text1/firebase_options.dart';
import 'package:text1/screens/phoneSignIn.dart';
import 'package:text1/services/auth.dart';
import 'package:text1/screens/textInputScreen.dart';
import 'package:text1/models/consumer.dart';
import 'package:shared_preferences/shared_preferences.dart';



void main() async {
  // Initialize Firebase (if applicable)
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final prefs = await SharedPreferences.getInstance();
  final isUserLoggedIn = prefs.getBool('isUserLoggedIn') ?? false;

  runApp(MyApp(isUserLoggedIn: isUserLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isUserLoggedIn;

  MyApp({required this.isUserLoggedIn});
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Cansumer?>.value(
      value: AuthService().consumer,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: isUserLoggedIn ? TextInputScreen() : PhoneSignIn(),
      ),
    );
  }
}



