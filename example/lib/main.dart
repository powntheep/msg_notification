import 'package:flutter/material.dart';
import 'package:msg_notification/msg_notification.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            const Center(
              child: Text('Running on:'),
            ),
            IconButton(
                onPressed: () {
                  MsgNotificationPlatform.instance.createNewMessageNotification(
                      avatarUrl: 'https://via.placeholder.com/150',
                      displayName: 'test',
                      sender: 'test sender',
                      conversationId: '0',
                      message: 'test message',
                      largeImage:
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b6/Image_created_with_a_mobile_phone.png/1200px-Image_created_with_a_mobile_phone.png',
                      data: '');
                },
                icon: const Icon(Icons.add)),
          ],
        ),
      ),
    );
  }
}
