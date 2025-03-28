import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:xtrandhand/screens/SettingsScreen.dart';
import '../controllers/translation_controller.dart';

class ChatScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final TranslationController translationController = Get.find();

  ChatScreen({super.key});

  void sendMessage() {
    String text = _controller.text.trim();
    if (text.isNotEmpty) {
      translationController.translate(text);
      _controller.clear();
    }
  }

  void startNewConversation() {
    translationController.startNewConversation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('English to Hausa Translation'),
        backgroundColor: Colors.deepPurpleAccent.withOpacity(0.7),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Theme.of(context).primaryColor,
              child: DrawerHeader(
                decoration: BoxDecoration(color: Colors.transparent),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage('assets/logo.png'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Xtrahand Translation App',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    leading: Icon(Icons.chat),
                    title: Text('New Conversation'),
                    onTap: startNewConversation,
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Settings'),
                    onTap: () => Get.to(() => SettingsScreen()),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.black, width: 4.0),
                ),
              ),
              padding: EdgeInsets.all(8.0),
              child: Text(
                'XtraHand AI 1.0',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(child: Container(color: Colors.white)),
          Positioned.fill(child: Image.asset('assets/intro.jpg')),
          Column(
            children: [
              Expanded(
                child: Obx(
                  () => ListView.builder(
                    itemCount: translationController.messages.length,
                    itemBuilder: (context, index) {
                      var message = translationController.messages[index];
                      bool isMe = message.containsKey('original');
                      return ResponseWidget(
                        text: message.values.first,
                        isMe: isMe,
                        isTranslating:
                            translationController.isTranslating.value &&
                            !isMe &&
                            index == translationController.messages.length - 1,
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'Ask XtraHand...',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.9),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                    IconButton(icon: Icon(Icons.send), onPressed: sendMessage),
                  ],
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        ],
      ),
    );
  }
}

class ResponseWidget extends StatelessWidget {
  final String text;
  final bool isMe;
  final bool isTranslating;

  const ResponseWidget({
    required this.text,
    required this.isMe,
    super.key,
    this.isTranslating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (!isMe)
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: CircleAvatar(
                child:
                    isTranslating
                        ? Text('...')
                        : Image.asset('assets/logo.png'),
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(5.0),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                  ),
                  child: Text(
                    isTranslating ? 'Tunane...' : text,
                    style: TextStyle(fontSize: 18),
                  ),
                  decoration: BoxDecoration(
                    color:
                        isMe
                            ? Colors.white.withOpacity(0.8)
                            : Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft: isMe ? Radius.circular(10) : Radius.zero,
                      bottomRight: isMe ? Radius.zero : Radius.circular(10),
                    ),
                  ),
                ),
                if (!isMe)
                  IconButton(
                    icon: Icon(Icons.copy, size: 18),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Copied to clipboard')),
                      );
                    },
                  ),
              ],
            ),
          ),
          if (isMe) CircleAvatar(child: Text('Me')),
        ],
      ),
    );
  }
}
