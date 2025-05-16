import 'package:get/route_manager.dart';
import 'package:help_on_maps/modules/auth/views/login_page.dart';
import 'package:help_on_maps/modules/auth/views/register_page.dart';
import 'package:help_on_maps/modules/home/bindings/home_binding.dart';
import 'package:help_on_maps/modules/home/views/home_page.dart';
import 'package:help_on_maps/modules/profile/views/profile_page.dart';
import 'package:help_on_maps/routes/app_pages.dart';

class AppRoutes {
  static final routes = [
    GetPage(name: AppPages.homePage, page: () => HomePage(), binding: HomeBinding()),
    GetPage(name: AppPages.registerPage, page: () => RegisterPage()),
    GetPage(name: AppPages.loginPage, page: () => LoginPage()),
    GetPage(name: AppPages.profilePage, page: () => ProfilePage())
  ];
}