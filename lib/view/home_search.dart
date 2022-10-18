import 'package:chat_app/view/chat_room.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../method.dart';
class HomeSearch extends StatefulWidget {
  const HomeSearch({Key? key}) : super(key: key);

  @override
  State<HomeSearch> createState() => _HomeSearchState();
}

class _HomeSearchState extends State<HomeSearch> {
  final TextEditingController controller=TextEditingController();
  FirebaseFirestore firebaseFirestore=FirebaseFirestore.instance;
  FirebaseAuth _auth=FirebaseAuth.instance;
  Map<String,dynamic>? usermap;
  bool _isLoading=false;
  String chatRoomId(String user1,String user2)
  {
    if(user1[0].toLowerCase().codeUnits[0]>user2.toLowerCase().codeUnits[0]){
        return '$user1$user2';
    }else
      {
        return '$user2$user1';
      }
  }

  @override
  Widget build(BuildContext context) {
    final size=MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          IconButton(onPressed: (){
            signout();
          }, icon: Icon(Icons.logout))
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: size.height/15,
          ),
          Container(
            height: size.height/14,
            width: size.width,
            alignment: Alignment.center,
            child:Container(
              height: size.height/14,
              width: size.width/1.2,
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
              ),
            ) ,
          ),
          SizedBox(
            height: size.height/20,
          ),
          _isLoading==true?
              Center(
                child: CircularProgressIndicator(
                  color: Colors.brown,
                ),
              ):
          Container(
            height: size.height/15,
            width: size.width/1.3,
            child: MaterialButton(
              onPressed: (){

              },
              child: Text("Search",style: TextStyle(color: Colors.white),),
            ),
          ),
          SizedBox(
            height: size.height/20,
          ),
          ElevatedButton(onPressed: (){
            _search();
          }, child: Text("Search")),
          SizedBox(height: size.height/20,),
          usermap !=null ?
              ListTile(
                onTap: (){
                  String roomid=chatRoomId(_auth.currentUser!.displayName!, usermap!['name']);
Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatRoom(
  chatRoomId: roomid,
  userMap: usermap!,
)));
                },
                title: Text(usermap!['name']),
                subtitle: Text(usermap!['email']),
              )
              :Container(),

        ],
      ),
    );
  }
  void _search()async{
    setState(() {
      _isLoading=true;
    });
        await firebaseFirestore.collection("users").where("email",isEqualTo: controller.text).get().then((value) {
print(value);
          setState(() {
  usermap=value.docs[0].data();
});
setState(() {
  _isLoading=false;
});
print(usermap);
        });

  }
}
