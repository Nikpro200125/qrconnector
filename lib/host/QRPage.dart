import 'dart:math';

import 'package:flutter/material.dart';

import '../services.dart';
import 'QRWidget.dart';

class QRPage extends StatelessWidget {
  const QRPage({required this.link});

  final String link;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var minSize = min(height, width);

    return Scaffold(
      backgroundColor: Const.colors[3],
      body: Center(
        child: Container(
          height: minSize * 0.65,
          width: minSize * 0.65,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60),
            color: Const.colors[0],
          ),
          child: Center(
            child: QR(link: link, minSize: minSize),
          ),
        ),
      ),
    );
  }
}
