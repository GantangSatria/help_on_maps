import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_on_maps/modules/home/controllers/home_controller.dart';
import 'package:help_on_maps/modules/chat/views/chat_page.dart';
import 'package:help_on_maps/modules/help_request/views/help_request_page.dart';
import 'package:help_on_maps/modules/map/views/map_page.dart';

class HomePage extends GetView<HomeController> {
  // const HomePage({super.key});
  
  final pages = [
    MapPage(),
    HelpRequestPage(),
    ChatPage()
  ];
  
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      body: pages[controller.selectedIndex.value],
      bottomNavigationBar: BottomNavigationBar(
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