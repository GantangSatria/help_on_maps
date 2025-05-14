import 'package:get/route_manager.dart';
import 'package:help_on_maps/modules/home/bindings/home_binding.dart';
import 'package:help_on_maps/modules/home/views/home_page.dart';
import 'package:help_on_maps/routes/app_pages.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: AppPages.homePage, page: () => HomePage(), binding: HomeBinding()),
  ];
}