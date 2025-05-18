import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_on_maps/modules/auth/controllers/auth_controller.dart';
import 'package:help_on_maps/modules/auth/widgets/auth_text_field.dart';
import 'package:help_on_maps/routes/app_pages.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final authController = Get.put(AuthController());
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/LoginImage.png',
              fit: BoxFit.cover,
              height: 200,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color.fromARGB(255, 207, 224, 243), Colors.white],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Login',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sign in to start help those who in need',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Email',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  AuthTextField(
                    controller: emailController,
                    hintText: 'example@email.com',
                    prefixIcon: Icons.email_outlined,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!GetUtils.isEmail(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Password',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => AuthTextField(
                      controller: passwordController,
                      hintText: 'password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: !authController.isPasswordVisible.value,
                      suffixIcon: IconButton(
                        icon: Icon(
                          authController.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: authController.togglePasswordVisibility,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
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
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 55),
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Belum punya akun? "),
                      GestureDetector(
                        onTap: () => Get.offNamed(AppPages.registerPage),
                        child: const Text(
                          "Daftar",
                          style: TextStyle(color: Color(0xff3498DB)),
                        ),
                      ),
                      Text(' sekarang'),
                    ],
                  ),
                  const SizedBox(height: 250),
                ],
              ),
            ),
          ),
        ],

        //     child: Column(
        //       children: [
        //         TextField(
        //           controller: emailController,
        //           decoration: InputDecoration(labelText: 'Email'),
        //         ),
        //         TextField(
        //           controller: passwordController,
        //           obscureText: true,
        //           decoration: InputDecoration(labelText: 'Password'),
        //         ),

        //         const SizedBox(height: 20),

        // ElevatedButton(
        //   onPressed: () async {
        //     final email = emailController.text.trim();
        //     final password = passwordController.text;

        //     if (email.isEmpty || password.isEmpty) {
        //       Get.snackbar("Error", "Email, and Password cannot be empty");
        //       return;
        //     }

        //     try {
        //       Get.dialog(
        //         Center(child: CircularProgressIndicator()),
        //         barrierDismissible: false,
        //       );

        //       authController.login(email, password);

        //       Get.back();
        //     } catch (e) {
        //       Get.back();
        //       Get.snackbar("Error", e.toString());
        //     }
        //   },
        //   child: const Text('Login'),
        // ),
        // SizedBox(height: 22),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Text("Belum punya akun? "),
        //     GestureDetector(
        //       onTap: () => Get.offNamed(AppPages.registerPage),
        //       child: const Text(
        //         "Daftar",
        //         style: TextStyle(color: Color(0xff3498DB)),
        //       ),
        //     ),
        //     Text(' sekarang'),
        //   ],
        // ),
        //       ],
        //     ),
        //   ),
      ),
    );
  }
}
