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
  List<ChatUserModel> _list = [];
  final List<ChatUserModel> _searchList = [];
  bool _isSearching = false;
  @override
  void initState() {
    FirebaseDatabase.getSelfInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: WillPopScope(
        onWillPop: (){
          if(_isSearching){
            setState(() {
              _isSearching=!_isSearching;
            });
            return Future.value(false);
          }else{
            return Future.value(true);
          }

        },
        child: Scaffold(
          appBar: AppBar(
            leading: const Icon(CupertinoIcons.home),
            title: _isSearching?TextField(
              autofocus: true,
              onChanged: (val){
                _searchList.clear();
                for(var i in _list){
                  if( i.name.toLowerCase().contains(val.toLowerCase()) || i.email.toLowerCase().contains(val.toLowerCase())){

                    _searchList.add(i);
                  }
                  setState(() {

                  });

                }
              },
              decoration:const InputDecoration(
                border: InputBorder.none,
                hintText: "Name,Email........",
              ),
            ): const Text("Chat App"),
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isSearching=!_isSearching;
                  });
                },
                icon: Icon(
                  _isSearching ? CupertinoIcons.clear_circled_solid : Icons.search,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              ProfileScreen(userModel: FirebaseDatabase.me)));
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
                  _list =
                      data?.map((e) => ChatUserModel.fromJson(e.data())).toList() ??
                          [];
                  if (_list.isNotEmpty) {
                    return ListView.builder(
                      itemCount:_isSearching?_searchList.length: _list.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ChatCardUser(
                          userModel:_isSearching?_searchList[index]: _list[index],
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
        ),
      ),
    );
  }
}
