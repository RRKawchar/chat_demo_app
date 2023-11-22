import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/model/chat_user_model.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/network/firebase_dabase.dart';
import 'package:chat_app/utils/helper/helper_class.dart';
import 'package:chat_app/widgets/message_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final ChatUserModel userModel;
  const ChatScreen({super.key, required this.userModel});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<MessageModel> _list = [];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
        backgroundColor: Color.fromARGB(255, 234, 248, 255),
        body: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseDatabase.getAllMessage(),
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
                      kPrint("Data : ${jsonEncode(data![0].data())}");
                      // _list =
                      //     data?.map((e) => ChatUserModel.fromJson(e.data())).toList() ??
                      //         [];
                      _list.clear();
                      _list.add(MessageModel(
                          msg: 'Hello',
                          read: '',
                          told: 'xyz',
                          type: Type.text,
                          sent: '12.00 PM',
                          fromId: FirebaseDatabase.user.uid));
                      _list.add(MessageModel(
                          msg: 'Hii',
                          read: '',
                          told: FirebaseDatabase.user.uid,
                          type: Type.text,
                          sent: '12.04 PM',
                          fromId: 'xyz'));

                      if (_list.isNotEmpty) {
                        return ListView.builder(
                          itemCount: _list.length,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return MessageCard(
                              messageModel: _list[index],
                            );
                          },
                        );
                      } else {
                        return const Center(
                          child: Text(
                            "Say Hi 👋",
                            style: TextStyle(fontSize: 20),
                          ),
                        );
                      }
                  }
                },
              ),
            ),
            _chatInput(),
          ],
        ),
      ),
    );
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: mqSize.height * .01, horizontal: mqSize.width * .025),
      child: Row(
        children: [
          Expanded(
            child: Card(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.emoji_emotions,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const Expanded(
                      child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: InputDecoration(
                        hintText: "Type Something...",
                        hintStyle: TextStyle(
                          color: Colors.blueAccent,
                        ),
                        border: InputBorder.none),
                  )),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.image,
                      color: Colors.blueAccent,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.camera_alt_rounded,
                      color: Colors.blueAccent,
                    ),
                  ),
                  SizedBox(
                    width: mqSize.width * .02,
                  )
                ],
              ),
            ),
          ),
          MaterialButton(
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, right: 5, left: 10, bottom: 10),
            shape: const CircleBorder(),
            color: Colors.green,
            onPressed: () {},
            child: const Icon(
              Icons.send,
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black54,
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(mqSize.width * .3),
            child: CachedNetworkImage(
              imageUrl: widget.userModel.image,
              imageBuilder: (context, imageProvider) => Container(
                height: mqSize.height * .05,
                width: mqSize.height * .05,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      colorFilter: const ColorFilter.mode(
                          Colors.transparent, BlendMode.colorBurn)),
                ),
              ),
              errorWidget: (context, url, error) => const CircleAvatar(
                child: Icon(CupertinoIcons.person),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.userModel.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(
                height: 2,
              ),
              const Text(
                "Last Seen Not Available",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
