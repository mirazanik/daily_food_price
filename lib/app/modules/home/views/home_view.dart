import 'package:daily_food_price/constants/custom_image_view.dart';
import 'package:daily_food_price/constants/size_utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

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
          leading: IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {},
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Text(
                  controller.userName.value,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              Obx(
                () => Text(
                  controller.userPhone.value,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_active, color: Colors.white),
              onPressed: () {},
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
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'All Product',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    TextButton(onPressed: () {}, child: const Text('See All')),
                  ],
                ),
                const SizedBox(height: 8),
                Obx(() {
                  final priceList = controller.priceReportList;
                  if (priceList.isEmpty) {
                    return const Center(child: Text('No data found'));
                  }
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(
                        const Color(0xFF26A69A),
                      ),
                      headingTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      columns: [
                        DataColumn(label: Text('Product Name')),
                        DataColumn(label: Text('Kawran Bazar')),
                        DataColumn(label: Text('DAM')),
                        DataColumn(label: Text('Shwapno')),
                        DataColumn(label: Text('CNB Bazar, Bagerhat (W.P)')),
                        DataColumn(label: Text('MinMax')),
                      ],
                      rows:
                          priceList.map<DataRow>((item) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    item['ProductName'] ?? '',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    item['Kawran Bazar'] ?? '',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    item['DAM'] ?? '',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    item['Shwapno'] ?? '',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    item['CNB Bazar, Bagerhat  (W.P)'] ?? '',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    item['MinMax'] ?? '',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                    ),
                  );
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _FilterField(
                  label: 'Upazila',
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      value:
                          controller.selectedUpazillasId.value.isNotEmpty
                              ? controller.selectedUpazillasId.value
                              : null,
                      hint: const Text('Select'),
                      items:
                          controller.upazillasList
                              .map<DropdownMenuItem<String>>((district) {
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
              Expanded(
                child: _FilterField(
                  label: 'Mokam',
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      value:
                          controller.selectedMokamsId.value.isNotEmpty
                              ? controller.selectedMokamsId.value
                              : null,
                      hint: const Text('Select'),
                      items:
                          controller.mokamsList.map<DropdownMenuItem<String>>((
                            district,
                          ) {
                            return DropdownMenuItem<String>(
                              value: district['MokamId'],
                              child: Text(
                                district['MokamName'],
                                style: const TextStyle(fontSize: 12),
                              ),
                            );
                          }).toList(),
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
          ),
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
