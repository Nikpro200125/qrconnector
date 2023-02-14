import 'dart:async';
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../historyList/historyList.dart';
import '../services.dart';
import 'QRWidget.dart';

class WaitingAndOut extends StatefulWidget {
  WaitingAndOut({super.key, required this.newRef, required this.link});

  final String link;
  final DatabaseReference newRef;

  @override
  State<WaitingAndOut> createState() => _WaitingAndOutState();
}

class _WaitingAndOutState extends State<WaitingAndOut> {
  var urls = <String>[];
  late StreamSubscription<DatabaseEvent> links;
  var listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    var minSize = min(
        MediaQuery.of(context).size.width, MediaQuery.of(context).size.height);

    return Scaffold(
      backgroundColor: Const.colors[3],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: HistoryList(urls: urls, listKey: listKey),
            ),
            const SizedBox(height: 10),
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'В ожидании ссылочки...',
                  textStyle: Const.textStyleWaitingHeader,
                ),
              ],
              repeatForever: true,
            ),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                color: Const.colors[0],
              ),
              child: QR(link: widget.link, minSize: minSize * 0.5),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    connectLinks();
  }

  @override
  void dispose() {
    links.cancel();
    super.dispose();
  }

  void connectLinks() {
    try {
      links = widget.newRef
          .child('links')
          .onChildAdded
          .listen((DatabaseEvent event) {
        if (event.snapshot.value is String) {
          String lastLink = event.snapshot.value.toString();
          setState(() {
            urls.insert(0, lastLink);
            listKey.currentState?.insertItem(0);
          });
        }
      });
    } on FirebaseException catch (e) {
      showErrorSnackBar(context: context, errorCode: 702);
      print(e.stackTrace);
    }
  }

  Future<void> openLink(String link) async {
    if (!await launchUrl(
      Uri.parse(link),
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(enableDomStorage: false),
    )) {
      showSnackBar(
          context: context,
          textSnackBar: "Не удалось открыть ссылку",
          duration: Duration(seconds: 4));
    }
  }
}
