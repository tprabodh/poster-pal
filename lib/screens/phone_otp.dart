import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:text1/constants/constants.dart';
import 'package:text1/constants/routes.dart';
import 'package:text1/models/consumer.dart';
import 'package:text1/screens/phone_sign_in.dart';
import 'package:text1/services/auth.dart';
import 'package:text1/services/database.dart';

class PhoneOtp extends StatefulWidget {
  const PhoneOtp({Key? key}) : super(key: key);

  @override
  State<PhoneOtp> createState() => _PhoneOtpState();
}

class _PhoneOtpState extends State<PhoneOtp> {
  String? otp;
  final _formKey = GlobalKey<FormState>();
  String error = '';
  String defName = "Default Name";
  List<String> emptyImageUrls = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: const Text('Enter Your OTP'),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Enter Your OTP',style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),),
              const SizedBox(height: 10,),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'Enter your otp'),
                validator: (val) => val!.isEmpty ? 'Enter an otp' : null,
                keyboardType: TextInputType.phone,
                onChanged: (val) {
                  setState(() => otp = val);
                },
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.cyan[400], // Text color
                    elevation: 4, // Elevation
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6), // Rounded edges
                      side: const BorderSide(
                          color: Colors.black, width: 1.0), // Small black border
                    ),
                  ),
                onPressed: () async {
                  try {
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: PhoneSignIn.verify,
                      smsCode: otp!,
                    );
                    // Sign the user in with the credential
                    await auth.signInWithCredential(credential);

                    // Get the authenticated user from the AuthService stream
                    Cansumer? currentUser;
                    StreamSubscription<Cansumer?>? subscription;

                    subscription = AuthService().consumer.listen((user) async {
                      currentUser = user;
                      subscription?.cancel(); // Cancel the stream subscription
                      if (currentUser != null){
                        // Create a document in the consumers collection with name and empty imageUrls list
                        String consumerId=currentUser!.uid;
                        DatabaseService(uid: currentUser!.uid).updateUserDetails(consumerId);
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setBool('isUserLoggedIn', true);
                        // Navigate to the TextInputScreen
                        Navigator.pushNamed(context, MyRoute.homeRoute);
                      }
                    });

                  } catch (e) {
                    print('Error: $e');
                  }
                },
                  child: const Text(
                    'verify',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
