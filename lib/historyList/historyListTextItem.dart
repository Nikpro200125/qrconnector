import 'package:flutter/material.dart';

import '../services.dart';

class HistoryListTextItem extends StatelessWidget {
  HistoryListTextItem({required this.item, required this.openLink});

  final String item;
  final Function openLink;

  @override
  Widget build(BuildContext context) {
    final hasOpenLinkIcon =
        RegExp(r'^(?:(?:https?)://)?[\w.]+\.\w+(?:/[\w&/\-?=%#.]+)?$')
            .hasMatch(item);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          saveToClipboard(item);
          showSnackBar(
              context: context,
              textSnackBar:
                  '"${item.length > 30 ? item.substring(0, 30) + "..." : item}" has been copied to clipboard');
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              fit: FlexFit.tight,
              child: Container(
                constraints: const BoxConstraints(
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
            if (hasOpenLinkIcon)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: InkWell(
                  onTap: () => openLink(context, item),
                  child: Icon(
                    Icons.open_in_new_rounded,
                    color: Const.colors[3],
                    size: 36,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
