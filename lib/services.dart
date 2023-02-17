import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    color: colors[0],
    fontFamily: 'Ahayo',
    fontSize: 20,
  );

  static final textStyleChatFieldMobile = TextStyle(
    color: colors[0],
    fontFamily: 'Ahayo',
    fontSize: 20,
  );

  static final textStyleChatFieldDesktop = TextStyle(
    color: colors[3],
    fontFamily: 'Ahayo',
    fontSize: 20,
  );

  static const textStyleError = TextStyle(
    color: Colors.red,
    fontSize: 30,
  );

  static final textStyleSnackBar = TextStyle(
    color: colors[0],
    fontSize: 16,
  );

  static const String pathToSite = "https://qrconnector.web.app";

  static final List<Color> colors = [
    0xFFE9E8EE,
    0xFFE0CD4D,
    0xFF4CA869,
    0xFF3F5560,
    0xFF64957F
  ].map((e) => Color(e)).toList();
}

void showSnackBar(
    {required BuildContext context,
    required String textSnackBar,
    Duration? duration}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Const.colors[4],
      duration: duration ?? Duration(milliseconds: 1500),
      content: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          textSnackBar,
          style: Const.textStyleSnackBar,
        ),
      ),
    ),
  );
}

void showErrorSnackBar(
    {required BuildContext context,
    required int errorCode,
    String? errorText}) {
  showSnackBar(
      context: context,
      textSnackBar:
          "An error has occurred with code $errorCode. " + (errorText ?? ""),
      duration: Duration(seconds: 4));
}

void saveToClipboard(String text) {
  Clipboard.setData(ClipboardData(text: text));
}
