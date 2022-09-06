

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../data_base.dart';
import 'constants.dart';
import 'converstaion_screen.dart';
class Search_Screen extends StatefulWidget {
  const Search_Screen({Key? key}) : super(key: key);

  @override
  State<Search_Screen> createState() => _Search_ScreenState();
}

class _Search_ScreenState extends State<Search_Screen> {
  DataBase databaseMethods= DataBase();
  TextEditingController seachcontroller= TextEditingController();

  late QuerySnapshot searchSnapshot;
  var check=false;
  initiateSearch(){
    databaseMethods.getUser(seachcontroller.text).then((value){
     setState(() {
       searchSnapshot= value;
       check = true;
       print(searchSnapshot.docs);
     });
    });
  }
  createChatroomAndStartCoversation(String userName){
   if(userName != Constants.myname){
     print(userName+" and me  "+Constants.myname);
     String chatRoomId= getChatRoomId(userName, Constants.myname);
     List<String> users=[userName, Constants.myname ];
     Map<String , dynamic> chatRoomMap={
       'users' : users,
       'chatroomId' : chatRoomId

     };

     // FirebaseFirestore.instance.collection("ChatRoom").doc("1111111").set(chatRoomMap).then((value) => {
     // Navigator.push(context, MaterialPageRoute(builder: (context)=> Conversation_Screen(chatRoomId)))
     // }

     FirebaseFirestore.instance.collection('ChatRoom')
         .doc(chatRoomId).set(chatRoomMap)
         .then((value)
         {
           Navigator.push(context, MaterialPageRoute(builder: (context)=> Conversation_Screen(chatRoomId)));
         }
     ).catchError((e) {
       setState(() {
         Fluttertoast.showToast(msg: e!.message);
       });
     });
   }else
     print('you cannot send message to yourself');
 }
 Widget SearchTile({
   required String userName,
   required String userEmail
 }){
    return Padding(
     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
     child: Container(
       child: Row(
         children: [
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(userName, style: TextStyle(
                   fontSize: 16
               ),),
               Text(userEmail, style: TextStyle(
                   fontSize: 16
               ),),
             ],
           ),
           Spacer(),
           GestureDetector(
             onTap: (){
               createChatroomAndStartCoversation(userName);
               },
             child: Container(
               decoration: BoxDecoration(
                   color: Colors.blue,
                   borderRadius: BorderRadius.circular(30)
               ),
               child: Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                 child: Text('Message',style: TextStyle(
                     fontSize: 16
                 ),),
               ),
             ),
           )
         ],
       ),
     ),
   );
 }

  Widget searchList(){
    return check? ListView.builder(
        itemCount: searchSnapshot.docs.length,
        shrinkWrap: true,
        itemBuilder: (context, index){
            return  SearchTile(userName:searchSnapshot.docs[index]['name'] ,
                userEmail: searchSnapshot.docs[index]['email']);}) : Container();

  }
  @override
  void initState(){
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Colors.black26,
              padding: EdgeInsets.symmetric(horizontal: 34, vertical: 15
              ),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: seachcontroller,
                        decoration: InputDecoration(
                          hintText: 'search username...',
                          border: InputBorder.none,
                        ),
                      )),
                 InkWell(
                   onTap: (){
                     initiateSearch();
                   },
                   child: Container(
                     height: 40,
                       width: 40,
                       padding: EdgeInsets.all(10),
                       decoration: BoxDecoration(
                         gradient: LinearGradient(
                           colors: [
                             Colors.black45,
                             Colors.black26,
                           ]
                         ),
                         borderRadius: BorderRadius.circular(40)
                       ),
                       child: Image.asset('assets/search.png',color: Colors.black,)),
                 ),

                ],
              ),
            ),
            searchList()
          ],
        ),
      ),
    );
  }
}
getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}

