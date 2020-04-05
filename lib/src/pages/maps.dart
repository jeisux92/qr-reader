import 'package:flutter/material.dart';
import 'package:qr_reader/src/providers/db.dart';

class MapsPage extends StatefulWidget {
  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: DBProvider.db.getScans(),
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

          return ListView.builder(
            itemCount: scans.length,
            itemBuilder: (BuildContext context, int index) => Dismissible(
              background: Container(
                color: Colors.red,
              ),
              secondaryBackground: Container(
                color: Colors.greenAccent,
              ),
              onDismissed: (DismissDirection dismiss) {
                setState(() {
                  scans.removeAt(index);
                });
              },
              child: ListTile(
                leading: Icon(
                  Icons.cloud_queue,
                  color: Theme.of(context).primaryColor,
                ),
                title: Text(scans[index].value),
                trailing: Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.grey,
                ),
              ),
              key: Key(
                scans[index].id.toString(),
              ),
            ),
          );
        });
  }
}
