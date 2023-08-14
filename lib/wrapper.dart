import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:text1/authenticate.dart';
import 'package:text1/textInputScreen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user =Provider.of<Consumer?>(context);
    if (user == null){
      return Authenticate();
    } else {
      return TextInputScreen();
    }
  }
}
