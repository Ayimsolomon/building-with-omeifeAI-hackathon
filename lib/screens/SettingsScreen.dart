import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/translation_controller.dart';

class SettingsScreen extends StatelessWidget {
  final TranslationController translationController = Get.find();

  SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap: () {},
          ),
          Obx(
            () => SwitchListTile(
              title: Text('Dark Mode'),
              value: translationController.isDarkMode.value,
              onChanged: (value) => translationController.toggleDarkMode(),
            ),
          ),
        ],
      ),
    );
  }
}
