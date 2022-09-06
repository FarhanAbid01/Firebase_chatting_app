
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../data_base.dart';
import 'constants.dart';
class Conversation_Screen extends StatefulWidget {
  final String chatRoomId;
   Conversation_Screen(this.chatRoomId);

  @override
  State<Conversation_Screen> createState() => _Conversation_ScreenState();
}

class _Conversation_ScreenState extends State<Conversation_Screen> {

 DataBase databaseMethods=DataBase();
 TextEditingController messagecontroller= TextEditingController();

 late DocumentReference chatMessageStream;
 var check= false;



 Widget ChatMessageList(){
   return StreamBuilder<QuerySnapshot>(
    stream: chatMessageStream.collection('chats').orderBy('time', descending: false).snapshots(),
     builder: (context, snapshot) {
       return snapshot.hasData ?ListView.builder(
           itemCount: (snapshot.data!).docs.length,

       itemBuilder:(context,index){
             return MessageTile((snapshot.data!).docs[index]['message'],
                 (snapshot.data!).docs[index]['sendby']== Constants.myname);
             }): Container();


     },
   
   );
 }



  sendMessage() {
    if (messagecontroller.text.isNotEmpty) {
      Map<String, dynamic> messageMap = {
        'message': messagecontroller.text,
        'sendby': Constants.myname,
        'time' : DateTime.now().millisecondsSinceEpoch
      };


    databaseMethods.addConversationMessage(widget.chatRoomId, messageMap);
      setState(() {
        messagecontroller.text = "";
      });
  }
  }
  @override
  void initState() {
    chatMessageStream = FirebaseFirestore.instance.collection('ChatRoom')
        .doc(widget.chatRoomId);

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conervsation'),
      ),
      body: Container(
        child: Stack(
          children: [
            ChatMessageList(),
            Container(
            alignment: Alignment.bottomCenter,

            child: Container(
              color: Colors.black26,
              padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 15
              ),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: messagecontroller,
                        decoration: const InputDecoration(
                          hintText: 'Message...',
                          border: InputBorder.none,
                        ),
                      )),
                  InkWell(
                    onTap: (){
                      sendMessage();
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(
                                colors: [
                                  Colors.black45,
                                  Colors.black26,
                                ]
                            ),
                            borderRadius: BorderRadius.circular(40)
                        ),
                        child: Image.asset('assets/send.png',color: Colors.black,)),
                  ),

                ],
              ),
            ),
          ),

          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByMe? 0: 24, right: isSendByMe? 24:0),
      margin: const EdgeInsets.symmetric(vertical: 8),
          width: MediaQuery.of(context).size.width,
          alignment: isSendByMe? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              gradient: LinearGradient(
                colors: isSendByMe? [
                  Colors.blue,
                  Colors.blue
                ] : [
                  Colors.black,
                  Colors.black

                ]
              )
            ),
            child: Text(message, style:  const TextStyle(
              color: Colors.white,
              fontSize: 17
            ),),
          ),
    );
  }
}
