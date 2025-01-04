import 'dart:async';

import 'package:flutter/material.dart';
import 'package:job_portal/const/const.dart';
import 'package:job_portal/navigation/provider_bottom_navigation.dart';
import 'package:job_portal/screens/auth/register_login_screen.dart';
import 'package:provider/provider.dart';

import '../../../providers/user_provider.dart';
import '../../navigation/bottom_navigation.dart';
import '../../widgets/gradient_background.dart';

String globalUserId = '';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void skip() async {
    final provider = Provider.of<UserProvider>(context, listen: false);

    final isLoggedIn = await provider.loadUserLocal();

    Timer(
      const Duration(seconds: 2),
      () {
        print(isProvider);
        if (isLoggedIn) {
          globalUserId = provider.userData.userId;
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => isProvider
                      ? const ProviderBottomNavigation()
                      : const BottomNavigation()),
              (route) => false);
        } else {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) => const RegisterLoginScreen()),
              (route) => false);
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    skip();
  }

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        GradientBackground(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Hero(
              tag: 'open',
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ],
    );
  }
}
