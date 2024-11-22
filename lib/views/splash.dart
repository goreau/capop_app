import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:capop_new/controllers/splash.controller.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: SplashController(),
      builder: (_) => Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset(
            'assets/images/splash.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
