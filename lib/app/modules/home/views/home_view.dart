import 'package:daily_food_price/constants/custom_image_view.dart';
import 'package:daily_food_price/constants/app_theme.dart';
import 'package:daily_food_price/controllers/theme_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find();

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Text(
                  controller.userName.value,
                  textAlign: TextAlign.left,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
              Obx(
                () => Text(
                  textAlign: TextAlign.left,
                  controller.userPhone.value,
                  style: TextStyle(
                    color: Theme.of(context).appBarTheme.foregroundColor?.withOpacity(0.7),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          actions: [
            Obx(
              () => IconButton(
                icon: Icon(
                  themeController.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () {
                  themeController.toggleTheme();
                },
                tooltip: 'Toggle Theme',
              ),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                controller.logout();
              },
              tooltip: 'Logout',
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
                  if (true) {
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
                      return Center(
                        child: Text(
                          'No data found',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
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
                                  color: AppTheme.getTableHeaderColor(context),
                                  child: Row(
                                    children: [
                                      _tableHeaderCell(
                                        context,
                                        'Product Name',
                                        flex: 1,
                                        width: 150,
                                      ),
                                      ...priceList.isNotEmpty
                                          ? priceList[0]['marketNames']
                                              .map(
                                                (market) => _tableHeaderCell(
                                                  context,
                                                  market,
                                                  flex: 1,
                                                  width: 100,
                                                ),
                                              )
                                              .toList()
                                          : [],
                                      // _tableHeaderCell('MinMax'),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    itemCount: priceList.length,
                                    itemBuilder: (context, index) {
                                      final item = priceList[index];
                                      return Container(
                                        color: AppTheme.getTableRowColor(context, index),
                                        child: Row(
                                          children: [
                                            _tableBodyCell(
                                              context,
                                              item['ProductName'] ?? '',
                                              flex: 1,
                                              width: 150,
                                            ),
                                            ...item['marketNames'].map(
                                              (market) => _tableBodyCell(
                                                context,
                                                item[market] ?? 'N/A',
                                              ),
                                            ),
                                            /*_tableBodyCell(
                                              item['MinMax'] ?? '',
                                            ),*/
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
        color: AppTheme.getFilterBackgroundColor(context),
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
                          fillColor: AppTheme.getInputFillColor(context),
                        ),
                        child: Row(
                          children: [
                            Text(
                              controller.formattedSelectedDate,
                              style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).textTheme.bodyLarge?.color,
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
                      dropdownColor: AppTheme.getInputFillColor(context),
                      isExpanded: true,
                      icon: Icon(
                        Icons.arrow_drop_down,
                        color: Theme.of(context).iconTheme.color,
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
                              style: TextStyle(
                                fontSize: 14,
                                color: Theme.of(context).textTheme.bodyLarge?.color,
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
                                  color: AppTheme.getDropdownHighlightColor(context, isSubmitted),
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                  margin: EdgeInsets.zero,
                                  child: Text(
                                    district['DistrictName'],
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Theme.of(context).textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          controller.selectedDistrictId.value = newValue;
                          controller.fetchPriceReport();
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
                        fillColor: AppTheme.getInputFillColor(context),
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
                              fillColor: AppTheme.getInputFillColor(context),
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
                              fillColor: AppTheme.getInputFillColor(context),
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
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color,
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

Widget _tableHeaderCell(BuildContext context, String text, {int flex = 1, double width = 100}) {
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

Widget _tableBodyCell(BuildContext context, String text, {int flex = 1, double width = 100}) {
  return Container(
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
    width: width,
    alignment: Alignment.centerLeft,
    child: Text(
      text,
      style: TextStyle(
        fontSize: 11,
        color: Theme.of(context).textTheme.bodyLarge?.color,
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 3,
    ),
  );
}
