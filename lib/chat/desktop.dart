import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrconnector/chat/fileButton.dart';
import 'package:qrconnector/chat/textButton.dart';
import 'package:qrconnector/services.dart';

import 'chat.dart';

class ChatInputFieldDesktop extends StatefulWidget {
  final String code;

  @override
  State<ChatInputFieldDesktop> createState() => _ChatInputFieldDesktopState();

  ChatInputFieldDesktop({required this.code});
}

class _ChatInputFieldDesktopState extends State<ChatInputFieldDesktop> {
  late TextEditingController _controller;
  late FocusNode focusNode = FocusNode(
    onKey: (node, event) {
      if (event.isKeyPressed(LogicalKeyboardKey.enter) &&
          !(event.isShiftPressed || event.isControlPressed)) {
        onSubmit();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    },
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ChatInputFieldFileButton(code: widget.code),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: CupertinoTextField(
              autocorrect: false,
              controller: _controller,
              autofocus: true,
              textAlign: TextAlign.center,
              style: Const.textStyleChatFieldDesktop,
              placeholder: "Type here something",
              placeholderStyle:
                  Const.textStyleChatField.copyWith(color: Colors.grey[350]),
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
              focusNode: focusNode,
            ),
          ),
        ),
        ChatInputFieldTextButton(code: widget.code, onSubmit: onSubmit),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void onSubmit() {
    String text = _controller.text;
    if (text.trim().length != 0) {
      sendText(context, widget.code, text.trim());
      setState(() {
        _controller.value = TextEditingValue.empty;
      });
    }
  }
}
