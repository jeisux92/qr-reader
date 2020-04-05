import 'package:flutter/material.dart';
import 'package:qr_reader/src/models/scan.dart';
import 'package:qr_reader/src/pages/addresses.dart';
import 'package:qr_reader/src/pages/maps.dart';
import 'package:qr_reader/src/providers/db.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _indexPage = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {},
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
          _scanQr();
        },
      ),
      bottomNavigationBar: _createBottomNavigationBar(),
    );
  }

  Widget _createBottomNavigationBar() {
    return BottomNavigationBar(
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

  void _scanQr() async {
    // https://github.com/jeisux92

    String futureString = 'https://github.com/jeisux92';

    // try {
    //   futureString = await BarcodeScanner.scan();
    // } catch (e) {}

    // print('futureString: $futureString');

    if (futureString != null) {
      Scan scan = Scan(value: futureString);
      await DBProvider.db.newScan(scan);
    }
  }
}
