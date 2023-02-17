import 'package:flutter/material.dart';

class ChatInputFieldTextButton extends StatelessWidget {
  final String code;
  final VoidCallback onSubmit;

  ChatInputFieldTextButton({required this.code, required this.onSubmit});

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
              Icons.send_rounded,
              size: 25,
            ),
            onTap: onSubmit,
          ),
        ),
      ),
    );
  }
}
