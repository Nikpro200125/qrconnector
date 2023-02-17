import 'package:flutter/material.dart';

import 'historyListItem.dart';

class HistoryList extends StatelessWidget {
  HistoryList({required this.urls, this.listKey});

  final List<String> urls;
  final listKey;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AnimatedList(
        key: listKey ?? GlobalKey(),
        reverse: true,
        initialItemCount: urls.length,
        itemBuilder: (context, index, animation) {
          final item = urls[index];
          return HistoryListItem(item: item, animation: animation);
        },
      ),
    );
  }
}
