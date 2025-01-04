import 'dart:ui';

import 'package:flutter/material.dart';

class CustomErrorBox extends StatelessWidget {
  const CustomErrorBox({super.key, required this.text, this.showBackButton});

  final String text;
  final bool? showBackButton;

  @override
  Widget build(BuildContext context) {
    if (showBackButton != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomErrorBox(text: text),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back, size: 20),
                label: const Text('Go Back'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5,
                  textStyle: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    }
    return Card(
      color: Colors.white,
      elevation: 4,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
            child: Text(
          text,
          textAlign: TextAlign.center,
        )),
      ),
    );
  }
}

Future<bool?> showConfirmDialog({
  required BuildContext context,
  required String title,
  String content = 'Are you sure?',
  String confirmText = 'Confirm',
  String cancelText = 'Cancel',
  Color confirmColor = Colors.redAccent,
  Color cancelColor = Colors.teal,
}) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey[200]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              // Content
              Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Cancel Button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(false),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: cancelColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: cancelColor, width: 2),
                      ),
                      child: Text(
                        cancelText,
                        style: TextStyle(
                          color: cancelColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  // Confirm Button
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [confirmColor, confirmColor.withOpacity(0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: confirmColor.withOpacity(0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text(
                        confirmText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
