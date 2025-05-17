import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_on_maps/modules/auth/controllers/auth_controller.dart';
import 'package:help_on_maps/modules/auth/controllers/register_controller.dart';
import 'package:help_on_maps/routes/app_pages.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final RegisterController controller = Get.put(RegisterController());
  final authController = Get.put(AuthController());

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
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
            const Text("Select Role(s):"),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: Text('Volunteer'),
                    selected: controller.isSelected('volunteer'),
                    onSelected: (_) => controller.toggleRole('volunteer'),
                  ),
                  const SizedBox(width: 10),
                  ChoiceChip(
                    label: Text('Requester'),
                    selected: controller.isSelected('requester'),
                    onSelected: (_) => controller.toggleRole('requester'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final roles = controller.selectedRoles;
                if (roles.isEmpty) {
                  Get.snackbar(
                    "Role Required",
                    "Please select at least one role.",
                  );
                  return;
                }

                final name = nameController.text.trim();
                final email = emailController.text.trim();
                final password = passwordController.text;

                if (name.isEmpty || email.isEmpty || password.isEmpty) {
                  Get.snackbar(
                    "Error",
                    "Name, Email, and Password cannot be empty",
                  );
                  return;
                }

                try {
                  Get.dialog(
                    Center(child: CircularProgressIndicator()),
                    barrierDismissible: false,
                  );

                  authController.register(email, password, name, roles);

                  Get.back();
                } catch (e) {
                  Get.back();
                  Get.snackbar("Error", e.toString());
                }
              },
              child: const Text('Register'),
            ),
            SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Sudah punya akun? "),
                GestureDetector(
                  onTap: () => Get.offNamed(AppPages.loginPage),
                  child: const Text(
                    "Masuk",
                    style: TextStyle(color: Color(0xff3498DB)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
