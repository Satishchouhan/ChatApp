import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
class ChatRoom extends StatefulWidget {
  final Map<String,dynamic> userMap;
  final  String chatRoomId;
  const ChatRoom({Key? key,required this.chatRoomId,required this.userMap}) : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController _message=TextEditingController();
  FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;
  FirebaseAuth _auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userMap['name']),
      ),
      body: Container(
        height: size.height/1.25,
        width: size.width,
        child: StreamBuilder<QuerySnapshot>(
          stream: firebaseFirestore.collection('chatroom').doc(widget.chatRoomId).collection('chats').orderBy("time",descending: false).snapshots(),
          builder: (BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot){
            if(snapshot.data != null){
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context,index){
                return Container(
                    alignment:snapshot.data!.docs[index]['sendby']==_auth.currentUser!.displayName?Alignment.centerRight:Alignment.centerLeft ,
                    child: Text(snapshot.data!.docs[index]['message']));
              });
            }else
              {
                return Container();
              }
          }
        ),
      ),
      bottomNavigationBar: Container(
        height: size.height/10,
        width:size.width,
        alignment: Alignment.center,
        child:Container(
          height: size.height/12,
          width: size.width/1.1,
          child: Row(
            children: [
              Container(
                height: size.height/12,
                width: size.width/1.5,
                child: TextField(
                  controller: _message,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)
                    )
                  ),
                ),
              ),IconButton(onPressed: (){
                sendMessage();
              }, icon: Icon(Icons.send))
            ],
          ),
        ) ,
      ),
    );
  }
  void sendMessage() async{
  if(_message.text.isNotEmpty)
    {
      Map<String,dynamic> message={
        "sendby":_auth.currentUser!.displayName!,
        "message":_message.text,
        "time":FieldValue.serverTimestamp()
      };
      await firebaseFirestore.collection('chatroom').doc(widget.chatRoomId).collection('chats').add(message);
_message.clear();
    }else
      {

      }

   }
}
