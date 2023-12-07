import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../controllers/auth_controller.dart';
import '../widgets/body_background.dart';
import 'login_screen.dart';
import 'main_bottom_nav_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    goToLogin();
  }

  void goToLogin() async {
    final bool isLoggedIn = await AuthController.checkAuthState();

    Future.delayed(const Duration(seconds: 2)).then((value) =>
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => isLoggedIn
                    ? const MainBottomNavScreen()
                    : const LoginScreen()),
            (route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BodyBackground(
            child: Center(
              child: SvgPicture.asset('assets/images/logo.svg'),
            ),
          ),
        ],
      ),
    );
  }
}
