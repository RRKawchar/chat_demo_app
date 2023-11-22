import 'package:chat_app/main.dart';
import 'package:chat_app/model/message_model.dart';
import 'package:chat_app/network/firebase_dabase.dart';
import 'package:flutter/material.dart';


class MessageCard extends StatefulWidget {
  final MessageModel messageModel;
  const MessageCard({super.key, required this.messageModel});

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return FirebaseDatabase.user.uid==widget.messageModel.fromId?
        _greenMessage():_blueMessage();
  }

  Widget _blueMessage(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mqSize.width*.04),
            margin: EdgeInsets.symmetric(
              horizontal: mqSize.width * .04,vertical:  mqSize.height * .01
            ),
            decoration: BoxDecoration(
              color:const Color.fromARGB(255, 221, 245, 255),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              border: Border.all(color: Colors.lightBlue)
            ),
            child: Text(widget.messageModel.msg,style: const TextStyle(fontSize: 15,color: Colors.black87),),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: mqSize.width*.04),
          child: Text(widget.messageModel.sent,style: const TextStyle(fontSize: 13,color: Colors.black54),),
        )
      ],
    );
  }
  Widget _greenMessage(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [

        Row(
          children: [
            SizedBox(width: mqSize.width*.04,),
            const Icon(Icons.done_all_rounded,color: Colors.blue,),
            const SizedBox(width: 2,),
            Text("${widget.messageModel.read}12.00 PM",style: const TextStyle(fontSize: 13,color: Colors.black54),),
          ],
        ),
        Flexible(
          child: Container(
            padding: EdgeInsets.all(mqSize.width*.04),
            margin: EdgeInsets.symmetric(
                horizontal: mqSize.width * .04,vertical:  mqSize.height * .01
            ),
            decoration: BoxDecoration(
                color:const Color.fromARGB(255, 218, 255, 176),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                border: Border.all(color: Colors.lightGreen)
            ),
            child: Text(widget.messageModel.msg,style: const TextStyle(fontSize: 15,color: Colors.black87),),
          ),
        ),
      ],
    );
  }
}
