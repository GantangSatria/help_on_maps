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
      appBar: AppBar(title: const Text('Login'),),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                final email = emailController.text.trim();
                final password = passwordController.text;

                if (email.isEmpty || password.isEmpty) {
                  Get.snackbar(
                    "Error",
                    "Email, and Password cannot be empty",
                  );
                  return;
                }

                try {
                  Get.dialog(
                    Center(child: CircularProgressIndicator()),
                    barrierDismissible: false,
                  );

                  authController.login(email, password);

                  Get.back(); 
                  
                } catch (e) {
                  Get.back();
                  Get.snackbar("Error", e.toString());
                }
              }, 
              child: const Text('Login')
            ),
          ],
        ),
      ),
    );
  }
  
}