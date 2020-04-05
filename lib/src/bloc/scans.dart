import 'dart:async';

import 'package:qr_reader/src/bloc/validator.dart';
import 'package:qr_reader/src/providers/db.dart';

class ScansBloc with Validators {
  static final ScansBloc _singleton = new ScansBloc._internal();

  ScansBloc._internal() {
    //Get Scans from stabase
    getScans();
  }

  factory ScansBloc() {
    return _singleton;
  }

  final _scansController = StreamController<List<Scan>>.broadcast();

  Stream<List<Scan>> get scansStream =>
      _scansController.stream.transform(validateGeo);

  Stream<List<Scan>> get scansStreamHttp =>
      _scansController.stream.transform(validateHttp);

  dispose() {
    _scansController?.close();
  }

  getScans() async {
    _scansController.sink.add(await DBProvider.db.getScans());
  }

  addScan(Scan scan) async {
    await DBProvider.db.newScan(scan);
    getScans();
  }

  deleScan(int id) async {
    await DBProvider.db.deleteScan(id);
    getScans();
  }

  deleteAll() async {
    await DBProvider.db.deleteAllScans();
    getScans();
  }
}
