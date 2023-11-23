import 'dart:developer';
import 'dart:io';

import 'package:chat_app/model/chat_user_model.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/utils/helper/helper_class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseDatabase {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static FirebaseStorage storage = FirebaseStorage.instance;

  static User get user => auth.currentUser!;

  static ChatUserModel me = ChatUserModel(
    id: user.uid,
    name: user.displayName.toString(),
    email: user.email.toString(),
    about: "Hey, I'm using We Chat!",
    image: user.photoURL.toString(),
    createAt: '',
    isOnline: false,
    lastActive: '',
    pushToken: '',
  );
  static Future<bool> userExists() async {
    return (await firestore.collection("users").doc(user.uid).get()).exists;
  }

  static Future<void> getSelfInfo() async {
    await firestore.collection("users").doc(user.uid).get().then(
      (user) async {
        if (user.exists) {
          me = ChatUserModel.fromJson(user.data()!);
          kPrint("My Data : ${user.data()}");
        } else {
          await createUser().then((value) => getSelfInfo());
        }
      },
    );
  }

  static Future<void> createUser() async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final chatUser = ChatUserModel(
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

    return await firestore
        .collection("users")
        .doc(user.uid)
        .set(chatUser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection("users")
        .where("id", isNotEqualTo: user.uid)
        .snapshots();
  }

  static Future<void> updateUserInfo() async {
    await firestore.collection("users").doc(user.uid).update({
      "name": me.name,
      "about": me.about,
    });
  }

  // static Future<void> updateProfilePic(File file)async{
  //   final ext=file.path.split('.').last;
  //   kPrint("Extension : $ext");
  //   final ref=storage.ref().child("ProfilePicture/${user.uid}.$ext");
  //   await ref.putFile(file,SettableMetadata(contentType: 'image/$ext')).then((p0){
  //     kPrint("Data Transferred : ${p0.bytesTransferred/1000} kb");
  //   });
  //  me.image= await ref.getDownloadURL();
  //  await firestore.collection("users").doc(user.uid).update({
  //    'image':me.image,
  //  });
  //
  // }

  static Future<void> updateProfilePicture(File file) async {
    final ext = file.path.split('.').last;
    log('Extension: $ext');
    final ref = storage.ref().child('profile_pictures/${user.uid}.$ext');
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    me.image = await ref.getDownloadURL();
    await firestore
        .collection('users')
        .doc(user.uid)
        .update({'image': me.image});
  }

  static String getConversionId(String id) => user.uid.hashCode <= id.hashCode
      ? "${user.uid}_$id"
      : "${id}_${user.uid}";

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      ChatUserModel userModel) {
    return firestore
        .collection('chats/${getConversionId(userModel.id)}/messages/')
        .snapshots();
  }

  static Future<void> sendMessage(ChatUserModel userModel, String msg) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final MessageModel messageModel = MessageModel(
      msg: msg,
      read: '',
      told: userModel.id,
      type: Type.text,
      sent: time,
      fromId: user.uid,
    );

    final ref =
        firestore.collection("chat/${getConversionId(userModel.id)}/message");
    await ref.doc().set(messageModel.toJson());
  }
}
