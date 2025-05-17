import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:help_on_maps/services/profile/profile_service.dart';

class ProfileController extends GetxController {
  final ProfileService _service = Get.put(ProfileService());

  Rxn<User>    get user     => _service.user;
  Rxn<Map<String, dynamic>> get userData => _service.userData;
  RxBool       get isLoading => _service.isLoading;

  @override
  void onInit() {
    super.onInit();
    _service.fetchUser();
  }
}