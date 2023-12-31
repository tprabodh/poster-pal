import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  const Loading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.brown.withOpacity(1.0),
      child: const Center(
        child: SpinKitWanderingCubes(
          color: Colors.cyanAccent,
          size: 50.0,
        ),
      ),
    );
  }
}