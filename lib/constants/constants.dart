import 'package:flutter/material.dart';

var textInputDecoration=InputDecoration(
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.brown.shade100,width:2.0)
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.cyan,width:2.0)
    )
);