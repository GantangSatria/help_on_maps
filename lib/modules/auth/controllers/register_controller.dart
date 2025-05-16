import 'package:get/get.dart';

class RegisterController extends GetxController {
  var selectedRoles = <String>[].obs;

  void toggleRole(String role) {
    if (selectedRoles.contains(role)) {
      selectedRoles.remove(role);
    } else {
      selectedRoles.add(role);
    }
  }

  bool isSelected(String role) => selectedRoles.contains(role);
}
