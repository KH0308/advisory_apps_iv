import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes/app_route.dart';

void main() {
  runApp(const AdvisoryApps());
}

class AdvisoryApps extends StatelessWidget {
  const AdvisoryApps({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AdvisoryApps',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      initialRoute: '/splashScreen',
      getPages: AppRoute.routes,
    );
  }
}
