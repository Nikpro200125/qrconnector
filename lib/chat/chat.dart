import 'dart:async';

import 'package:file_selector/file_selector.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:qrconnector/chat/inputField.dart';

import '../historyList/historyList.dart';
import '../services.dart';

class Chat extends StatefulWidget {
  Chat({required this.code});

  final String code;

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  var listUrls = <String>[];
  var listKey = GlobalKey<AnimatedListState>();
  late StreamSubscription<DatabaseEvent> links;

  @override
  void initState() {
    super.initState();
    connectQR();
  }

  @override
  void dispose() {
    links.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Const.colors[3],
      body: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxWidth: 950,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              HistoryList(urls: listUrls, listKey: listKey),
              ChatInputField(code: widget.code),
            ],
          ),
        ),
      ),
    );
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
      showErrorSnackBar(context: context, errorCode: 705);
      print(e.stackTrace);
    }
  }
}

Future<void> sendFile(BuildContext context, String code) async {
  final file = await openFile();
  final data = await file?.readAsBytes();
  if (file == null || data == null) {
    return;
  }
  showSnackBar(
      context: context,
      textSnackBar: "Working with your file",
      duration: Duration(seconds: 1));
  int maxSize = 1024 * 1024 * 20; // 20 MB
  if (data.length > maxSize) {
    showSnackBar(
        context: context,
        textSnackBar:
            "File size is large than 20MB, we are not working with such yet(");
    return;
  }
  final timeNow = DateTime.now().millisecondsSinceEpoch.toString();
  final uniqueName = timeNow + "." + file.name;
  final storage = FirebaseStorage.instance.ref("files").child(uniqueName);
  try {
    await storage.putData(data);
    final fileUrl = await storage.getDownloadURL();
    sendText(context, code, file.name + "|" + fileUrl);
  } on FirebaseException catch (e) {
    showErrorSnackBar(context: context, errorCode: 704);
    print(e.stackTrace);
  }
}

void sendText(BuildContext context, String code, String text) {
  try {
    var ref = FirebaseDatabase.instance.ref("qrs/${code}/links");
    ref.update({ref.push().key!: text});
  } on FirebaseException catch (e) {
    showErrorSnackBar(context: context, errorCode: 703);
    print(e.stackTrace);
  }
}
