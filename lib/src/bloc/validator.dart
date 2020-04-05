import 'dart:async';

import 'package:qr_reader/src/models/scan.dart';

class Validators {
  final validateGeo = StreamTransformer<List<Scan>, List<Scan>>.fromHandlers(
    handleData: (List<Scan> scans, EventSink<List<Scan>> sink) {
      final geoScans = scans.where((s) => s.type == 'geo').toList();
      sink.add(geoScans);
    },
  );

  final validateHttp = StreamTransformer<List<Scan>, List<Scan>>.fromHandlers(
    handleData: (List<Scan> scans, EventSink<List<Scan>> sink) {
      final geoScans = scans.where((s) => s.type == 'http').toList();
      sink.add(geoScans);
    },
  );
}
