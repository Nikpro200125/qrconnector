import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'services.dart';

class HistoryList extends StatelessWidget {
  HistoryList({required this.urls, this.listKey});

  final List<String> urls;
  final listKey;

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: listKey ?? GlobalKey(),
      reverse: true,
      initialItemCount: urls.length,
      itemBuilder: (context, index, animation) {
        final item = urls[index];
        return HistoryListItem(item: item, animation: animation);
      },
    );
  }
}

class HistoryListItem extends StatelessWidget {
  HistoryListItem({required this.item, required this.animation});

  final String item;
  final Animation<double> animation;
  final pattern =
      "https://firebasestorage.googleapis.com/v0/b/qrconnector.appspot.com/o/";

  @override
  Widget build(BuildContext context) {
    bool isFile = item.contains(pattern);
    Widget child;
    if (isFile && item.contains("|")) {
      final fileName = item.substring(0, item.indexOf("|"));
      final linkToFile = item.substring(item.indexOf("|") + 1);
      child = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Flexible(
            fit: FlexFit.tight,
            child: InkWell(
              onTap: () {
                saveToClipboard(linkToFile);
                showSnackBar(
                    context, 'Link to the File "$fileName" has been copied');
              },
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 30,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.file_copy_rounded,
                      size: Const.textStyleHistoryList.fontSize! + 20,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'File $fileName',
                      style: Const.textStyleHistoryList,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            child: InkWell(
              onTap: () => openLink(context, linkToFile),
              child: Icon(
                Icons.download_rounded,
                size: Const.textStyleHistoryList.fontSize! + 20,
                color: Const.colors[3],
              ),
            ),
          ),
        ],
      );
    } else {
      child = MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            saveToClipboard(item);
            showSnackBar(context,
                '"${item.length > 30 ? item.substring(0, 30) + "..." : item}" has been copied to clipboard');
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: Container(
                  constraints: BoxConstraints(
                    minHeight: 30,
                  ),
                  child: Center(
                    child: Text(
                      item,
                      textAlign: TextAlign.center,
                      style: Const.textStyleHistoryList,
                    ),
                  ),
                ),
              ),
              if (RegExp(
                      r'^(?:(?:https?|ftp)://)?[\w.]+\.\w+(?:/[\w&/\-?=%#.]+)?$')
                  .hasMatch(item))
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: InkWell(
                    onTap: () => openLink(
                        context,
                        RegExp(r'^[\w.]+\.\w+(?:/[\w&/\-?=%#.]+)?$')
                                .hasMatch(item)
                            ? 'http://' + item
                            : item),
                    child: Icon(
                      Icons.open_in_new_rounded,
                      color: Const.colors[3],
                      size: Const.textStyleHistoryList.fontSize! + 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: Curves.bounceOut,
      ),
      child: Container(
        padding: EdgeInsets.all(8),
        constraints: BoxConstraints(
          minHeight: 50,
        ),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(4)),
          color: Const.colors[0],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  Future<void> openLink(BuildContext context, String link) async {
    if (!await launchUrl(
      Uri.parse(link),
      mode: LaunchMode.inAppWebView,
    )) {
      showSnackBar(context, 'Error launching link', Duration(seconds: 5));
    }
  }
}
