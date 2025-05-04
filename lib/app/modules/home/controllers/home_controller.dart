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
  var upazilaMokamList = [].obs;
  var selectedDistrictId = ''.obs;
  var selectedUpazilaMokamId = ''.obs;

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
      final data = json.decode(response.body);
      final districts = data['districts'] ?? [];
      districtList.value = districts;
      if (districts.isNotEmpty) {
        selectedDistrictId.value = districts[0]['DistrictCode'];
        //fetchUpazilaMokam(districts[0]['DistrictCode']);
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
      final data = json.decode(response.body);
      upazilaMokamList.value = data;
      if (data.isNotEmpty) {
        selectedUpazilaMokamId.value = data[0]['id'];
      }
    }
  }
}
