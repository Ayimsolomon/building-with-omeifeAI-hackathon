import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class TranslationController extends GetxController {
  var translatedText = "".obs;
  var messages = <Map<String, String>>[].obs;
  var conversations = <Map<String, dynamic>>[].obs;
  var isDarkMode = false.obs;
  final storage = GetStorage();
  final RxBool isTranslating = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadConversations();
    loadDarkMode();
  }

  void loadConversations() {
    List<dynamic>? storedConversations = storage.read<List>('conversations');
    if (storedConversations != null) {
      conversations.value = storedConversations.cast<Map<String, dynamic>>();
    }
  }

  void saveConversations() {
    storage.write(
      'conversations',
      conversations.toList(),
    ); // Ensure it's a list
  }

  void startNewConversation() {
    if (messages.isNotEmpty) {
      conversations.add({
        'title': messages.first['original'] ?? 'New Conversation',
        'messages': List.from(messages),
      });
      saveConversations();
    }
    messages.clear(); // Clear messages for new conversation
  }

  void loadDarkMode() {
    isDarkMode.value = storage.read('darkMode') ?? false;
  }

  void toggleDarkMode() {
    isDarkMode.value = !isDarkMode.value;
    storage.write('darkMode', isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  /// Translate Text via API
  Future<void> translate(String text) async {
    if (text.isEmpty) {
      Get.snackbar('Error', 'Please enter text to translate');
      return;
    }

    messages.add({'original': text});
    isTranslating.value = true; // Set isTranslating to true

    try {
      final response = await http.post(
        Uri.parse(
          'https://nacpoxygen.com/brake/bank/apis/api/omeife-knowledge/732',
        ),
        headers: {
          'Content-Type': 'application/vnd.api+json',
          'Accept': 'application/vnd.api+json',
        },
        body: jsonEncode({'text': text, 'from': 'english', 'to': 'hausa'}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('data') &&
            data['data'].containsKey('translated_text')) {
          translatedText.value = data['data']['translated_text'];
          messages.add({'translated': translatedText.value});
        } else {
          Get.snackbar('Error', 'Invalid response format from API');
        }
      } else {
        Get.snackbar(
          'Error',
          'Translation failed. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: $e');
    } finally {
      isTranslating.value =
          false; // Set isTranslating to false regardless of result
      saveConversations(); // Save conversations after translation is done.
    }
  }
}
