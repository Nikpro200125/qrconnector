import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrconnector/chat/mobile.dart';

import 'desktop.dart';

class ChatInputField extends StatelessWidget {
  const ChatInputField({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    if (GetPlatform.isMobile) {
      return ChatInputFieldMobile(code: code);
    } else {
      return ChatInputFieldDesktop(code: code);
    }
  }
}
