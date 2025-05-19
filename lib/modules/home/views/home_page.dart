import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_on_maps/modules/home/controllers/home_controller.dart';
import 'package:help_on_maps/modules/chat/views/chat_page.dart';
import 'package:help_on_maps/modules/help_request/views/help_request_page.dart';
import 'package:help_on_maps/modules/map/views/map_page.dart';
import 'package:help_on_maps/routes/app_pages.dart';

class HomePage extends GetView<HomeController> {
  HomePage({super.key});
  
  final pages = [
    MapPage(),
    HelpRequestPage(),
    ChatPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(
          double.infinity, 60 
        ),
        child: AppBar(
          title: Text('Help Map'),
          backgroundColor: Colors.teal.shade100,
          actions: [
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () => Get.toNamed(AppPages.profilePage),
            ),
          ],
        ),
      ),
      body: pages[controller.selectedIndex.value],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.teal.shade100,
        currentIndex: controller.selectedIndex.value,
        onTap: controller.changeTab,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ],
      ),
    ));
  }
}