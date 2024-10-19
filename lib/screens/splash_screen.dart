import 'package:advisory_apps/widgets/toast_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

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
    await Future.delayed(const Duration(seconds: 5), () async {
      const storage = FlutterSecureStorage();

      final String tokenStore = await storage.read(key: 'key') ?? '';

      if ((tokenStore.isEmpty || tokenStore == 'null')) {
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
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: ClipRRect(
                    child: CircleAvatar(
                      radius: 100,
                      child: Image.asset(
                        'assets/images/advisory_logo.png',
                        fit: BoxFit.cover,
                      ),
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
