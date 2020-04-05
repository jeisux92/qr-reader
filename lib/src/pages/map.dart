import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:qr_reader/src/models/scan.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final MapController _mapController = MapController();
  String _mapType = 'streets';
  @override
  Widget build(BuildContext context) {
    final Scan scan = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text('Qr Coordinates'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.my_location),
            onPressed: () {
              _mapController.move(scan.getLatitud(), 10.0);
            },
          )
        ],
      ),
      body: _createMap(scan),
      floatingActionButton: _createFloatButton(context), // body:Text('lñ'),
    );
  }

  Widget _createMap(Scan scan) {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: scan.getLatitud(),
        zoom: 5.0,
      ),
      layers: [
        _createMapLayer(),
        _createMarkers(scan),
      ],
    );
  }

  TileLayerOptions _createMapLayer() {
    return TileLayerOptions(
      urlTemplate: 'https://api.mapbox.com/v4/'
          '{id}/{z}/{x}/{y}@2x.png?access_token={acessToken}',
      additionalOptions: {
        'acessToken':
            'pk.eyJ1IjoiZ2FicmllbHgiLCJhIjoiY2s4bmhtemh3MHEwcjNucWNtNXM2dGc5OCJ9.1GuZ9Na4G7TtbZprcEATwA',
        'id': 'mapbox.$_mapType',
        // streets, dark,light, outdoors, satellite
      },
    );
  }

  MarkerLayerOptions _createMarkers(Scan scan) {
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 120.0,
          height: 120.0,
          point: scan.getLatitud(),
          builder: (BuildContext context) => Container(
            child: Icon(
              Icons.location_on,
              size: 70.0,
              color: Theme.of(context).primaryColor,
            ),
          ),
        )
      ],
    );
  }

  Widget _createFloatButton(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.repeat),
      shape: StadiumBorder(),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () {
        String mapType = '';
        switch (_mapType) {
          case 'streets':
            mapType = 'dark';
            break;
          case 'dark':
            mapType = 'light';
            break;
          case 'light':
            mapType = 'outdoors';
            break;
          case 'outdoors':
            mapType = 'satellite';
            break;
          default:
            mapType = 'streets';
            break;
        }
        setState(() {
          _mapType = mapType;
        });
      },
    );
  }
}
