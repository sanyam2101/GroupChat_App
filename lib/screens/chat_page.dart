import 'package:chatting_app/screens/group_info.dart';
import 'package:chatting_app/services/database_service.dart';
import 'package:chatting_app/widgets/message_tile.dart';
import 'package:chatting_app/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;
  const ChatPage(
      {Key? key,
        required this.groupId,
        required this.groupName,
        required this.userName})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";

  @override
  void initState() {
    // TODO: implement initState
    getChatandAdmin();
    super.initState();
  }

  getChatandAdmin(){
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });
    DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.groupName),
        backgroundColor: Theme.of(context).primaryColor,
        actions: <Widget>[
          IconButton(onPressed: () {
            nextScreen(context, GroupInfo(
              groupId: widget.groupId,
              groupName: widget.groupName,
              adminName: admin,
            ));
          }, icon: Icon(Icons.info))
        ],
      ),
      body: Stack(
        children: <Widget>[
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20,vertical: 18),
              width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(0.6),
              child: Row(
                children: <Widget>[
                  Expanded(child: TextFormField(
                    controller: messageController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                      border: InputBorder.none,
                      hintText: "Send a message...",
                    ),
                  )),
                  const SizedBox(width: 12,),
                  GestureDetector(
                    onTap: (){
                      sendMessage();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  chatMessages(){
    return StreamBuilder(
        builder: (context, AsyncSnapshot snapshot){
          return snapshot.hasData
              ? ListView.builder(
              itemBuilder: (context, index){
                return MessageTile(
                    message: snapshot.data.docs[index]['message'],
                    sender: snapshot.data.docs[index]['sender'],
                    sentByMe: widget.userName ==
                        snapshot.data.docs[index]['sender']);
              },
            itemCount: snapshot.data.docs.length,
          )
              : Container();
        },
      stream: chats,
    );
  }

  sendMessage(){
    if(messageController.text.isNotEmpty){
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().microsecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
