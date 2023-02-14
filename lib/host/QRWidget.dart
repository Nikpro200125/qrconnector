import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../services.dart';

class QR extends StatelessWidget {
  QR({required this.link, required this.minSize});

  final String link;
  final double minSize;

  @override
  Widget build(BuildContext context) {
    return QrImage(
      version: QrVersions.auto,
      data: link,
      size: minSize * 0.5,
      gapless: false,
      dataModuleStyle: QrDataModuleStyle(
        dataModuleShape: QrDataModuleShape.circle,
        color: Const.colors[4],
      ),
      eyeStyle: const QrEyeStyle(
        eyeShape: QrEyeShape.square,
        color: Colors.black,
      ),
      errorStateBuilder: (context, error) {
        return Container(
          child: Text(
            error.toString(),
            style: Const.textStyleError,
            textAlign: TextAlign.center,
          ),
        );
      },
    );
  }
}
