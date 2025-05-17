import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:help_on_maps/modules/help_request/controllers/help_request_controller.dart';

class CreateHelpRequestPage extends StatelessWidget {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final HelpRequestController controller = Get.put(HelpRequestController());

  CreateHelpRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Help Request')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 24),
            Obx(() => controller.isLoading.value
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      await controller.createHelpRequest(
                        title: _titleController.text,
                        description: _descriptionController.text,
                      );
                      Get.back(); 
                    },
                    child: Text('Post Help Request'),
                  )),
          ],
        ),
      ),
    );
  }
}