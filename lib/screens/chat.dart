import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:omar_chat_app/widgets/new_message.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omar_chat_app/widgets/chat_input.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/chat_cubit.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setupNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    await fcm.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();
    setupNotifications();
    BlocProvider.of<ChatCubit>(context).getMessage();
  }

  void _logOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
          appBar: AppBar(
            title: Text('CHAT SCREEN'),
            actions: [IconButton(onPressed: _logOut, icon: Icon(Icons.logout))],
          ),
          body: Column(
            children: [
              ChatInput(),
              const NewMessage(),
            ],
          ));
    
  }
}
