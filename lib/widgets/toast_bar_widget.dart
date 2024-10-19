import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ToastBarWidget {
  displaySnackBar(
      String messageText, Color colorBg, Color colorTxt, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: 200,
        padding: const EdgeInsets.all(10),
        backgroundColor: colorBg,
        content: Align(
          alignment: Alignment.center,
          child: Text(
            messageText,
            style: GoogleFonts.poppins(
              textStyle: TextStyle(
                color: colorTxt,
              ),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
