import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  var userName = ''.obs;
  var userPhone = ''.obs;

  // Date picker
  var selectedDate = DateTime.now().obs;

  // District, Upazila, Mokam
  var districtList = [].obs;
  var upazillasList = [].obs;
  var mokamsList = [].obs;
  var selectedDistrictId = ''.obs;
  var selectedUpazillasId = ''.obs;
  var selectedMokamsId = ''.obs;

  var priceReportList = [].obs;

  String get formattedSelectedDate {
    final date = selectedDate.value;
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$day/$month/$year';
  }

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
    fetchDistricts();
  }

  Future<void> loadUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString('user');
    if (userString != null) {
      final userMap = json.decode(userString);
      userName.value = userMap['CustomerName'] ?? '';
      userPhone.value = userMap['CustomerMobile'] ?? '';
    }
  }

  void pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }

  Future<void> fetchDistricts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await http.get(
      Uri.parse('https://wa.acibd.com/price-survey/api/get-all-districts'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      print(response.body);
      final data = json.decode(utf8.decode(response.bodyBytes));
      final districts = data['districts'] ?? [];
      districtList.value = districts;
      if (districts.isNotEmpty) {
        selectedDistrictId.value = districts[0]['DistrictCode'];
        fetchUpazilaMokam(districts[0]['DistrictCode']);
      }
    }
  }

  Future<void> fetchUpazilaMokam(String districtId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await http.post(
      Uri.parse(
        'https://wa.acibd.com/price-survey/api/get-all-upazilla-mokam-by-district',
      ),
      headers: {'Authorization': 'Bearer $token'},
      body: {'district_id': districtId},
    );
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      final upazila = data['upazillas'] ?? [];
      upazillasList.value = upazila;
      final mokams = data['mokams'] ?? [];
      mokamsList.value = mokams;
    }
  }

  // Main fetch function with corrected encoding handling
  Future<void> fetchPriceReport() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {
      // First, let's see what encoding the server is using
      final response = await http.post(
        Uri.parse(
          'https://wa.acibd.com/price-survey/api/get-district-wise-daily-food-price-report',
        ),
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'districtID': "01",
          'upazillaID': "0134",
          'mokamID': "14",
          'date': "2025-02-19",
        },
      );

      // Debug information to examine the response
      print('Response Status Code: ${response.statusCode}');
      print('Response Content-Type: ${response.headers['content-type']}');

      if (response.statusCode == 200) {
        // Attempt multiple decoding approaches to diagnose the issue

        // Option 1: Direct UTF-8 decode of response body bytes
        try {
          final rawUtf8 = utf8.decode(response.bodyBytes);
          print(
            'Raw UTF-8 decode sample: ${rawUtf8.substring(0, min(100, rawUtf8.length))}',
          );

          final data = json.decode(rawUtf8);

          // First check if we can parse the JSON correctly
          if (data != null && data['priceReport'] != null) {
            priceReportList.value = data['priceReport'];

            // Test print the first item to see if we need further repair
            if (priceReportList.value.isNotEmpty) {
              final firstProduct = priceReportList.value.first;
              print(
                'First product with direct UTF-8 decode: ${firstProduct['ProductName']}',
              );

              // Check if the Bangla text needs fixing
              if (firstProduct['ProductName'].contains('à¦')) {
                print('Detected mojibake - applying fix');
                _applyBanglaFix();
              } else {
                print('No mojibake detected - UTF-8 decode worked correctly');
              }
            }

            for (var product in data['priceReport']) {
              print(decodeUtf8Escaped(product['ProductName']));
            }
          }
        } catch (e) {
          print('UTF-8 decode error: $e');
        }

        // If we're still seeing issues, try this advanced fix:
        if (_isMojibakePresent()) {
          _applyAdvancedBanglaFix();
        }
      } else {
        print('Unexpected response: ${response.body}');
        priceReportList.value = [];
        Get.snackbar('Error', 'Failed to fetch price report');
      }
    } catch (e) {
      print('Error fetching price report: $e');
      priceReportList.value = [];
      Get.snackbar('Error', 'Failed to fetch price report');
    }
  }

  // Helper method to check if mojibake is present
  bool _isMojibakePresent() {
    if (priceReportList.value.isEmpty) return false;

    // Check the first few items for the mojibake pattern
    int checkCount = min(5, priceReportList.value.length);
    for (int i = 0; i < checkCount; i++) {
      String productName = priceReportList.value[i]['ProductName'] ?? '';
      if (productName.contains('à¦')) {
        return true;
      }
    }
    return false;
  }

  // Apply the Bangla fix to the price report list
  void _applyBanglaFix() {
    for (int i = 0; i < priceReportList.value.length; i++) {
      var item = Map<String, dynamic>.from(priceReportList.value[i]);
      if (item.containsKey('ProductName')) {
        item['ProductName'] = decodeUtf8Escaped(item['ProductName']);
      }
      priceReportList.value[i] = item;
    }
    priceReportList.refresh();

    // Print a sample after fixing to verify
    if (priceReportList.value.isNotEmpty) {
      print('Sample after fix: ${priceReportList.value[0]['ProductName']}');
    }
  }

  // More advanced fix that tries multiple approaches
  void _applyAdvancedBanglaFix() {
    for (int i = 0; i < priceReportList.value.length; i++) {
      var item = Map<String, dynamic>.from(priceReportList.value[i]);

      if (item.containsKey('ProductName')) {
        String original = item['ProductName'];

        // Try multiple approaches and use the one that works
        List<String> attempts = [
          fixBangla(original), // Standard fix
          fixDoubleMojibake(original), // For double encoding issues
          fixWithWindows1252(original), // For Windows-1252 encoding issues
        ];

        // Print debugging info
        print('Original: $original');
        print('Fix 1: ${attempts[0]}');
        print('Fix 2: ${attempts[1]}');
        print('Fix 3: ${attempts[2]}');

        // Choose the best result (this is heuristic and may need adjustment)
        String fixed = _chooseBestResult(attempts);
        item['ProductName'] = fixed;
      }

      priceReportList.value[i] = item;
    }

    priceReportList.refresh();
  }

  // Choose the best result based on heuristics
  String _chooseBestResult(List<String> attempts) {
    // Simple heuristic: prefer strings with Bangla characters
    for (String attempt in attempts) {
      // Check if string contains Bangla Unicode range
      if (attempt.codeUnits.any((c) => c >= 0x0980 && c <= 0x09FF)) {
        return attempt;
      }
    }

    // If no clear winner, return the first attempt
    return attempts[0];
  }

  // Standard fix for UTF-8 text incorrectly decoded as Latin-1
  String fixBangla(String mojibake) {
    try {
      return utf8.decode(latin1.encode(mojibake));
    } catch (e) {
      print('Error in fixBangla: $e');
      return mojibake;
    }
  }

  // Fix for double-mojibake (text encoded twice)
  String fixDoubleMojibake(String doubleMojibake) {
    try {
      // First convert back to bytes assuming Latin-1
      List<int> bytes = latin1.encode(doubleMojibake);

      // Then try to decode as UTF-8
      String singleMojibake = utf8.decode(bytes, allowMalformed: true);

      // Then apply the standard fix
      return fixBangla(singleMojibake);
    } catch (e) {
      print('Error in fixDoubleMojibake: $e');
      return doubleMojibake;
    }
  }

  // Alternative fix using Windows-1252 encoding
  String fixWithWindows1252(String mojibake) {
    try {
      // This requires a Windows-1252 codec which isn't built-in
      // For demonstration - in practice you'd need to implement this
      // or use a package that provides Windows-1252 encoding

      // Simulation of Windows-1252 encoding (not accurate, just for demonstration)
      List<int> bytes = [];
      for (int i = 0; i < mojibake.length; i++) {
        int code = mojibake.codeUnitAt(i);
        bytes.add(code < 256 ? code : 63); // '?' for non-Windows-1252 chars
      }

      return utf8.decode(bytes, allowMalformed: true);
    } catch (e) {
      print('Error in fixWithWindows1252: $e');
      return mojibake;
    }
  }

  // Helper function
  int min(int a, int b) {
    return a < b ? a : b;
  }

  String decodeUtf8Escaped(String input) {
    final bytes = input.codeUnits;
    return utf8.decode(bytes, allowMalformed: true);
  }
}
