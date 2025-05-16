import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_on_maps/modules/auth/controllers/register_controller.dart';
import 'package:help_on_maps/services/auth/auth_service.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  final RegisterController controller = Get.put(RegisterController());
  final authService = AuthService();

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
                // Add your AuthService call here
                final roles = controller.selectedRoles;
                if (roles.isEmpty) {
                  Get.snackbar(
                    "Role Required",
                    "Please select at least one role.",
                  );
                  return;
                }

                // Call your AuthService here with name, email, password, and roles
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

                  final user = await authService.registerWithEmailAndPassword(
                    name: name,
                    email: email,
                    password: password,
                    roles: roles,
                  );

                  Get.back(); // remove loading

                  if (user != null) {
                    Get.offAllNamed('/home'); // or your app's home route
                  } else {
                    Get.snackbar(
                      "Registration Failed",
                      "Unknown error occurred",
                    );
                  }
                } catch (e) {
                  Get.back();
                  Get.snackbar("Error", e.toString());
                }
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
