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
            children:  [
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
                const SizedBox(height: 12),
                TextField(
                  decoration: InputDecoration(
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
                const SizedBox(height: 12),
                Row(
                  children: [
                    _FilterChip(
                      label: 'Date',
                      value: '10/17/2023',
                      icon: Icons.calendar_today,
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(label: 'District', value: 'Bagherhat'),
                    const SizedBox(width: 8),
                    _FilterChip(label: 'Upazila', value: 'Select'),
                    const SizedBox(width: 8),
                    _FilterChip(label: 'Mokam', value: 'Select'),
                  ],
                ),
                const SizedBox(height: 12),
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

class _FilterChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  const _FilterChip({required this.label, required this.value, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: Colors.grey[700]),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
