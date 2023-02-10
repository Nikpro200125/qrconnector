import 'dart:async';
import 'package:qrconnector/historyList.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
            Container(
              child: CupertinoTextField(
                controller: _controller,
                autofocus: true,
                onSubmitted: onSubmit,
                textAlign: TextAlign.center,
                style: Const.textStyleChatField,
                placeholder: "Type here something",
                placeholderStyle:
                    Const.textStyleChatField.copyWith(color: Colors.grey[350]),
                keyboardType: TextInputType.url,
                onEditingComplete: () {}, // prevent keyboard from closing
              ),
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
      // setState(() {
      //   listUrls.insert(0, text);
      //   listKey.currentState?.insertItem(0);
      // });
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

  Future<void> connectQR() async {
    try {
      FirebaseDatabase.instance
          .ref("qrs/${widget.code}")
          .update({"connected": true});
      // var snapshot =
      //     await FirebaseDatabase.instance.ref("qrs/${widget.code}/links").get();
      // if (snapshot.exists) {
      //   setState(() {
      //     listUrls = (snapshot.value as Map<String, dynamic>)
      //         .values
      //         .map((e) => e.toString())
      //         .toList()
      //         .reversed
      //         .toList();
      //     listUrls.forEach((element) => listKey.currentState?.insertItem(0));
      //   });
      // }
      links = FirebaseDatabase.instance.ref("qrs/${widget.code}/links")
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
