import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../routes/app_pages.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    nameController.text = 'Md. Miraz';
    phoneController.text = '01521432621';
    addressController.text = 'Dhaka, Bangladesh';
    passwordController.text = '123456';
    confirmPasswordController.text = '123456';
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Sign Up',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Create an account to continue!',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),
                Column(
                  children: [
                    const SizedBox(height: 24),
                    _buildTextField(
                      controller: nameController,
                      hint: 'Full Name',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: phoneController,
                      hint: 'Phone Number',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: addressController,
                      hint: 'Address',
                      icon: Icons.location_on,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: passwordController,
                      hint: 'Password',
                      icon: Icons.lock,
                      obscureText: obscurePassword,
                      suffix: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: confirmPasswordController,
                      hint: 'Confirm Password',
                      icon: Icons.lock,
                      obscureText: obscureConfirmPassword,
                      suffix: IconButton(
                        icon: Icon(
                          obscureConfirmPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            obscureConfirmPassword = !obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF26A69A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
      
                          signUpAndNavigate(
                            customerName: nameController.text,
                            customerMobile: phoneController.text,
                            address: addressController.text,
                            password: passwordController.text,
                            context: context,
                          );
                        },
                        child: const Text(
                          'SIGN UP',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Already have an account? ',
                          style: TextStyle(color: Colors.black54),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed(Routes.SIGN_IN),
                          child: const Text(
                            'Sign in',
                            style: TextStyle(
                              color: Color(0xFF26A69A),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text.rich(
                        TextSpan(
                          text: 'By tapping "Sign Up" you accept our ',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                          children: [
                            TextSpan(
                              text: 'terms',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'privacy policy',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffix,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        suffixIcon: suffix,
      ),
    );
  }
}

Future<void> signUpAndNavigate({
  required String customerName,
  required String customerMobile,
  required String address,
  required String password,
  required BuildContext context,
}) async {
  var url = Uri.parse('https://wa.acibd.com/price-survey/api/mobile-sign-up');
  var request =
      http.MultipartRequest('POST', url)
        ..fields['customerName'] = customerName
        ..fields['customerMobile'] = customerMobile
        ..fields['address'] = address
        ..fields['password'] = password;

  var response = await request.send();
  if (response.statusCode == 201) {
    var responseBody = await response.stream.bytesToString();
    var data = json.decode(responseBody);
    if (data['status'] == true) {
      // Navigate to login page
      Get.offAllNamed(Routes.SIGN_IN); // or use Navigator if not using GetX
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Sign up failed')),
      );
    }
  } else {
    // Show error message
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Network error')));
  }
}
