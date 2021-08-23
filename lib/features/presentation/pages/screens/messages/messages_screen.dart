import 'package:flutter/material.dart';
import 'package:grader_for_mashov_new/core/mashov_api/src/models.dart';
import 'package:grader_for_mashov_new/features/presentation/pages/base_screen.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/one_line/one_line_msg.dart';
import 'package:grader_for_mashov_new/features/presentation/widgets/screens_widgets/flexible_space_app_bar.dart';
import 'package:grader_for_mashov_new/features/utilities/mashov_utilities.dart';

class MessagesScreen extends StatefulWidget {
  final int indexPage;
  const MessagesScreen(this.indexPage, {Key? key}) : super(key: key);

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends BaseScreen<MessagesScreen> {
  int page = 0;

  List<Conversation>? msgs;
  int newMsgs = 0;
  int readMsgs = 0;
  double lengthOfPages = 0;

  @override
  int get from => widget.indexPage;

  @override
  String get title => 'הודעות';

  @override
  double? get expandedHeight => FlexibleSpaceAppBar.expandedHeight;
  
  @override
  Widget? get flexibleSpace => FlexibleSpaceAppBar(
    items: [
      FlexibleSpaceAppBarItem(
        description: 'הודעות שלא נקראו',
        mainNumber: newMsgs.toString(),
        color: Colors.red
      ),
      FlexibleSpaceAppBarItem(
          description: 'הודעות שנקראו',
          mainNumber: readMsgs.toString(),
          color: Colors.green
      ),
    ],
  );

  @override
  Widget? get body => msgs == null ? null : Column(
    children: List.generate(msgs!.length, (index) {
      return OneLineMsg(
          msg: msgs![index],
          afterPush: () {
            setState(() {
              msgs = null;
              getMashovData();
            });
          });
    }),
  );

  @override
  Widget? get bottomNavigationBar => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(12),
        child: GestureDetector(
          onTap: () {
            if (page != 0) {
              setState(() {
                msgs = null;
                page -= 1;
              });
            }
            getMashovData();
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.arrow_back_ios,
                color: page == 0 ? Colors.grey : Colors.black,
              ),
              Text(
                'הקודם',
                style: TextStyle(
                    fontSize: 16,
                    color: page == 0 ? Colors.grey : Colors.black),
              )
            ],
          ),
        ),
      ),
      Expanded(
        child: Container(
          margin: const EdgeInsets.only(),
          height: 40,
          child: ListView(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            children: List.generate(lengthOfPages.toInt(), (index) {
              return Container(
                decoration: BoxDecoration(
                  border: const Border.fromBorderSide(BorderSide(width: 0.2)),
                  color: page == index
                      ? const Color(0xFF03a9f4)
                      : Colors.transparent,
                ),
                width: 35,
                margin: const EdgeInsets.all(1),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        msgs = null;
                        page = index;
                      });
                      getMashovData();
                    },
                    child: Center(
                      child: Text('${index + 1}'),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(12),
        child: GestureDetector(
          onTap: () {
            setState(() {
              if (lengthOfPages.toInt() != page + 1) {
                msgs = null;
                page += 1;
              }
            });
            getMashovData();
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'הבא',
                style: TextStyle(
                    fontSize: 16,
                    color: lengthOfPages.toInt() == page + 1
                        ? Colors.grey
                        : Colors.black),
              ),
              Icon(Icons.arrow_forward_ios,
                  color: lengthOfPages.toInt() == page + 1
                      ? Colors.grey
                      : Colors.black)
            ],
          ),
        ),
      ),
    ],
  );

  @override
  Future<void> getMashovData() async {
    var result = await MashovUtilities.getMessages(page);
    newMsgs = result['newMsgs'];
    readMsgs = result['readMsgs'];
    msgs = result['msgs'];
    lengthOfPages = result['lengthOfPages'];
    setState(() {});
  }

  @override
  void reload() {
    msgs = null;
    newMsgs = 0;
    readMsgs = 0;
    setState(() {});
    super.reload();
  }
}
