import 'package:flutter/material.dart';

class QrCode extends StatefulWidget {
  const QrCode({Key? key}) : super(key: key);

  @override
  State<QrCode> createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
       /* child: QrImage(
          data: 'This QR code has an embedded image as well',
          version: QrVersions.auto,
          size: 320,
          gapless: true,
          embeddedImage: const AssetImage('assets/logo.png'),
          embeddedImageStyle: QrEmbeddedImageStyle(
            size: const Size(80, 80),
          ),
        )*/
      ),
    );
  }
}
