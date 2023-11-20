import 'package:chat_app/model/chat_user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseDatabase {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static User get user => auth.currentUser!;

  static Future<bool> userExists() async {
    return (await firestore.collection("users").doc(user.uid).get()).exists;
  }


  static Future<void> createUser()async{
     final time= DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser=ChatUserModel(
        id: user.uid,
        email: user.email.toString(),
        image: user.photoURL.toString(),
        name: user.displayName.toString(),
        about: "Hey! Hello Flutter world",
        isOnline: false,
        lastActive: time,
        createAt: time,
        pushToken: '',

    );


    return await firestore.collection("users").doc(user.uid).set(chatUser.toJson());

  }
}
