part of 'chat_cubit.dart';

@immutable
class ChatState {}

class ChatInitial extends ChatState {}

class ChatSucess extends ChatState {
  List<Map<String,dynamic>> loadedMessages;
  ChatSucess({required this.loadedMessages});
}

class ChatFailure extends ChatState {}
