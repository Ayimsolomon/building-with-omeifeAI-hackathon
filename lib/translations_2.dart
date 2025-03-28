import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

class TranslationController extends GetxController {
  var translatedText = "".obs;
  var messages = <Map<String, String>>[].obs;
  var conversations = <Map<String, dynamic>>[].obs;
  var isDarkMode = false.obs;
  final storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = storage.read('darkMode') ?? false;
  }

  void toggleDarkMode() {
    isDarkMode.value = !isDarkMode.value;
    storage.write('darkMode', isDarkMode.value);
  }

  void startNewConversation() {
    if (messages.isNotEmpty) {
      conversations.add({
        'title': messages.first['original'] ?? 'New Conversation',
        'messages': List.from(messages),
      });
      messages.clear();
    }
  }

  /// Translate Text via API
  Future<void> translate(String text) async {
    if (text.isEmpty) {
      Get.snackbar('Error', 'Please enter text to translate');
      return;
    }

    messages.add({'original': text});

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
        if (data.containsKey('translated_text')) {
          translatedText.value = data['translated_text'];
          messages.add({'translated': translatedText.value});
        } else {
          Get.snackbar('Error', 'Invalid response format from API');
        }
      } else {
        Get.snackbar(
          'Error',
          'Translation failed. Status: \${response.statusCode}',
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Network error: \$e');
    }
  }
}
