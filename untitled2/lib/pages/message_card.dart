import 'package:flutter/material.dart';
import 'message_detail_page.dart';
import 'message_category.dart';

class MessageCard extends StatelessWidget {
  final Message message;
  final Function(Message) onTap;
  final List<Message> categoryMessages;

  const MessageCard(
      {Key? key,
      required this.message,
      required this.onTap,
      required this.categoryMessages})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: () {
          // Handle message card tap
          onTap(message);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MessageDetailPage(
                message: message,
                categoryMessages: categoryMessages, victimId: message.victimId,
              ),
            ),
          );
        },
        child: ListTile(
          leading: CircleAvatar(
            child: Icon(Icons.person),
          ),
          title: Text(message.sender),
          subtitle: Text(message.content),
          trailing: message.unreadCount > 0
              ? CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.yellow,
                  child: Text(
                    message.unreadCount.toString(),
                    style: TextStyle(color: Colors.black),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
