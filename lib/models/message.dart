class Message {
  
  Message({ required this.loadedPair});
  Map<String, dynamic> loadedPair;
  factory Message.fromJson(jsonData) {
    return Message(loadedPair: {
      'chat':jsonData['chat'],
      'uid':jsonData['uid'],
      'time':jsonData['time'],
      'user name':jsonData['user name'],
      'user image':jsonData['user image'],
    }
     );
  }
}
