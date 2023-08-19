import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:text1/constants/constants.dart';
import 'package:text1/constants/loading.dart';
import 'package:text1/constants/routes.dart';



class PhoneSignIn extends StatefulWidget {
  const PhoneSignIn({Key? key}) : super(key: key);

  static String verify='';

  @override
  State<PhoneSignIn> createState() => _PhoneSignInState();
}

class _PhoneSignInState extends State<PhoneSignIn> with SingleTickerProviderStateMixin{
  String? phone;
  final _formKey = GlobalKey<FormState>();
  String countryCode='+91';

late AnimationController controller;
late Animation animation;
late Animation animationTween;


@override
void initState(){
  super.initState();

  controller=AnimationController(
      vsync: this,
  duration:Duration(seconds: 1) );

  animation=CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
  );
  animationTween=ColorTween(begin: Colors.brown[300] ,end: Colors.white).animate(controller);

  controller.forward();
  controller.addListener(() {
    setState(() {
    });
  });
}
  @override
  void dispose(){
  controller.dispose();
  super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: animationTween.value,
      appBar: AppBar(
        backgroundColor: Colors.brown[400],
        title: const Text('Enter Your Mobile Number'),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: "icon tag",
                    child: Container(
                      height:controller.value*60,
                      child: Image.asset("assets/icon.png"),
                    ),
                  ),
                  SizedBox(width: 20.0,),
                  Text(
                    "Phone Verification",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "We need to register your phone before getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
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
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 40,
                      //gathering the user's country code
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            countryCode = value;
                          });
                        },
                        decoration: const InputDecoration(
                          hintText: '+91',
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const Text(
                      "|",
                      style: TextStyle(fontSize: 33, color: Colors.grey),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      //gathering the user's phone number
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
              const SizedBox(height: 10,),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.brown[400], // Text color
                    elevation: 4, // Elevation
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6), // Rounded edges
                      side: const BorderSide(
                          color: Colors.black, width: 1.0), // Small black border
                    ),
                  ),
                  //sending a otp code to the entered user's phone number
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const Loading()));

                      try {
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: countryCode + phone!,
                          verificationCompleted: (PhoneAuthCredential credential) {},
                          verificationFailed: (FirebaseAuthException e) {},
                          codeSent: (String verificationId, int? resendToken) async {
                            Navigator.pushReplacementNamed(context, MyRoute.otpRoute);
                            PhoneSignIn.verify = verificationId;
                          },
                          codeAutoRetrievalTimeout: (String verificationId) {},
                        );
                      } catch (e) {
                        //
                      }
                    } else {

                    }
                  },


                  child: const Text(
                    'Get otp',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  )
              ),
              const SizedBox(height: 12.0),
            ],
          ),
        ),
      ),
    );
  }
}
