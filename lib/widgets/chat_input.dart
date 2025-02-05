import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:omar_chat_app/screens/cubit/chat_cubit.dart';
import 'package:omar_chat_app/widgets/message_bubble.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/message.dart';

class ChatInput extends StatelessWidget {
  ChatInput({super.key});
  final authanticatedUser = FirebaseAuth.instance.currentUser;
   List<Map<String,dynamic>> loadedMessages = [];
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is ChatSucess) {
           loadedMessages = state.loadedMessages;
        }
      },
      builder: (context, state) {
        return ListView.builder(
          padding: const EdgeInsets.only(
            bottom: 40,
            left: 13,
            right: 13,
          ),
          reverse: true,
          itemCount: loadedMessages.length,
          itemBuilder: (context, index) {
            final chatMessage = loadedMessages[index];
            final nextChatMessage = index + 1 < loadedMessages.length
                ? loadedMessages[index + 1]
                : null;
            final chatMessageUserId = chatMessage['uid'];
            final nextChatMessageUserId =
                nextChatMessage != null ? nextChatMessage['uid'] : null;
            final nextUserIsTheSame =
                chatMessageUserId == nextChatMessageUserId;

            if (nextUserIsTheSame) {
              return MessageBubble.next(
                message: chatMessage['chat'],
                isMe: authanticatedUser!.uid == chatMessageUserId,
              );
            } else {
              return MessageBubble.first(
                userImage: chatMessage['user image'],
                username: chatMessage['user name'],
                message: chatMessage['chat'],
                isMe: authanticatedUser!.uid == chatMessageUserId,
              );
            }
          },
        );
      },
    ));
  }
}
