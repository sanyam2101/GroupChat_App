import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  const MessageTile(
      {Key? key,
        required this.message,
        required this.sender,
        required this.sentByMe})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 6,
          bottom: 6,
          left: widget.sentByMe ? 0:24,
          right: widget.sentByMe ? 24:0),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.only(
            top: 17,bottom: 17,right: 20,left: 20),
        margin: widget.sentByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        decoration: BoxDecoration(
          borderRadius: widget.sentByMe
              ? const BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
          )
              : const BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),) ,
          color: widget.sentByMe
              ? Theme.of(context).primaryColor.withOpacity(0.85)
              : Colors.grey.shade700
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.sender.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                color: widget.sentByMe ?  Colors.black : Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8,),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16,color: Colors.white),)
          ],
        ),
      ),
    );
  }
}
