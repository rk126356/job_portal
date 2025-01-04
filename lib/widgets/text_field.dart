import 'package:flutter/material.dart';

Widget buildTextField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  bool obscureText = false,
  TextInputType? keyboardType,
  Widget? suffix,
}) {
  return TextFormField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.blue.shade800),
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.blue.shade200),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.blue.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.blue.shade800),
      ),
      filled: true,
      fillColor: Colors.white,
    ),
    obscureText: obscureText,
    keyboardType: keyboardType,
    style: const TextStyle(color: Colors.black),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return 'This field is required';
      }
      return null;
    },
  );
}
