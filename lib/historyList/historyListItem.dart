import 'package:flutter/material.dart';
import 'package:qrconnector/historyList/historyListFileItem.dart';
import 'package:qrconnector/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'historyListTextItem.dart';

class HistoryListItem extends StatelessWidget {
  HistoryListItem({required this.item, required this.animation});

  final String item;
  final Animation<double> animation;
  final pattern =
      "https://firebasestorage.googleapis.com/v0/b/qrconnector.appspot.com/o/";

  @override
  Widget build(BuildContext context) {
    bool isFile = item.contains(pattern) && item.contains("|");

    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: Curves.bounceOut,
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        constraints: const BoxConstraints(
          minHeight: 50,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          color: Const.colors[0],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: (isFile)
            ? HistoryListFileItem(item: item, openLink: openLink)
            : HistoryListTextItem(item: item, openLink: openLink),
      ),
    );
  }

  Future<void> openLink(BuildContext context, String link) async {
    String finalLink =
        RegExp(r'^[\w.]+\.\w+(?:/[\w&/\-?=%#.]+)?$').hasMatch(item)
            ? 'http://' + link
            : link;
    bool isLaunched =
        await launchUrl(Uri.parse(finalLink), mode: LaunchMode.inAppWebView);
    if (!isLaunched) {
      showErrorSnackBar(
          context: context, errorCode: 706, errorText: 'Error launching link');
    }
  }
}
