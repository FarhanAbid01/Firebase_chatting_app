

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data_base.dart';
import 'constants.dart';
import 'converstaion_screen.dart';
import 'login_screen.dart';

class Chat_Room extends StatefulWidget {
  const Chat_Room({Key? key}) : super(key: key);

  @override
  State<Chat_Room> createState() => _Chat_RoomState();
}

class _Chat_RoomState extends State<Chat_Room> {
  DataBase dataBaseMethods = new DataBase();
  late DocumentReference chatRoomsStream;

  Widget chatRoomsList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ChatRoom')
            .where('users', arrayContains: Constants.myname)
            .snapshots(),
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: (snapshot.data! as QuerySnapshot).docs.length,
                  itemBuilder: (context, index) {
                    return ChatRoomtile(
                        (snapshot.data! as QuerySnapshot)
                            .docs[index]['chatroomId']
                            .toString()
                            .replaceAll('_', '')
                            .replaceAll(Constants.myname, ''),
                        (snapshot.data! as QuerySnapshot).docs[index]
                            ['chatroomId']);
                  })
              : Container();
        });
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('ISLOGGEDIN', false);
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login_Screen()));
  }

  @override
  void initState() {
    getUserName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
        actions: [
          InkWell(
            onTap: () {
              logout();
            },
            child: Container(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app),
              ),
            ),
          )
        ],
      ),
      body: chatRoomsList(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, 'search');
          },
          child: Icon(Icons.search)),
    );
  }

  Future<void> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      // chatRoomsStream=  FirebaseFirestore.instance.collection('ChatRoom');

      Constants.myname = prefs.get("USERNAMEKEY").toString();
      setState(() {});
    } catch (e) {
      print("PREF = " + e.toString());
    }
  }
}

class ChatRoomtile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomtile(this.userName, this.chatRoomId);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Conversation_Screen(chatRoomId)));
        },
        child: Container(
          height: 60,
          width: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 70,
                width: 70,
                decoration:
                    BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                child: Text(
                  '${userName.substring(0, 1).toUpperCase()}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, height: 2.5),
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                userName,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
              )
            ],
          ),
        ),
      ),
    );
  }
}
