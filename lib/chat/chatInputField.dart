import 'package:file_selector/file_selector.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrconnector/services.dart';

class ChatInputField extends StatefulWidget {
  final code;

  @override
  State<ChatInputField> createState() => _ChatInputFieldState();

  ChatInputField({required this.code});
}

class _ChatInputFieldState extends State<ChatInputField> {
  late TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: SizedBox(
            height: 40,
            width: 40,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                child: const Icon(
                  Icons.file_copy,
                  size: 32,
                ),
                onTap: sendFile,
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: CupertinoTextField(
              autocorrect: false,
              controller: _controller,
              autofocus: true,
              textAlign: TextAlign.center,
              style: Const.textStyleChatField,
              placeholder: "Type here something",
              placeholderStyle:
                  Const.textStyleChatField.copyWith(color: Colors.grey[350]),
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 4,
              onEditingComplete: () {},
              textInputAction: TextInputAction.newline,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: SizedBox(
            height: 40,
            width: 40,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                child: const Icon(
                  Icons.send_rounded,
                  size: 32,
                ),
                onTap: onSubmit,
              ),
            ),
          ),
        ),
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
      sendText(text.trim());
      setState(() {
        _controller.value = TextEditingValue.empty;
      });
    }
  }

  void sendText(String text) {
    try {
      var ref = FirebaseDatabase.instance.ref("qrs/${widget.code}/links");
      ref.update({ref.push().key!: text});
    } on FirebaseException catch (e) {
      showErrorSnackBar(context: context, errorCode: 703);
      print(e.stackTrace);
    }
  }

  Future<void> sendFile() async {
    final file = await openFile();
    final data = await file?.readAsBytes();
    if (file == null || data == null) {
      return;
    }
    showSnackBar(
        context: context,
        textSnackBar: "Working with your file",
        duration: Duration(seconds: 1));
    int maxSize = 1024 * 1024 * 20; // 20 MB
    if (data.length > maxSize) {
      showSnackBar(
          context: context,
          textSnackBar:
              "File size is large than 20MB, we are not working with such yet(");
      return;
    }
    final timeNow = DateTime.now().millisecondsSinceEpoch.toString();
    final uniqueName = timeNow + "." + file.name;
    final storage = FirebaseStorage.instance.ref("files").child(uniqueName);
    try {
      await storage.putData(data);
      final fileUrl = await storage.getDownloadURL();
      sendText(file.name + "|" + fileUrl);
    } on FirebaseException catch (e) {
      showErrorSnackBar(context: context, errorCode: 704);
      print(e.stackTrace);
    }
  }
}
