import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/core/mashov_api/src/models.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/screens/messages/msg_screen.dart';

class OneLineMsg extends StatelessWidget {
  final Conversation msg;
  final VoidCallback afterPush;

  const OneLineMsg({Key? key, required this.msg, required this.afterPush})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateTime msgSendTime = msg.messages[0].sendDate;
    return Column(
      children: <Widget>[
        Container(
          color: msg.isNew ? Colors.white : Colors.grey[300],
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => MsgScreen(msg.conversationId)
                )).then((value){
                  afterPush();
                });
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: [
                        Text(
                          '${msgSendTime.hour}:${msgSendTime.minute} '
                          '${msgSendTime.day}.${msgSendTime.month}.${msgSendTime.year}',
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: msg.isNew
                                  ? FontWeight.bold
                                  : FontWeight.w400),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        msg.hasAttachments
                            ? Icon(
                                Icons.attachment,
                                size: 20,
                                color: Colors.grey[600],
                              )
                            : const SizedBox()
                      ],
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            msg.messages[0].senderName.split('/')[1],
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: msg.isNew
                                    ? FontWeight.bold
                                    : FontWeight.w400),
                          ),
                          Text(
                            msg.messages[0].subject,
                            textAlign: TextAlign.end,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontSize: 17,
                                fontWeight: msg.isNew
                                    ? FontWeight.bold
                                    : FontWeight.w400),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const Divider(
          height: 0.5,
          color: Colors.black,
        ),
      ],
    );
  }
}