import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_on_maps/modules/auth/controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  
  final authController = Get.put(AuthController());
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(

    );
  }
  
}