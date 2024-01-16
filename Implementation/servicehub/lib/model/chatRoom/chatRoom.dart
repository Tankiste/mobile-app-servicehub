import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:servicehub/controller/widgets.dart';
import 'package:servicehub/model/app_state.dart';
import 'package:servicehub/model/auth/auth_service.dart';
import 'package:servicehub/model/auth/user_data.dart';
import 'package:servicehub/model/services/services.dart';

class ChatRoom {
  String chatId;
  String clientId;
  String sellerId;
  List<String>? messages;

  ChatRoom({
    required this.chatId,
    required this.clientId,
    required this.sellerId,
  });

  Map<String, dynamic> toMapMessage() {
    return {
      'chat id': chatId,
      'client id': clientId,
      'seller id': sellerId,
      'messages': messages,
    };
  }
}

class Chats {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  ApplicationState appState = ApplicationState();
  Services serviceData = Services();
  AuthService authService = AuthService();
  bool hasNewMessage = false;
  Message? newMessage;

  // void updateNewMessage(Map<String, dynamic> messageMap) {
  //   hasNewMessage = true;
  //   newMessage = _createMessageFromMap(messageMap);
  // }

  // void resetNewMessage() {
  //   hasNewMessage = false;
  //   newMessage = null;
  // }

  Message _createMessageFromMap(Map<String, dynamic> messageMap) {
    return Message(
      text: messageMap['message'],
      date: (messageMap['time'] as Timestamp).toDate(),
      isSentByMe: _auth.currentUser!.uid == messageMap['sender id'],
    );
  }

  Future<void> createOrUpdateChat(
      String clientId, String sellerId, String message) async {
    bool isSeller = await authService.getCurrentUserStatus();
    final chatId = _generateChatId(clientId, sellerId);

    final existingChat = await _firestore.collection('chats').doc(chatId).get();

    if (existingChat.exists) {
      await _firestore.collection('chats').doc(chatId).update({
        'messages':
            FieldValue.arrayUnion([_createMessage(clientId, sellerId, message)])
      });
      // updateNewMessage(
      //   _createMessage(clientId, sellerId, message),
      // );
    } else {
      final sharedChat = await _firestore
          .collection('chats')
          .where('client id', isEqualTo: isSeller ? sellerId : clientId)
          .where('seller id', isEqualTo: isSeller ? clientId : sellerId)
          .get();

      if (sharedChat.docs.isNotEmpty) {
        await _firestore
            .collection('chats')
            .doc(sharedChat.docs.first.id)
            .update({
          'messages': FieldValue.arrayUnion(
              [_createMessage(clientId, sellerId, message)])
        });
      } else {
        await _firestore.collection('chats').doc(chatId).set({
          'chat id': chatId,
          'client id': isSeller ? sellerId : clientId,
          'seller id': isSeller ? clientId : sellerId,
          'messages': [_createMessage(clientId, sellerId, message)]
        });
        // updateNewMessage(_createMessage(clientId, sellerId, message));
      }
    }
  }

  String _generateChatId(String clientId, String sellerId) {
    return '$clientId-$sellerId';
  }

  Map<String, dynamic> _createMessage(
      String senderId, String receiverId, String message) {
    // final serverTimestamp = FieldValue.serverTimestamp();

    return {
      'sender id': senderId,
      'receiver id': receiverId,
      'time': Timestamp.now(),
      'message': message,
    };
  }

  Future<List<Message>> getChatMessages(
      String senderId, String receiverId) async {
    bool isSeller = await authService.getCurrentUserStatus();
    try {
      // String chatId = _generateChatId(senderId, receiverId);
      CollectionReference chatCollection = _firestore.collection('chats');
      QuerySnapshot chatSnapshot = await chatCollection
          .where('client id', isEqualTo: isSeller ? receiverId : senderId)
          .where('seller id', isEqualTo: isSeller ? senderId : receiverId)
          .get();

      if (chatSnapshot.docs.isNotEmpty) {
        DocumentSnapshot chatDoc = chatSnapshot.docs.first;
        List<Message> messages = [];
        List<dynamic>? messageData = chatDoc['messages'];

        if (messageData != null) {
          for (var messageMap in messageData) {
            Message message = Message(
              isSentByMe: _auth.currentUser!.uid == messageMap['sender id']
                  ? true
                  : false,
              text: messageMap['message'],
              date: (messageMap['time'] as Timestamp).toDate(),
            );
            messages.add(message);
          }
        }

        return messages;
      } else {
        return [];
      }
    } catch (error) {
      print("Erreur lors de la récupération des messages : $error");
      throw error;
    }
  }

  Future<List<Message>> getLatestMessage(String chatId) async {
    try {
      DocumentSnapshot chatDoc =
          await _firestore.collection('chats').doc(chatId).get();

      if (chatDoc.exists) {
        List<dynamic>? messageData = chatDoc['messages'];

        if (messageData != null && messageData.isNotEmpty) {
          messageData.sort((a, b) =>
              (b['time'] as Timestamp).compareTo((a['time'] as Timestamp)));

          Message latestMessage = Message(
            isSentByMe: _auth.currentUser!.uid == messageData[0]['sender id'],
            text: messageData[0]['message'],
            date: (messageData[0]['time'] as Timestamp).toDate(),
          );

          return [latestMessage];
        }
      }

      return [];
    } catch (error) {
      print("Erreur lors de la récupération du dernier message : $error");
      throw error;
    }
  }

  // Future<List<Message>> getNewMessages(
  //     String senderId, String receiverId) async {
  //   bool isSeller = await authService.getCurrentUserStatus();
  //   CollectionReference chatCollection = _firestore.collection('chats');
  //   QuerySnapshot chatSnapshot = await chatCollection
  //       .where('client id', isEqualTo: isSeller ? receiverId : senderId)
  //       .where('seller id', isEqualTo: isSeller ? senderId : receiverId)
  //       .get();

  //   if (chatSnapshot.docs.isNotEmpty) {
  //     DocumentSnapshot chatDoc = chatSnapshot.docs.first;
  //     List<Message> newMessages = [];
  //     List<dynamic>? messageData = chatDoc['messages'];

  //     if (messageData != null) {
  //       // Filter only new messages
  //       for (var messageMap in messageData) {
  //         DateTime messageDate = (messageMap['time'] as Timestamp).toDate();
  //         if (messageDate
  //             .isAfter(DateTime.now().subtract(Duration(seconds: 5)))) {
  //           // Adjust the time condition as needed
  //           Message message = Message(
  //             isSentByMe: _auth.currentUser!.uid == messageMap['sender id'],
  //             text: messageMap['message'],
  //             date: messageDate,
  //           );
  //           newMessages.add(message);
  //         }
  //       }
  //     }

  //     return newMessages;
  //   } else {
  //     return [];
  //   }
  // }

  Future<List<DocumentSnapshot>> getSellerChats() async {
    auth.User currentUser = _auth.currentUser!;
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('chats')
          .where('seller id', isEqualTo: currentUser.uid)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs;
      } else {
        return [];
      }
    } catch (err) {
      print("Error while retrieving chats: $err");
      throw (err);
    }
  }

  Future<List<DocumentSnapshot>> getClientChats() async {
    auth.User currentUser = _auth.currentUser!;
    QuerySnapshot querySnapshot = await _firestore
        .collection('chats')
        .where('client id', isEqualTo: currentUser.uid)
        .get();

    return querySnapshot.docs;
  }
}
