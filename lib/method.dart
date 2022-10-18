import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<User> usersignup(String name,String email,String password) async{
    FirebaseAuth _auth=FirebaseAuth.instance;
    try{

      User? user=(await _auth.createUserWithEmailAndPassword(email: email, password: password)).user;
      if(user !=null){
        print("account created success");
        user.updateProfile(displayName: name);
        FirebaseFirestore _firestore=FirebaseFirestore.instance;
        await _firestore.collection("users").doc(_auth.currentUser!.uid).set({
          "name":name,
          "email":email,
          "status":"unavailable",
        });
        return user;
      }else
        {
          print("acoount creation failed");
          return user!;
        }

    }catch(e)
  {

    print(e);
   return null!!;
  }
}

Future<User> usersignin(String email,String password) async{
  FirebaseAuth _auth=FirebaseAuth.instance;
  try{

    User? user=(await _auth.signInWithEmailAndPassword(email: email, password: password)).user;
    if(user !=null){
      print("login");
      return user;
    }else {
      print("failed");
      return user!;
    }
  }
  catch(e)
  {
    print(e);
    return null!;
  }
}
Future <void> signout() async{
  FirebaseAuth _auth=FirebaseAuth.instance;
  await _auth.signOut();
}