import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:grader_for_mashov_new/utilities/download_utilities.dart';
import 'package:grader_for_mashov_new/utilities/mashov_utilities.dart';
import 'package:grader_for_mashov_new/utilities/shared_preferences_utilities.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

class MsgScreen extends StatefulWidget {
  final String msgId;
  const MsgScreen(this.msgId, {Key? key}) : super(key: key);

  @override
  _MsgScreenState createState() => _MsgScreenState();
}

class _MsgScreenState extends State<MsgScreen> {
  Message? msg;
  double height = 0;
  List<Attachment> attachment = [];
  List<bool> loading = [];

  @override
  void initState() {
    DownloadUtilities.initNotification();
    getMashovData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget html = msg == null ? const SizedBox() : Padding(
      padding: const EdgeInsets.all(12),
      child: Html(
        data: """
          ${msg!.body}
        """,
        onLinkTap: (String? url, l, k, r) async {
          if (await canLaunch(url!)) {
            await launch(url);
          } else {
            throw 'Could not launch $url';
          }
        },
      ),
    );
    return Theme(
      data: SharedPreferencesUtilities.themes.themeData,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
        floatingActionButton: msg == null ? const SizedBox() : msg!.attachments.isEmpty ? const SizedBox() : FloatingActionButton(
          child: const Icon(Icons.attachment),
          backgroundColor: const Color(0xFFffac52).withOpacity(SharedPreferencesUtilities.themes.opacity),
          onPressed: changeHeight,
        ),
        appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: msg == null ? const SizedBox() : Row(
                children: [
                  Expanded(
                    flex: 8,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: AutoSizeText(
                          msg!.subject,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: const TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.w600),
                          minFontSize: 10,
                          maxFontSize: 18,
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                  msg!.attachments.isEmpty ? const SizedBox() : const Spacer(flex: 1,),
                ],
              ),
            ),
          ),
          backgroundColor: SharedPreferencesUtilities.themes.colorAppBar,
        ),
        body: msg == null ? Center(
          child: CircularProgressIndicator(color: SharedPreferencesUtilities.themes.colorAppBar,)
        ) : SingleChildScrollView(
          child: Column(
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                height: height,
                child: buildCard(),
              ),
              html,
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCard() => Card(
    elevation: 8,
    child: SingleChildScrollView(
      child: Column(
          children: List.generate(attachment.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
              child: Row(
                children: [
                  const Icon(Icons.insert_drive_file_outlined),
                  const SizedBox(width: 5,),
                  Flexible(
                    flex: 100,
                    child: Text(attachment[index].name!, overflow: TextOverflow.ellipsis,),
                  ),

                  loading[index] ? const Padding(
                      padding: EdgeInsets.all(11),
                      child: SizedBox(
                        width: 25,
                        height: 25,
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      )
                  ) : IconButton(
                      tooltip: 'הורדה',
                      icon: const Icon(Icons.file_download),
                      onPressed: (){
                        getAttachment(index);
                      }
                  )
                ],
              ),
            );
          })
      ),
    ),
  );

  Widget buildOneLineAttachment(int index) => Row(
    children: [
      const Icon(Icons.insert_drive_file_outlined),
      const SizedBox(width: 5,),
      Flexible(
        flex: 100,
        child: Text(attachment[index].name!, overflow: TextOverflow.ellipsis,),
      ),

      loading[index] ? const Padding(
          padding: EdgeInsets.all(11),
          child: SizedBox(
            width: 25,
            height: 25,
            child: CircularProgressIndicator(
              color: Colors.black,
            ),
          )
      ) : IconButton(
          tooltip: 'הורדה',
          icon: const Icon(Icons.file_download),
          onPressed: (){
            getAttachment(index);
          }
      )
    ],
  );

  void changeHeight() {
    setState(() {
      height = height == 0 ? 23 + (attachment.length*56) : 0;
    });
  }

  Future<void> getMashovData() async {
    msg = await MashovUtilities.getMsg(widget.msgId);
    setState(() {
      attachment = msg!.attachments;
      loading = List.generate(attachment.length, (index) => false);
    });
  }

  Future<bool> _requestPermissions() async {
    var status = await Permission.storage.status;

    if (status.isDenied) {
      await Permission.storage.request();
    }

    return Permission.storage.status.isGranted;
  }

  Future<void> getAttachment(int index) async {
    final isPermissionStatusGranted = await _requestPermissions();
    if (isPermissionStatusGranted) {
      setState(() {
        loading[index] = true;
      });
      var result = await MashovUtilities.getAttachment(msg!.messageId,
          msg!.attachments[index].id!, msg!.attachments[index].name!);

      if (result!['isSuccess']) {
        await DownloadUtilities.showNotification(result);
      }

      setState(() {
        loading[index] = false;
      });
    }
  }
}
