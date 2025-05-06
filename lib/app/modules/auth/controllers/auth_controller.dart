import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../constants/api_constants.dart';
import '../../../routes/app_pages.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

  Future<void> login(String phone, String password) async {
    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'Username': phone, 'Password': password},
      );

      final data = json.decode(response.body);
      if (data['status'] == 200) {
        // Save token and user info
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('user', json.encode(data['user']));
        await prefs.setString('saved_phone', phone);
        await prefs.setString('saved_password', password);

        // Navigate to home
        Get.offAllNamed(Routes.HOME);
      } else {
        Get.snackbar('Login Failed', 'Invalid credentials or server error');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // or remove only the credentials if you want
    Get.offAllNamed('/sign-in');
  }
}
