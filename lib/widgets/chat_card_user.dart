import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/model/chat_user_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatCardUser extends StatefulWidget {
  final ChatUserModel userModel;
  const ChatCardUser({super.key, required this.userModel});

  @override
  State<ChatCardUser> createState() => _ChatCardUserState();
}

class _ChatCardUserState extends State<ChatCardUser> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: size.width * .04, vertical: 4),
      elevation: 0.5,
      child: InkWell(
        onTap: () {},
        child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(size.width * .3),
              child: CachedNetworkImage(
                imageUrl: widget.userModel.image,
                imageBuilder: (context, imageProvider) => Container(
                  height: size.height * .055,
                  width: size.height * .055,
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
            title: Text(widget.userModel.name.toString()),
            subtitle: Text(
              widget.userModel.about,
              maxLines: 1,
            ),
            trailing: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                  color: Colors.green.shade400,
                  borderRadius: BorderRadius.circular(10)),
            )

            // Text(
            //   widget.userModel.createAt,
            //   style: const TextStyle(
            //     color: Colors.black54,
            //   ),
            // ),
            ),
      ),
    );
  }
}
