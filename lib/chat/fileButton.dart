import 'package:flutter/material.dart';

import 'chat.dart';

class ChatInputFieldFileButton extends StatelessWidget {
  const ChatInputFieldFileButton({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: SizedBox(
        height: 35,
        width: 35,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            child: const Icon(
              Icons.file_copy,
              size: 25,
            ),
            onTap: () => sendFile(context, code),
          ),
        ),
      ),
    );
  }
}
