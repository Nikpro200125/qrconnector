import 'dart:async';

import 'package:file_selector/file_selector.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrconnector/historyList.dart';

import 'constants.dart';

class Chat extends StatefulWidget {
  Chat({required this.code});

  final String code;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  var listUrls = <String>[];
  var listKey = GlobalKey<AnimatedListState>();
  late TextEditingController _controller;
  late StreamSubscription<DatabaseEvent> links;

  @override
  void initState() {
    super.initState();
    connectQR();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    links.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Const.colors[3],
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: HistoryList(urls: listUrls, listkey: listKey),
            ),
            SizedBox(height: 10),
            Stack(
              alignment: Alignment.centerLeft,
              children: [
                SizedBox(
                  height: 50,
                  child: CupertinoTextField(
                    controller: _controller,
                    autofocus: true,
                    onSubmitted: onSubmit,
                    textAlign: TextAlign.center,
                    style: Const.textStyleChatField,
                    placeholder: "Type here something",
                    placeholderStyle: Const.textStyleChatField
                        .copyWith(color: Colors.grey[350]),
                    keyboardType: TextInputType.url,
                    onEditingComplete: () {}, // prevent keyboard from closing
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: SizedBox(
                    height: 40,
                    width: 40,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        child: Icon(Icons.file_copy),
                        onTap: sendFile,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void onSubmit(String text) {
    if (text.length != 0) {
      _controller.value = TextEditingValue.empty;
      sendText(text);
    }
  }

  void sendText(String text) {
    try {
      var ref = FirebaseDatabase.instance.ref("qrs/${widget.code}/links");
      ref.update({ref.push().key!: text});
    } on FirebaseException catch (e) {
      print(e.stackTrace);
    }
  }

  Future<void> sendFile() async {
    final file = await openFile();
    final data = await file?.readAsBytes();
    if (file == null || data == null) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Const.colors[4],
        content: FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            "Working with your file",
            style: Const.textStyleSnackBar,
          ),
        ),
      ),
    );
    if (data.length > 1024 * 1024 * 20) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Const.colors[4],
          content: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "File size is large than 20MB, we are not working with such yet(",
              style: Const.textStyleSnackBar,
            ),
          ),
        ),
      );
      return;
    }
    final uniqueName =
        DateTime.now().millisecondsSinceEpoch.toString() + "." + file.name;
    final storage = FirebaseStorage.instance.ref("files").child(uniqueName);
    try {
      await storage.putData(data);
      final fileUrl = await storage.getDownloadURL();
      sendText(file.name + "|" + fileUrl);
    } on FirebaseException catch (e) {
      print("Here " + e.stackTrace.toString());
    }
  }

  Future<void> connectQR() async {
    try {
      FirebaseDatabase.instance
          .ref("qrs/${widget.code}")
          .update({"connected": true});
      links = FirebaseDatabase.instance
          .ref("qrs/${widget.code}/links")
          .onChildAdded
          .listen((DatabaseEvent event) {
        if (event.snapshot.value is String) {
          String lastLink = event.snapshot.value.toString();
          setState(() {
            listUrls.insert(0, lastLink);
            listKey.currentState?.insertItem(0);
          });
        }
      });
    } on FirebaseException catch (e) {
      print(e.stackTrace);
    }
  }
}
