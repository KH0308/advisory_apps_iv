// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
        child: SingleChildScrollView(
          physics: const RangeMaintainingScrollPhysics(),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width * 0.90,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      5,
                      40,
                      5,
                      10,
                    ),
                    child: Container(
                      width: 180,
                      height: 180,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage("assets/images/advisory_logo.png"),
                          fit: BoxFit.fill,
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
    );
  }
}
