import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/auth_controller.dart';
import 'routes/app_routes.dart';

void main() {
  // Register AuthController (dependency injection)
  Get.put(AuthController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Daily Health Tracker',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.login,   // Start from login
      getPages: AppRoutes.routes,      // Your routes list
    );
  }
}
