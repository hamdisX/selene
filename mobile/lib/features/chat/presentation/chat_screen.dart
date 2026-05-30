import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String roomId;
  const ChatScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      // Placeholder — Sprint Chat remplacera par la messagerie temps réel (Socket.io)
      body: Center(child: Text('Room $roomId — Sprint Chat')),
    );
  }
}
