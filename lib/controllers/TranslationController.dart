// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';

// class TranslationController extends GetxController {
//   var messages = <Map<String, String>>[].obs;
//   var conversations = <Map<String, dynamic>>[].obs;
//   final storage = GetStorage();
//   var isDarkMode = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     isDarkMode.value = storage.read('darkMode') ?? false;
//   }

//   void translate(String text) {
//     messages.add({'original': text});

//     // Simulate API response
//     Future.delayed(Duration(seconds: 1), () {
//       messages.add({'translated': "Hausa Translation of '$text'"});
//     });
//   }

//   void startNewConversation() {
//     if (messages.isNotEmpty) {
//       conversations.add({
//         'title': messages.first['original'],
//         'messages': List.from(messages),
//       });
//       messages.clear();
//     }
//   }

//   void toggleDarkMode() {
//     isDarkMode.value = !isDarkMode.value;
//     storage.write('darkMode', isDarkMode.value);
//   }
// }
