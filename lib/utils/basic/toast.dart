import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

void showError(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.redAccent,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

void showSuccess(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.green,
    textColor: Colors.white,
    fontSize: 16.0,
  );
}
