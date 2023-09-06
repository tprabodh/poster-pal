import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text1/constants/routes.dart';
import 'package:text1/firebase_options.dart';
import 'package:text1/screens/phone_otp.dart';
import 'package:text1/screens/phone_sign_in.dart';
import 'package:text1/services/auth.dart';
import 'package:text1/screens/text_Input_screen.dart';
import 'package:text1/models/app_user.dart';
import 'package:shared_preferences/shared_preferences.dart';



void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
//using SharedPreferences so that user is logged i until he explicitly logs out
  final prefs = await SharedPreferences.getInstance();
  final isUserLoggedIn = prefs.getBool('isUserLoggedIn') ?? false;

  runApp(MyApp(isUserLoggedIn: isUserLoggedIn));
}

class MyApp extends StatelessWidget {
  final bool isUserLoggedIn;

  const MyApp({super.key, required this.isUserLoggedIn});
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
      value: AuthService().consumer,
      initialData: null,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: isUserLoggedIn ? const TextInputScreen() : const PhoneSignIn(),
        routes: {
          MyRoute.homeRoute:(context)=>const TextInputScreen(),
          MyRoute.loginRoute:(context)=>const PhoneSignIn(),
          MyRoute.otpRoute:(context)=>const PhoneOtp(),
        },
      ),
    );
  }
}



