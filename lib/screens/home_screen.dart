import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/list_controller.dart';
import '../widgets/toast_bar_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ToastBarWidget toastBarWidget = ToastBarWidget();
  DateTime timeBackPressed = DateTime.now();

  final ListController listController = Get.put(ListController());

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
            toastBarWidget.displaySnackBar(
                'Press back again to exit',
                Colors.black,
                const Color.fromARGB(255, 175, 166, 166),
                context);
          } else {
            ScaffoldMessenger.of(context).clearSnackBars();
            SystemNavigator.pop();
          }
        }
      },
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: CircleAvatar(
              radius: 50,
              child: Image.asset(
                'assets/images/advisory_logo.png',
                fit: BoxFit.cover,
              ),
            ),
            centerTitle: true,
            title: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Advisory',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                  TextSpan(
                    text: 'Apps',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  await prefs.clear();
                  Get.offAllNamed('/signinScreen');
                },
                icon: Icon(
                  Icons.logout_rounded,
                  color: Colors.brown.shade900,
                  size: 24,
                ),
              ),
            ],
          ),
          body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.95,
            child: Obx(
              () {
                if (listController.isLoading.value) {
                  return Align(
                    alignment: Alignment.center,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.black,
                      strokeWidth: 4.0,
                      strokeCap: StrokeCap.round,
                      valueColor: AlwaysStoppedAnimation(
                        Colors.brown.shade400,
                      ),
                    ),
                  );
                } else if (listController.errorMessage.value ==
                    'Invalid Token') {
                  WidgetsBinding.instance.addPostFrameCallback(
                    (_) {
                      showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => AlertDialog.adaptive(
                          backgroundColor: Colors.brown.shade900,
                          title: Text(
                            'Token Expired or Invalid',
                            style: GoogleFonts.lato(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: Text(
                            'You will be redirected to the login page',
                            style: GoogleFonts.lato(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          actionsAlignment: MainAxisAlignment.center,
                          actions: [
                            ElevatedButton(
                              onPressed: () async {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.clear();
                                Get.offAllNamed('/signinScreen');
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                                fixedSize: MaterialStateProperty.all(
                                    const Size(100, 20)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                              child: Text(
                                'Proceed',
                                style: GoogleFonts.lato(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (listController.errorMessage.value !=
                    'Invalid Token') {
                  return RefreshIndicator(
                    color: Colors.brown.shade400,
                    backgroundColor: Colors.black,
                    onRefresh: listController.fetchData,
                    child: ListView(
                      children: [
                        Center(
                          child: Text(
                            "Opps Something Wrong\nTry again later",
                            style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  color: Colors.brown.shade400,
                  backgroundColor: Colors.black,
                  onRefresh: listController.fetchData,
                  child: listController.listData.isNotEmpty
                      ? ListView.separated(
                          itemCount: listController.listData.length,
                          separatorBuilder: (context, index) => Divider(
                            color: Colors.brown.shade400,
                          ),
                          itemBuilder: (context, index) {
                            final dataIndex = listController.listData[index];
                            return Card(
                              color: Colors.brown.shade900,
                              shadowColor: Colors.black,
                              child: ListTile(
                                tileColor: Colors.transparent,
                                leading: CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.white,
                                  child: Text(
                                    dataIndex['id'],
                                    style: GoogleFonts.lato(
                                      color: Colors.brown.shade900,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  'Name: ${dataIndex['list_name']}',
                                  style: GoogleFonts.lato(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'Distance: ${dataIndex['distance']}',
                                  style: GoogleFonts.lato(
                                    color: Colors.grey.shade400,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                onTap: () {
                                  final nameTap = dataIndex['list_name'];
                                  final distanceTap = dataIndex['distance'];
                                  toastBarWidget.displaySnackBar(
                                    'You tap on:\nName: $nameTap\nDistance: $distanceTap',
                                    Colors.brown.shade900,
                                    Colors.white,
                                    context,
                                  );
                                },
                              ),
                            );
                          },
                        )
                      : Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Data is empty',
                            style: GoogleFonts.lato(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
