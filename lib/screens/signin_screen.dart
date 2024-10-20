// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../controllers/auth_controller.dart';
import '../widgets/toast_bar_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();
  ToastBarWidget toastBarWidget = ToastBarWidget();
  DateTime timeBackPressed = DateTime.now();

  AuthController authController = Get.put(AuthController());
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> signInWithFacebook() async {
    try {
      final result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        String email = userData['email'];
        String profilePicture = userData['picture']['data']['url'];
        _showProfileDialog(email, profilePicture);
      } else {
        debugPrint('Facebook login failed:${result.message}');
        toastBarWidget.displaySnackBar(
          'Facebook login failed: ${result.message}',
          Colors.red,
          Colors.white,
          context,
        );
      }
    } catch (e) {
      debugPrint('Error occurred:$e');
      toastBarWidget.displaySnackBar(
        'Error occurred: $e',
        Colors.red,
        Colors.white,
        context,
      );
    }
  }

  void _showProfileDialog(String email, String profilePicture) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: const EdgeInsets.all(10),
        backgroundColor: Colors.brown.shade900,
        title: Align(
          alignment: Alignment.center,
          child: Text(
            email,
            style: GoogleFonts.lato(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(profilePicture),
            ),
          ],
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          Obx(
            () => TextButton(
              onPressed: () async {
                //use credidential provide by advisory to getting a token
                await authController.signInUserFB(
                  'movida@advisoryapps.com',
                  'movida123',
                  profilePicture,
                  context,
                );
              },
              child: authController.isLoadingFB.isTrue
                  ? Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.grey.shade400,
                          strokeWidth: 4.0,
                          strokeCap: StrokeCap.round,
                          valueColor:
                              const AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                    )
                  : Text(
                      'Lets Go',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.white,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          final difference = DateTime.now().difference(timeBackPressed);
          final isExitWarning = difference >= const Duration(seconds: 2);

          timeBackPressed = DateTime.now();

          if (isExitWarning) {
            toastBarWidget.displaySnackBar('Press back again to exit',
                Colors.black, Colors.white, context);
          } else {
            ScaffoldMessenger.of(context).clearSnackBars();
            SystemNavigator.pop();
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              physics: const RangeMaintainingScrollPhysics(),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.90,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        5,
                        40,
                        5,
                        30,
                      ),
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image:
                                AssetImage("assets/images/advisory_logo.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      'Sign In',
                      style: GoogleFonts.poppins(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Email is required';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            controller: emailController,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.black,
                              fontStyle: FontStyle.normal,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.email_rounded),
                              prefixIconColor: Colors.brown.shade900,
                              labelText: 'Email',
                              hintText: 'abc@domain.com',
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 10,
                                color: Colors.grey,
                                fontStyle: FontStyle.normal,
                              ),
                              fillColor: Colors.grey.shade200,
                              filled: true,
                              border: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.all(16.0),
                              floatingLabelStyle: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.normal,
                              ),
                              labelStyle: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 14,
                                fontStyle: FontStyle.normal,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.brown.shade900),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.brown.shade900),
                              ),
                              errorBorder: const OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              errorStyle: const TextStyle(color: Colors.red),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          Obx(
                            () => TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                }
                                return null;
                              },
                              textInputAction: TextInputAction.done,
                              controller: passwordController,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.black,
                                fontStyle: FontStyle.normal,
                              ),
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.lock_rounded),
                                prefixIconColor: Colors.brown.shade900,
                                labelText: 'Password',
                                hintText: '**********',
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 10,
                                  color: Colors.grey,
                                  fontStyle: FontStyle.normal,
                                ),
                                fillColor: Colors.grey.shade200,
                                filled: true,
                                border: const OutlineInputBorder(),
                                contentPadding: const EdgeInsets.all(16.0),
                                floatingLabelStyle: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FontStyle.normal,
                                ),
                                labelStyle: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontStyle: FontStyle.normal,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.brown.shade900),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.brown.shade900),
                                ),
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                                errorStyle: const TextStyle(color: Colors.red),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                      authController.obsScrText.value
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: authController.obsScrText.value
                                          ? Colors.black12
                                          : Colors.brown.shade900),
                                  onPressed: () {
                                    authController.updateObsScrText();
                                  },
                                ),
                              ),
                              obscureText: authController.obsScrText.value,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Obx(
                      () => ElevatedButton(
                        onPressed: () async {
                          final isValidForm = formKey.currentState?.validate();
                          if (isValidForm != false) {
                            var resultState =
                                await authController.checkConnectivity();
                            if (resultState == true) {
                              debugPrint(
                                  'Email: ${emailController.text}, Password: ${passwordController.text}');
                              authController.signInUser(
                                emailController.text,
                                passwordController.text,
                                context,
                              );
                            } else {
                              toastBarWidget.displaySnackBar(
                                'Opps something wrong with connection',
                                Colors.red,
                                Colors.white,
                                context,
                              );
                            }
                          } else {
                            toastBarWidget.displaySnackBar(
                              'All field need to be fill!!',
                              Colors.red,
                              Colors.white,
                              context,
                            );
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.brown.shade900),
                          fixedSize:
                              MaterialStateProperty.all(const Size(100, 30)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        child: authController.isLoading.isTrue
                            ? Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    backgroundColor: Colors.brown.shade900,
                                    strokeWidth: 4.0,
                                    strokeCap: StrokeCap.round,
                                    valueColor: const AlwaysStoppedAnimation(
                                        Colors.white),
                                  ),
                                ),
                              )
                            : Text(
                                'Sign In',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      width: 100,
                      child: Center(
                        child: Text(
                          'OR',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            color: Colors.black,
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        var resultState =
                            await authController.checkConnectivity();

                        if (resultState == true) {
                          signInWithFacebook();
                        } else {
                          toastBarWidget.displaySnackBar(
                            'Opps something wrong with connection',
                            Colors.red,
                            Colors.white,
                            context,
                          );
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blue),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      child: Text(
                        'Login with Facebook',
                        style: GoogleFonts.poppins(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text.rich(
                      TextSpan(
                        children: [
                          WidgetSpan(
                            child: Icon(
                              Icons.check_box,
                              color: Colors.brown.shade900,
                              size: 16,
                            ),
                          ),
                          const TextSpan(
                            text: ' ',
                          ),
                          TextSpan(
                            text: 'By clicking you agree with\n',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                          TextSpan(
                            text: 'Term of Service & Privacy Policy',
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
