import 'package:latlong/latlong.dart';

class Scan {
  int id;
  String type;
  String value;

  Scan({
    this.id,
    this.type,
    this.value,
  }) {
    if (this.value.contains('http')) {
      this.type = 'http';
    } else {
      this.type = 'geo';
    }
  }

  getLatitud() {
    final lalo = value.substring(4).split(',');
    final lat = double.parse(lalo[0]);
    final lng = double.parse(lalo[0]);
    return LatLng(lat, lng);
  }

  factory Scan.fromJson(Map<String, dynamic> json) => Scan(
        id: json["id"],
        type: json["type"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "value": value,
      };
}
