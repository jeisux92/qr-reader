import 'dart:async';
import 'package:flutter/material.dart';
import 'package:qr_reader/src/bloc/scans.dart';
import 'package:qr_reader/src/models/scan.dart';
import 'package:qr_reader/src/utils/scan_utils.dart' as util;

class MapsPage extends StatelessWidget {
  final ScansBloc _scansBloc = ScansBloc();

  @override
  Widget build(BuildContext context) {
    _scansBloc.getScans();
    return StreamBuilder(
        stream: _scansBloc.scansStream,
        builder: (BuildContext build, AsyncSnapshot<List<Scan>> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final scans = snapshot.data;

          if (scans.length == 0) {
            return Center(child: Text('There is not information'));
          }

          return RefreshIndicator(
            child: ListView.builder(
              itemCount: scans.length,
              itemBuilder: (BuildContext context, int index) => Dismissible(
                background: Container(
                  color: Colors.red,
                  child: Center(
                    child: Text(
                      'Remove',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                onDismissed: (DismissDirection dismiss) {
                  _scansBloc.deleScan(scans[index].id);
                },
                child: ListTile(
                  leading: Icon(
                    Icons.map,
                    color: Theme.of(context).primaryColor,
                  ),
                  title: Text(scans[index].value),
                  subtitle: Text(scans[index].id.toString()),
                  trailing: Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey,
                  ),
                  onTap: () => util.openScan(scans[index], context),
                ),
                key: UniqueKey(),
              ),
            ),
            onRefresh: () {
              Duration duration = Duration(milliseconds: 1000);
              return Future.delayed(duration);
            },
          );
        });
  }
}
