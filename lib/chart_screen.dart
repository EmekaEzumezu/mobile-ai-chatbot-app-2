import 'dart:async';
import 'dart:ffi';

import 'package:ai_chatbot_1/chatmessage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:velocity_x/velocity_x.dart';

import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  // ChatGPT? chatGPT;
  late OpenAI? chatGPT;

  bool _isImageSearch = false;

  bool _isTyping = false;

  StreamSubscription? _subscription;

  @override
  void initState() {
    // chatGPT = OpenAI.instance.build(
    //     token: dotenv.env["API_KEY"],
    //     baseOption: HttpSetup(receiveTimeout: Duration(minutes: 1000)));
    super.initState();
  }

  @override
  void dispose() {
    // _subscription?.cancel();
    chatGPT?.close();
    chatGPT?.genImgClose();
    super.dispose();
  }

  // void _sendMessage() {
  //   ChatMessage message = ChatMessage(text: _controller.text, sender: "user");

  //   setState(() {
  //     _messages.insert(0, message);
  //   });

  //   _controller.clear();

  //   final request = CompleteText(
  //       prompt: message.text, model: kTextDavinci3, maxTokens: 200);

  //   _subscription = chatGPT!.builder("", orgid: "")
  //   .onCompleteStream(request: request)
  //   .listen((response) {});
  // }

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;
    ChatMessage message = ChatMessage(
      text: _controller.text,
      sender: "user",
      // isImage: false,
    );

    setState(() {
      _messages.insert(0, message);
      _isTyping = true;
    });

    _controller.clear();

  }

  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            onSubmitted: (value) => _sendMessage(),
            decoration: InputDecoration.collapsed(hintText: "Send a message"),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.send),
          onPressed: () => _sendMessage(),
        ),
      ],
    ).px16();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatGPT'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                reverse: true,
                padding: Vx.m8,
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return _messages[index];
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: context.cardColor,
              ),
              child: _buildTextComposer(),
            )
          ],
        ),
      ),
    );
  }
}
