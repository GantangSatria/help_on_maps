import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:help_on_maps/routes/app_pages.dart';
import 'package:help_on_maps/services/auth/auth_service.dart';

class AuthController extends GetxController {
  final _auth = FirebaseAuth.instance;
  final Rx<User?> firebaseUser = Rx<User?>(null);

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(_auth.authStateChanges());
  }

    void login(String email, String password) async {
    try {
      final user = await AuthService().signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (user != null) {
        Get.offAllNamed(AppPages.homePage);
      } else {
        Get.snackbar("Login Gagal", "Email atau password salah");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  void register(String email, String password, String name, List<String> role, String text) async {
    try {
      final user = await AuthService().registerWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
        roles: role,
      );

      if (user != null) {
        Get.snackbar("Berhasil", "Registrasi berhasil, silakan login");
        Get.offNamed(AppPages.loginPage);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}