import 'package:daily_food_price/constants/custom_image_view.dart';
import 'package:daily_food_price/constants/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';



class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> with SingleTickerProviderStateMixin {


  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      Get.offAllNamed(Routes.SIGN_IN);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF26A69A),
      body: CustomImageView(
        alignment: Alignment.center,
        imagePath: "assets/images/logo.png",
        height: getVerticalSize(250),
        width: getVerticalSize(250),
        fit: BoxFit.fill,
      ),
    );
  }
} 