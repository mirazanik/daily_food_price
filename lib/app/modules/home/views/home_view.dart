import 'package:daily_food_price/constants/custom_image_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF26A69A),
          elevation: 0,
          // leading: IconButton(
          //   icon: const Icon(Icons.menu, color: Colors.white),
          //   onPressed: () {},
          // ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Text(
                  controller.userName.value,
                  textAlign: TextAlign.left,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Obx(
                () => Text(
                  textAlign: TextAlign.left,
                  controller.userPhone.value,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                controller.logout();
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomImageView(
                  alignment: Alignment.center,
                  imagePath: "assets/images/dashboard.png",
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),

                    hintText: 'Search',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),

                _FilterSection(controller),

                const SizedBox(height: 8),
                Obx(() {
                  if (controller.selectedUpazillasId.value.isNotEmpty ||
                      controller.selectedMokamsId.value.isNotEmpty) {
                    final priceList = controller.priceReportList;
                    if (priceList.isEmpty) {
                      return const Center(child: Text('No data found'));
                    }
                    return SizedBox(
                      height: 350,
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Expanded(
                            child: Column(
                              children: [
                                Container(
                                  color: const Color(0xFF26A69A),
                                  child: Row(
                                    children: [
                                      _tableHeaderCell(
                                        'Product Name',
                                        width: 120,
                                      ),
                                      _tableHeaderCell(
                                        'Kawran Bazar',
                                        width: 80,
                                      ),
                                      _tableHeaderCell('DAM', width: 60),
                                      _tableHeaderCell('Shwapno', width: 80),
                                      _tableHeaderCell(
                                        'CNB Bazar, Bagerhat (W.P)',
                                        width: 120,
                                      ),
                                      _tableHeaderCell('MinMax', width: 60),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: priceList.length,
                                    itemBuilder: (context, index) {
                                      final item = priceList[index];
                                      return Container(
                                        color:
                                            index % 2 == 0
                                                ? Colors.white
                                                : Colors.grey[100],
                                        child: Row(
                                          children: [
                                            _tableBodyCell(
                                              item['ProductName'] ?? '',
                                              width: 120,
                                            ),
                                            _tableBodyCell(
                                              item['Kawran Bazar'] ?? '',
                                              width: 80,
                                            ),
                                            _tableBodyCell(
                                              item['DAM'] ?? '',
                                              width: 60,
                                            ),
                                            _tableBodyCell(
                                              item['Shwapno'] ?? '',
                                              width: 80,
                                            ),
                                            _tableBodyCell(
                                              item['CNB Bazar, Bagerhat  (W.P)'] ??
                                                  '',
                                              width: 120,
                                            ),
                                            _tableBodyCell(
                                              item['MinMax'] ?? '',
                                              width: 60,
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

DataRow _productRow(
  String name,
  String buy,
  String sell,
  String retail,
  String wholesale,
  String prev,
) {
  return DataRow(
    cells: [
      DataCell(Text(name, style: const TextStyle(fontSize: 12))),
      DataCell(Text(buy, style: const TextStyle(fontSize: 12))),
      DataCell(Text(sell, style: const TextStyle(fontSize: 12))),
      DataCell(Text(retail, style: const TextStyle(fontSize: 12))),
      DataCell(Text(wholesale, style: const TextStyle(fontSize: 12))),
      DataCell(Text(prev, style: const TextStyle(fontSize: 12))),
    ],
  );
}

class _FilterSection extends StatelessWidget {
  final HomeController controller;
  const _FilterSection(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          // First row: Date and District
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _FilterField(
                  label: 'Date',
                  child: Obx(
                    () => InkWell(
                      onTap: () => controller.pickDate(context),
                      borderRadius: BorderRadius.circular(10),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Text(
                              controller.formattedSelectedDate,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black87,
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _FilterField(
                  label: 'District',
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      value:
                          controller.selectedDistrictId.value.isNotEmpty
                              ? controller.selectedDistrictId.value
                              : null,
                      hint: const Text('Select'),
                      items:
                          controller.districtList.map<DropdownMenuItem<String>>(
                            (district) {
                              return DropdownMenuItem<String>(
                                value: district['DistrictCode'],
                                child: Text(
                                  district['DistrictName'],
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            },
                          ).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          controller.selectedDistrictId.value = newValue;
                          controller.fetchUpazilaMokam(newValue);
                        }
                      },
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Second row: Upazila and Mokam
          Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                controller.upazillasList.isEmpty
                    ? Container()
                    : Expanded(
                      child: _FilterField(
                        label: 'Upazila',
                        child: Obx(
                          () => DropdownButtonFormField<String>(
                            value:
                                controller.selectedUpazillasId.value.isNotEmpty
                                    ? controller.selectedUpazillasId.value
                                    : null,
                            hint: const Text('Select'),
                            isExpanded: true,
                            items:
                                controller.upazillasList
                                    .map<DropdownMenuItem<String>>((district) {
                                      print(controller.upazillasList.length);
                                      return DropdownMenuItem<String>(
                                        value: district['UpazillaCode'],
                                        child: Text(
                                          district['UpazillaName'],
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      );
                                    })
                                    .toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                controller.selectedUpazillasId.value = newValue;
                                controller.fetchPriceReport();
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                const SizedBox(width: 16),
                controller.mokamsList.isEmpty
                    ? Container()
                    : Expanded(
                      child: _FilterField(
                        label: 'Mokam',
                        child: Obx(
                          () => DropdownButtonFormField<String>(
                            value:
                                controller.selectedMokamsId.value.isNotEmpty
                                    ? controller.selectedMokamsId.value
                                    : null,
                            hint: const Text('Select'),
                            isExpanded: true,
                            items:
                                controller.mokamsList
                                    .map<DropdownMenuItem<String>>((district) {
                                      return DropdownMenuItem<String>(
                                        value: district['MokamId'],
                                        child: Text(
                                          district['MokamName'],
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                      );
                                    })
                                    .toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                controller.selectedMokamsId.value = newValue;
                                controller.fetchPriceReport();
                              }
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _FilterField extends StatelessWidget {
  final String label;
  final Widget child;
  const _FilterField({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 4),
          child,
        ],
      ),
    );
  }
}

Future<void> logout() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.clear(); // or remove only 'user' and 'token' if needed
  Get.offAllNamed('/sign-in'); // or use Routes.SIGN_IN if imported
}

Widget _tableHeaderCell(String text, {double width = 100}) {
  return Container(
    width: width,
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      overflow: TextOverflow.ellipsis,
    ),
  );
}

Widget _tableBodyCell(String text, {double width = 100}) {
  return Container(
    width: width,
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: const TextStyle(fontSize: 11, color: Colors.black87),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    ),
  );
}
