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
                // const SizedBox(height: 8),

                // TextField(
                //   decoration: InputDecoration(
                //     contentPadding: EdgeInsets.symmetric(
                //       horizontal: 8,
                //       vertical: 8,
                //     ),
                //
                //     hintText: 'Search',
                //     prefixIcon: const Icon(Icons.search),
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(30),
                //       borderSide: BorderSide.none,
                //     ),
                //     filled: true,
                //     fillColor: Colors.grey[200],
                //   ),
                // ),
                _FilterSection(controller),

                const SizedBox(height: 8),
                Obx(() {
                  if (controller.selectedUpazillasId.value.isNotEmpty ||
                      controller.selectedMokamsId.value.isNotEmpty) {
                    if (controller.isLoading.value) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF26A69A),
                            ),
                          ),
                        ),
                      );
                    }

                    final priceList = controller.priceReportList;
                    if (priceList.isEmpty) {
                      return const Center(child: Text('No data found'));
                    }
                    return SizedBox(
                      height: 450,
                      child: Scrollbar(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: 730,
                            child: Column(
                              children: [
                                Container(
                                  color: const Color(0xFF26A69A),
                                  child: Row(
                                    children: [
                                      _tableHeaderCell(
                                        'Product Name',
                                        flex: 1,
                                        width: 150,
                                      ),
                                      ...priceList.isNotEmpty
                                          ? priceList[0]['marketNames']
                                              .map(
                                                (market) => _tableHeaderCell(
                                                  market,
                                                  flex: 1,
                                                  width: 100,
                                                ),
                                              )
                                              .toList()
                                          : [],
                                      _tableHeaderCell('MinMax'),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
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
                                              flex: 1,
                                              width: 150,
                                            ),
                                            ...item['marketNames'].map(
                                              (market) => _tableBodyCell(
                                                item[market] ?? 'N/A',
                                              ),
                                            ),
                                            _tableBodyCell(
                                              item['MinMax'] ?? '',
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
                      padding: const EdgeInsets.all(0),
                      dropdownColor: Colors.white.withOpacity(0.6),
                      isExpanded: true,
                      icon: const Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey,
                      ),
                      iconSize: 24,
                      elevation: 0,
                      // This is the key addition - it controls how the selected value appears in the button
                      selectedItemBuilder: (BuildContext context) {
                        return controller.districtList.map<Widget>((district) {
                          // This widget is what shows in the button when an item is selected
                          return Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              district['DistrictName'],
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList();
                      },
                      items:
                          controller.districtList.map<DropdownMenuItem<String>>(
                            (district) {
                              final isSubmitted = district['Submitted'] == 'Y';
                              return DropdownMenuItem<String>(
                                value: district['DistrictCode'],
                                child: Container(
                                  color:
                                      isSubmitted ? Colors.white : Colors.grey,
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  margin: EdgeInsets.zero,
                                  child: Text(
                                    district['DistrictName'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                    ),
                                  ),
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

Widget _tableHeaderCell(String text, {int flex = 1, double width = 100}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
    width: width,
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
  );
}

Widget _tableBodyCell(String text, {int flex = 1, double width = 100}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
    width: width,
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: const TextStyle(fontSize: 11, color: Colors.black87),
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
    ),
  );
}
