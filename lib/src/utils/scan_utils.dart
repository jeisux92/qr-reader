import 'package:flutter/material.dart';
import 'package:qr_reader/src/models/scan.dart';
import 'package:url_launcher/url_launcher.dart';

openScan(Scan scan, BuildContext context) async {
  if (scan.type == 'http') {
    String url = scan.value;
    if (await canLaunch(url)) {
      await launch(
        url,
        forceWebView: true,
        enableJavaScript: true
      );
    } else {
      throw 'Could not launch $url';
    }
  } else {
    Navigator.pushNamed(context, 'map', arguments: scan);
  }
}
