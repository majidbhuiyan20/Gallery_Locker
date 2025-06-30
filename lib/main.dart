import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gallery_locker/app/views/home_view.dart';
import 'app/binding/home_binding.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(  // 🔑 Use GetMaterialApp instead of MaterialApp
      debugShowCheckedModeBanner: false,
      title: 'Gallery Locker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/home',
      getPages: [
        GetPage(
          name: '/home',
          page: () => HomeView(),
          binding: HomeBinding(),
        ),
      ],
    );
  }
}
