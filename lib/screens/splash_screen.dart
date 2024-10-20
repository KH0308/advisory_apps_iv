import 'package:advisory_apps/widgets/toast_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ToastBarWidget toastBarWidget = ToastBarWidget();

  @override
  void initState() {
    super.initState();
    checkTokenStatus();
  }

  @override
  void dispose() {
    super.dispose();
  }

  navigateToSignIn() {
    Get.offNamed('/signinScreen');
    toastBarWidget.displaySnackBar(
        "Session Expired\n Re-SignIn Again", Colors.white, Colors.red, context);
  }

  navigateToHome() {
    Get.offNamed('/homeScreen');
    toastBarWidget.displaySnackBar(
        'Welcome Back', Colors.green, Colors.white, context);
  }

  checkTokenStatus() async {
    await Future.delayed(const Duration(seconds: 4), () async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String idStore = prefs.getString('id') ?? '';
      final String tokenStore = prefs.getString('token') ?? '';

      if ((tokenStore.isEmpty ||
          tokenStore == '' && idStore.isEmpty ||
          idStore == '')) {
        navigateToSignIn();
      } else {
        navigateToHome();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 100,
                    child: Image.asset(
                      'assets/images/advisory_logo.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                SizedBox(
                  width: 80,
                  height: 40,
                  child: Lottie.asset(
                    'assets/json/loading_animation.json',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
