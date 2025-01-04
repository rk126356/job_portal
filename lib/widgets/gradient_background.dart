import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget? child;

  const GradientBackground({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue.shade100, Colors.white],
        ),
      ),
      child: child,
    );
  }
}
