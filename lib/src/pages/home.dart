import 'dart:io';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:qr_reader/src/bloc/scans.dart';
import 'package:qr_reader/src/models/scan.dart';
import 'package:qr_reader/src/pages/addresses.dart';
import 'package:qr_reader/src/pages/maps.dart';
import 'package:qr_reader/src/utils/scan_utils.dart' as utils;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _indexPage = 0;
  final ScansBloc _scansBloc = ScansBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              _scansBloc.deleteAll();
            },
          )
        ],
      ),
      body: Center(
        child: _callPage(_indexPage),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.filter_center_focus,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          _scanQr(context);
        },
      ),
      bottomNavigationBar: _createBottomNavigationBar(),
    );
  }

  Widget _createBottomNavigationBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      child: BottomNavigationBar(
        currentIndex: _indexPage,
        onTap: (int index) {
          setState(() {
            _indexPage = index;
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('Maps'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.brightness_5),
            title: Text('Adresses'),
          )
        ],
      ),
    );
  }

  Widget _callPage(int currentPage) {
    switch (currentPage) {
      case 0:
        return MapsPage();
      case 1:
        return AddressesPage();
      default:
        return MapsPage();
    }
  }

  void _scanQr(BuildContext context) async {
    String futureString;

    try {
      futureString = await BarcodeScanner.scan();
    } catch (e) {}

    if (futureString != null) {
      Scan scan = Scan(value: futureString);
      await _scansBloc.addScan(scan);

      if (Platform.isIOS) {
        Future.delayed(Duration(milliseconds: 750), () {
          utils.openScan(scan, context);
        });
      } else {
        utils.openScan(scan, context);
      }
    } else {
      SnackBar(
        content: Text('error'),
      );
    }
  }
}
