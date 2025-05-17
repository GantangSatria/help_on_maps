import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:help_on_maps/routes/app_pages.dart';
import 'package:help_on_maps/services/auth/auth_service.dart';
import 'package:help_on_maps/services/profile/profile_service.dart';

class ProfileController extends GetxController {
  final ProfileService _service = Get.put(ProfileService());
  final authService = Get.put(AuthService());

  Rxn<User>    get user     => _service.user;
  Rxn<Map<String, dynamic>> get userData => _service.userData;
  RxBool       get isLoading => _service.isLoading;

  void logout() async {
    await authService.logout();
    Get.offAllNamed(AppPages.loginPage);
  }

  @override
  void onInit() {
    super.onInit();
    _service.fetchUser();
  }
}