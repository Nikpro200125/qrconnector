import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../historyList/historyList.dart';
import '../services.dart';
import 'chatInputField.dart';

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
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              HistoryList(urls: listUrls, listKey: listKey),
              const SizedBox(height: 10),
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
