import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'constants.dart';

class HistoryList extends StatelessWidget {
  HistoryList({required this.urls, this.listkey});

  final List<String> urls;
  final listkey;

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: listkey ?? GlobalKey(),
      reverse: true,
      initialItemCount: urls.length,
      itemBuilder: (context, index, animation) {
        final item = urls[index];
        return ScaleTransition(
          scale: CurvedAnimation(
            parent: animation,
            curve: Curves.bounceOut,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Center(
              child: Container(
                padding: EdgeInsets.all(8),
                constraints: BoxConstraints(
                  minHeight: 50,
                ),
                margin: EdgeInsets.symmetric(horizontal: 10),
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
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () async {
                      await Clipboard.setData(ClipboardData(text: item));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Const.colors[4],
                          content: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              '"${item.length > 30 ? item.substring(0, 30) + "..." : item}" has been copied to clipboard',
                              style: Const.textStyleSnackBar,
                            ),
                          ),
                        ),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          child: Text(
                            item,
                            textAlign: TextAlign.center,
                            style: item.startsWith("Error")
                                ? Const.textStyleError
                                : Const.textStyleHistoryList,
                          ),
                        ),
                        SizedBox(width: 10),
                        if (RegExp(
                                r'^(?:(?:https?|ftp)://)?[\w.]+\.\w+(?:/[\w/\-?=%#]+)?$')
                            .hasMatch(item))
                          GestureDetector(
                            onTap: () {
                              openLink(
                                  RegExp(r'^[\w.]+\.\w+(?:/[\w/\-?=%#]+)?$')
                                          .hasMatch(item)
                                      ? 'http://' + item
                                      : item);
                            },
                            child: Icon(
                              Icons.open_in_new_rounded,
                              color: Const.colors[1],
                              size: Const.textStyleHistoryList.fontSize! + 2,
                            ),
                          ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> openLink(String link) async {
    if (!await launchUrl(
      Uri.parse(link),
      mode: LaunchMode.inAppWebView,
      webViewConfiguration: const WebViewConfiguration(enableDomStorage: false),
    )) {
      print('Error launching link');
    }
  }
}
