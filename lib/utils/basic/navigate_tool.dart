import 'package:flutter/material.dart';

void push(context, screen) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
}

void pushReplace(context, screen) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => screen));
}

void pushReplaceAll(context, screen) {
  Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (context) => screen), (_) => false);
}
