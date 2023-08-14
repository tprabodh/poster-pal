import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:text1/constants.dart';
import 'package:text1/phoneOtp.dart';
import 'package:text1/services/auth.dart';
import 'package:text1/textInputScreen.dart';


class PhoneSignIn extends StatefulWidget {
  const PhoneSignIn({Key? key}) : super(key: key);

  static String verify='';

  @override
  State<PhoneSignIn> createState() => _PhoneSignInState();
}

class _PhoneSignInState extends State<PhoneSignIn> {
  String? phone;
  final _formKey = GlobalKey<FormState>();
  String error = '';
  String countryCode='+91';


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.brown[50],
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: Text('Enter Your Mobile Number'),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "We need to register your phone before getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),

              Container(
                height: 55,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 40,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            countryCode = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: '+91',
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: TextFormField(
                          decoration: textInputDecoration.copyWith(hintText: 'Enter your Mobile Number'),
                          validator: (val) => val!.isEmpty ? 'Enter a phone number' : null,
                          keyboardType: TextInputType.phone,
                          onChanged: (val) {
                            setState(() => phone = val);
                          },
                        ),)
                  ],
                ),
              ),


              SizedBox(height: 10,),
              ElevatedButton(
                  child: Text(
                    'Get otp',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.cyan[400], // Text color
                    elevation: 4, // Elevation
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6), // Rounded edges
                      side: BorderSide(
                          color: Colors.black, width: 1.0), // Small black border
                    ),
                  ),
                  onPressed: () async{
                    if(_formKey.currentState!.validate()){
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber:countryCode+phone!,
                      verificationCompleted: (PhoneAuthCredential credential) {},
                      verificationFailed: (FirebaseAuthException e) {},
                      codeSent: (String verificationId, int? resendToken) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PhoneOtp(),
                          ),
                        );
                        PhoneSignIn.verify=verificationId;
                      },
                      codeAutoRetrievalTimeout: (String verificationId) {
                        print('time out');
                      },
                    );
                    }
                    else(){
                      setState(() {
                        error="enter a valid phone number";
                      });
                    };
                  }
              ),
              SizedBox(height: 12.0),

            ],
          ),
        ),
      ),
    );
  }
}
