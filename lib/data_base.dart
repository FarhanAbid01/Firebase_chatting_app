import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DataBase{
  getUser(String username) async {
     return await FirebaseFirestore.instance.collection('users')
       .where('name', isEqualTo: username )
        .get();

  }
  getUserByEmail(String userEmail) async {
    return await FirebaseFirestore.instance.collection('users')
        .where('email', isEqualTo: userEmail)
        .get();
  }
  uploadUserInfo(userMap){
    FirebaseFirestore.instance.collection('users')
        .add(userMap);
  }
  createChatRoom(String chatRoomId, chatRoomMap){
    FirebaseFirestore.instance.collection('ChatRoom')
        .doc(chatRoomId).set(chatRoomMap).catchError((e){
      Fluttertoast.showToast(msg: e!.message);
    });
  }

  addConversationMessage(String chatRoomId, messageMap){
    FirebaseFirestore.instance.collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .add(messageMap).catchError((e){print(e.toString());});
  }
  getConversationMessage(String chatRoomId){
    FirebaseFirestore.instance.collection('ChatRoom')
        .doc(chatRoomId)
        .collection('chats')
        .snapshots();
  }

getChatRoom(String userName){
    return FirebaseFirestore.instance.collection('ChatRoom')
        .where('users', arrayContains: userName).snapshots();
}

}