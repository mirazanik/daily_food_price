import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  var userName = ''.obs;
  var userPhone = ''.obs;
  var isLoading = false.obs; // Add loading state

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

  String getFormattedSelectedDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    return '$year-$month-$day';
  }

  @override
  void onInit() {
    super.onInit();
    loadUserInfo();
    fetchDistricts(getFormattedSelectedDate(DateTime.now()));
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
      fetchDistricts(getFormattedSelectedDate(selectedDate.value));
      fetchPriceReport();
    }
  }

  Future<void> fetchDistricts(String date) async {
    print(date);
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await http.post(
      Uri.parse('https://wa.acibd.com/price-survey/api/get-all-districts'),
      headers: {'Authorization': 'Bearer $token'},
      body: {'date': date},
    );
    if (response.statusCode == 200) {
      print(response.body);
      final data = json.decode(utf8.decode(response.bodyBytes));
      final districts = data['districts'] ?? [];
      districtList.value = districts;
      // if (districts.isNotEmpty) {
      //   selectedDistrictId.value = districts[0]['DistrictCode'];
      //   fetchUpazilaMokam(districts[0]['DistrictCode']);
      // }
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
      print(response.statusCode);
      print(response.body);
      final data = json.decode(utf8.decode(response.bodyBytes));
      final upazila = data['upazillas'] ?? [];
      upazillasList.value = upazila;
      final mokams = data['mokams'] ?? [];
      mokamsList.value = mokams;
      selectedUpazillasId.value = '';
      selectedMokamsId.value = '';
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs
        .clear(); // This removes all, including saved_phone and saved_password
    // OR, if you only want to remove credentials:
    // await prefs.remove('saved_phone');
    // await prefs.remove('saved_password');
    Get.offAllNamed('/sign-in');
  }

  // Main fetch function with corrected encoding handling
  Future<void> fetchPriceReport() async {
    isLoading.value = true; // Start loading
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    print("###############################################################");

    print("###############################################################");
    print(selectedDistrictId.value);
    print(selectedUpazillasId.value);
    print(selectedMokamsId.value);
    print(selectedDate.value);
    print("###############################################################");
    try {
      final response = await http.post(
        Uri.parse(
          'https://wa.acibd.com/price-survey/api/get-district-wise-daily-food-price-report',
        ),
        headers: {'Authorization': 'Bearer $token'},
        body: {
          'districtID': selectedDistrictId.value,
          'upazillaID': selectedUpazillasId.value,
          'mokamID': selectedMokamsId.value,
          'date':
              selectedDate.value.toString().split(' ')[0], // Format: YYYY-MM-DD
        },
      );

      if (response.statusCode == 200) {
        final rawUtf8 = utf8.decode(response.bodyBytes);
        final data = json.decode(rawUtf8);

        print(data);

        if (data != null && data['priceReport'] != null) {
          // Process each item in the price report
          final processedReport =
              (data['priceReport'] as List).map((item) {
                final Map<String, dynamic> processedItem =
                    Map<String, dynamic>.from(item);

                // Fix Bangla text in ProductName
                if (processedItem.containsKey('ProductName')) {
                  processedItem['ProductName'] = decodeUtf8Escaped(
                    processedItem['ProductName'],
                  );
                }

                // Get all market names dynamically (excluding ProductCode, ProductName, and MinMax)
                final marketNames =
                    processedItem.keys
                        .where(
                          (key) =>
                              key != 'ProductCode' &&
                              key != 'ProductName' &&
                              key != 'MinMax',
                        )
                        .toList();

                // Add market names to the item for UI reference
                processedItem['marketNames'] = marketNames;

                return processedItem;
              }).toList();

          priceReportList.value = processedReport;
          priceReportList.refresh();

          print("dddddddddddddddddddddddddddddddddR");
          print(processedReport);
        } else {
          priceReportList.value = [];
          Get.snackbar(
            'Info',
            'No price data available for the selected criteria',
          );
        }
      } else {
        print('Error response: ${response.body}');
        priceReportList.value = [];
        Get.snackbar('Error', 'Failed to fetch price report');
      }
    } catch (e) {
      print('Error fetching price report: $e');
      priceReportList.value = [];
      Get.snackbar('Error', 'Failed to fetch price report');
    } finally {
      isLoading.value = false; // End loading
    }
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
