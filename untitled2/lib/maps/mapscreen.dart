import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';

import 'package:untitled2/components/top_navbar.dart';

// void main() {
//   runApp(MyApp());
// }

class ShowMap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Polyline> _polylines = [];

  @override
  void initState() {
    super.initState();
    _loadGeoJsonData();
  }

  Future<void> _loadGeoJsonData() async {
    final String response = await rootBundle.loadString('assets/chennai_flood_data.geojson');
    final data = json.decode(response);
    setState(() {
      _polylines = _parseGeoJson(data);
    });
  }

  List<Polyline> _parseGeoJson(Map<String, dynamic> data) {
    final List<Polyline> polylines = [];

    for (var feature in data['features']) {
      final geometry = feature['geometry'];
      if (geometry['type'] == 'LineString') {
        final List<LatLng> points = [];
        for (var coord in geometry['coordinates']) {
          points.add(LatLng(coord[1], coord[0]));
        }
        polylines.add(Polyline(
          points: points,
          color: const Color.fromARGB(255, 8, 104, 182),
          strokeWidth: 3.0,
        ));
      }
    }
    return polylines;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(13.0827, 80.2707),
          initialZoom: 13,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          PolylineLayer(
            polylines: _polylines,
          ),
        ],
      ),
    );
  }
}
