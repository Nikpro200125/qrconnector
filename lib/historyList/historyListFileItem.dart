import 'package:flutter/material.dart';

import '../services.dart';

class HistoryListFileItem extends StatelessWidget {
  HistoryListFileItem({required this.item, required this.openLink});

  final String item;
  final Function openLink;

  @override
  Widget build(BuildContext context) {
    final fileName = item.substring(0, item.indexOf("|"));
    final linkToFile = item.substring(item.indexOf("|") + 1);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: InkWell(
            onTap: () {
              saveToClipboard(linkToFile);
              showSnackBar(
                  context: context,
                  textSnackBar: 'Link to the File "$fileName" has been copied');
            },
            child: Container(
              constraints: const BoxConstraints(
                minHeight: 30,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.file_copy_rounded,
                    size: 36,
                  ),
                  const SizedBox(width: 10),
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
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: InkWell(
            onTap: () => openLink(context, linkToFile),
            child: Icon(
              Icons.download_rounded,
              size: 36,
              color: Const.colors[3],
            ),
          ),
        ),
      ],
    );
  }
}
