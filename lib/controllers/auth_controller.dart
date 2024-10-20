// ignore_for_file: use_build_context_synchronously

import 'package:advisory_apps/widgets/toast_bar_widget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/database_service.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;
  var obsScrText = true.obs;
  ToastBarWidget toastBarWidget = ToastBarWidget();

  void updateObsScrText() {
    obsScrText.value = !obsScrText.value;
  }

  checkConnectivity() async {
    var connectionResult = await Connectivity().checkConnectivity();

    if (connectionResult != ConnectivityResult.mobile &&
        connectionResult != ConnectivityResult.wifi) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> signInUser(
      String email, String pass, BuildContext context) async {
    try {
      isLoading(true);
      debugPrint('${isLoading.value}');
      debugPrint(
          'Sending request to login with email: $email and password: $pass');
      var fetchSignIn = await DatabaseService().authSignIn(email, pass);
      debugPrint('$fetchSignIn');
      if (fetchSignIn['status']['code'] == 200) {
        toastBarWidget.displaySnackBar(
          'Welcome Back',
          Colors.black,
          Colors.white,
          context,
        );
        isLoading(false);
        Get.offAllNamed('/homeScreen');
      } else {
        isLoading(false);
        toastBarWidget.displaySnackBar(
          '${fetchSignIn['status']['message']}',
          Colors.black,
          Colors.red,
          context,
        );
      }
    } catch (e) {
      'Failed to sign in: $e';
    } finally {
      isLoading(false);
      debugPrint('Final loading state ${isLoading.value}');
    }
  }
}
