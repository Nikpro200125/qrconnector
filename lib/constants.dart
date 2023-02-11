import 'package:flutter/material.dart';

class Const {
  static final textStyleWaitingHeader = TextStyle(
    color: colors[0],
    fontFamily: 'Ahayo',
    fontSize: 30,
  );

  static final textStyleHistoryList = TextStyle(
    color: colors[4],
    fontFamily: 'Ahayo',
    fontSize: 16,
  );

  static final textStyleChatField = TextStyle(
    color: Colors.purpleAccent,
    fontFamily: 'Ahayo',
    fontSize: 20,
  );

  static final textStyleError = TextStyle(
    color: Colors.red,
    fontSize: 30,
  );

  static final textStyleSnackBar = TextStyle(
    color: colors[0],
    fontSize: 16,
  );

  static final String pathToSite = "https://qrconnector.web.app";

  static final List<Color> colors = [
    0xFFE9E8EE,
    0xFFE0CD4D,
    0xFF4CA869,
    0xFF3F5560,
    0xFF64957F
  ].map((e) => Color(e)).toList();
}
