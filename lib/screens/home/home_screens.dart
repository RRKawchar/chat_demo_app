
import 'package:chat_app/model/chat_user_model.dart';
import 'package:chat_app/network/firebase_dabase.dart';
import 'package:chat_app/screens/profile/profile_screen.dart';
import 'package:chat_app/widgets/chat_card_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreens extends StatefulWidget {
  const HomeScreens({super.key});

  @override
  State<HomeScreens> createState() => _HomeScreensState();
}

class _HomeScreensState extends State<HomeScreens> {
  List<ChatUserModel> list = [];


  @override
  void initState() {
    FirebaseDatabase.getSelfInfo();
    FirebaseDatabase.getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(CupertinoIcons.home),
        title: const Text("Chat App"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_)=>ProfileScreen(userModel: FirebaseDatabase.me)));
            },
            icon: const Icon(
              Icons.more_vert,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseDatabase.getAllUsers(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return const Center(
                child: CircularProgressIndicator(),
              );

            case ConnectionState.active:
            case ConnectionState.done:
              final data = snapshot.data?.docs;
              list =data?.map((e) => ChatUserModel.fromJson(e.data())).toList() ??[];
              if (list.isNotEmpty) {

                  return ListView.builder(
                    itemCount: list.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return ChatCardUser(
                        userModel: list[index],
                      );
                      // return  Text("name :${list[index].name}");
                    },
                  );




              } else {
                return const Center(
                  child: Text(
                    "Connection Failed to Database!!",
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }
          }
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          onPressed: () async {
            await FirebaseDatabase.auth.signOut();
            await GoogleSignIn().signOut();
          },
          child: const Icon(Icons.add_comment_rounded),
        ),
      ),
    );
  }
}
