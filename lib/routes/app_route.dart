import 'package:get/get.dart';

import '../screens/home_screen.dart';
import '../screens/signin_screen.dart';
import '../screens/splash_screen.dart';

class AppRoute {
  static final routes = [
    GetPage(name: '/splashScreen', page: () => const SplashScreen()),
    GetPage(name: '/signinScreen', page: () => const SignInScreen()),
    GetPage(name: '/homeScreen', page: () => const HomeScreen()),
  ];
}
