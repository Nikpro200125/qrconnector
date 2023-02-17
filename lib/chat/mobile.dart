import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrconnector/chat/fileButton.dart';
import 'package:qrconnector/chat/textButton.dart';

import '../services.dart';
import 'chat.dart';

class ChatInputFieldMobile extends StatefulWidget {
  const ChatInputFieldMobile({required this.code});

  final String code;

  @override
  State<ChatInputFieldMobile> createState() => _ChatInputFieldMobileState();
}

class _ChatInputFieldMobileState extends State<ChatInputFieldMobile> {
  late TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Const.colors[4],
      margin: const EdgeInsets.only(top: 5),
      child: TextFieldTapRegion(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ChatInputFieldFileButton(code: widget.code),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 5, bottom: 7),
                child: CupertinoTextField(
                  autocorrect: false,
                  controller: _controller,
                  autofocus: true,
                  textAlign: TextAlign.left,
                  style: Const.textStyleChatFieldMobile,
                  placeholder: "Type here something",
                  placeholderStyle: Const.textStyleChatField
                      .copyWith(color: Colors.grey[350]),
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.newline,
                  decoration: BoxDecoration(),
                  cursorColor: Colors.red,
                ),
              ),
            ),
            ChatInputFieldTextButton(code: widget.code, onSubmit: onSubmit),
          ],
        ),
      ),
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
