import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  var username = "".obs;

  // Simple login validation
  bool login(String user, String pass) {
    if (user.isEmpty || pass.isEmpty) {
      Get.snackbar("Error", "Please enter username & password");
      return false;
    } else if (user == "user" && pass == "12345") {
      username.value = user;
      isLoggedIn.value = true;
      return true; // ✅ login success
    } else {
      Get.snackbar("Login Failed", "Invalid credentials");
      return false;
    }
  }

  void logout() {
    isLoggedIn.value = false;
    username.value = "";
    Get.offAllNamed('/login');
  }
}
