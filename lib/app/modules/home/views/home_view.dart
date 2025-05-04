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
                SingleChildScrollView(
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
                    columns: const [
                      DataColumn(label: Text('Product Name')),
                      DataColumn(label: Text('ক্রয়মূল্য\n(Buy Price)')),
                      DataColumn(label: Text('বিক্রয়মূল্য\n(Sell Price)')),
                      DataColumn(label: Text('খুচরা\n(Retail)')),
                      DataColumn(label: Text('আড়ৎ- মোকাম\n(Wholesale)')),
                      DataColumn(label: Text('পূর্বের মূল্য\n(Prev. Price)')),
                    ],
                    rows: [
                      _productRow(
                        'আলু সাদা/White Potato',
                        '60',
                        '50',
                        '50',
                        '50-65',
                        '50',
                      ),
                      _productRow(
                        'পেঁপে/Green Papaya',
                        '40',
                        '30',
                        '30',
                        '30-40',
                        '30',
                      ),
                      _productRow(
                        'কুমড়া/ Bottle Gourd',
                        '60',
                        '50',
                        '50',
                        '50-65',
                        '50',
                      ),
                      _productRow(
                        'ছাগল মাংস/Goat meat',
                        '1100',
                        '1050',
                        '1050',
                        '950-1150',
                        '970',
                      ),
                      _productRow(
                        'মুরগি (দেশি)/Chicken (Deshi)',
                        '1100',
                        '1050',
                        '1050',
                        '950-1150',
                        '970',
                      ),
                    ],
                  ),
                ),
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
                              "${controller.selectedDate.value.month}/${controller.selectedDate.value.day}/${controller.selectedDate.value.year}",
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
