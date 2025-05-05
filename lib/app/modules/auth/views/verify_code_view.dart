import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';

class VerifyCodeView extends StatefulWidget {
  const VerifyCodeView({super.key});

  @override
  State<VerifyCodeView> createState() => _VerifyCodeViewState();
}

class _VerifyCodeViewState extends State<VerifyCodeView> {
  List<String> code = [];
  String? otp;
  String? phone;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    otp = args?['otp'];
    phone = args?['phone'];
  }

  void _onKeyTap(String value) {
    if (code.length < 6) {
      setState(() {
        code.add(value);
      });
    }
  }

  void _onBackspace() {
    if (code.isNotEmpty) {
      setState(() {
        code.removeLast();
      });
    }
  }

  void _verifyOtp() {
    final enteredCode = code.join();
    if (enteredCode == otp) {
      Get.toNamed(
        Routes.RESET_PASSWORD,
        arguments: {'phone': phone, 'otp': otp},
      );
    } else {
      Get.snackbar('Invalid OTP', 'The code you entered is incorrect.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('')),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter the verification code',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(6, (index) {
                        return Container(
                          width: 40,
                          height: 40,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            color:
                                code.length > index
                                    ? const Color(0xFF26A69A)
                                    : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Center(
                            child: Text(
                              code.length > index ? code[index] : '',
                              style: TextStyle(
                                fontSize: 22,
                                color:
                                    code.length > index
                                        ? Colors.white
                                        : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                // const SizedBox(height: 16),
                // Center(
                //   child: Column(
                //     children: [
                //       const Text(
                //         "I didn't receive the code!",
                //         style: TextStyle(color: Colors.black54),
                //       ),
                //       GestureDetector(
                //         onTap: () {},
                //         child: const Text(
                //           'Resend code',
                //           style: TextStyle(
                //             color: Color(0xFF26A69A),
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
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
                    onPressed: code.length == 6 ? _verifyOtp : null,
                    child: const Text(
                      'VERIFY',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                _buildKeypad(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', '<'],
    ];
    return Column(
      children:
          keys.map((row) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  row.map((key) {
                    if (key == '') {
                      return const SizedBox(width: 60, height: 60);
                    } else if (key == '<') {
                      return IconButton(
                        icon: const Icon(Icons.backspace),
                        iconSize: 28,
                        onPressed: _onBackspace,
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () => _onKeyTap(key),
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Center(
                              child: Text(
                                key,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  }).toList(),
            );
          }).toList(),
    );
  }
}
