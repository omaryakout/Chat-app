import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import '../../models/message.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  final authanticatedUser = FirebaseAuth.instance.currentUser;
  CollectionReference messages = FirebaseFirestore.instance.collection('chat');
  final user = FirebaseAuth.instance.currentUser!;

  void sendMessage(String message, String email) async {
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .get();
    try {
      messages.add({
        'chat': message,
        'time': Timestamp.now(),
        'uid': user.uid,
        'user name': userData.data()!['user name'],
        'user image': userData.data()!['url']
      });
    } on Exception catch (e) {
      // TODO
    }
  }

  void getMessage() {
    messages.orderBy('time', descending: true).snapshots().listen((event) {
      List<Map<String, dynamic>> loadedMessages = [];
      for (var doc in event.docs) {
        loadedMessages.add({'chat':doc['chat'],
      'uid':doc['uid'],
      'time':doc['time'],
      'user name':doc['user name'],
      'user image':doc['user image'],});
        print('sucess');
      }
      emit(ChatSucess(loadedMessages: loadedMessages));
    });
  }
}
