import 'package:gallery_locker/app/views/home_view.dart';
import 'package:get/get.dart';

import 'binding/home_binding.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: '/home',
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
  ];
}
