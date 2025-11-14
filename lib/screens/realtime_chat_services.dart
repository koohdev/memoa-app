import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'chat_message.dart';

class RealtimeChatServices {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Generate a unique chat room ID for two users
  String getChatRoomId(String userId, String receiverId) {
    List<String> ids = [userId, receiverId];
    ids.sort(); // Sort the IDs to ensure the chat room ID is always the same
    return ids.join('_');
  }

  // Get messages for a specific chat room
  Stream<List<ChatMessage>> getMessages({required String userId, required String receiverId}) {
    final chatRoomId = getChatRoomId(userId, receiverId);
    return _database.child('chat_rooms').child(chatRoomId).child('messages').orderByChild('timestamp').onValue.map((event) {
      final List<ChatMessage> messages = [];
      if (event.snapshot.value != null) {
        final Map<dynamic, dynamic> data = event.snapshot.value as Map<dynamic, dynamic>;
        data.forEach((key, value) {
          messages.add(ChatMessage(
            id: key,
            senderId: value['senderId'],
            text: value['text'],
            timestamp: DateTime.fromMillisecondsSinceEpoch(value['timestamp']),
          ));
        });
      }
      return messages;
    });
  }

  // Send a message to a specific user
  Future<void> sendMessage({required String receiverId, required String message}) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    final chatRoomId = getChatRoomId(currentUser.uid, receiverId);
    final newMessageRef = _database.child('chat_rooms').child(chatRoomId).child('messages').push();

    await newMessageRef.set({
      'senderId': currentUser.uid,
      'text': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }
}
