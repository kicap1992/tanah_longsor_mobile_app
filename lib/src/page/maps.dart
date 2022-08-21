import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';

import '../model/base_response.dart';
import '../model/marker_model.dart';
import '../service/api.dart';
import '../service/socket_io.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final logger = Logger();
  final socket = MySocketIO();
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(-4.006971153905515, 119.63025053884449),
    zoom: 11,
  );

  final Set<Marker> _markers = HashSet<Marker>();
  final Set<Circle> _circles = HashSet<Circle>();

  void _getMarkers(BuildContext context) async {
    BaseResponse baseResponse = await ApiService.getAllMarker();
    // logger.i(baseResponse.data);
    if (baseResponse.status) {
      if (mounted) {
        baseResponse.data.forEach((element) {
          MarkerModel markerModel = MarkerModel.fromJson(element);
          late double icon;
          switch (markerModel.status) {
            case "Normal":
              icon = BitmapDescriptor.hueBlue;
              break;
            case "Warning":
              icon = BitmapDescriptor.hueYellow;
              break;
            case "Danger":
              icon = BitmapDescriptor.hueOrange;
              break;
            case "Danger Area":
              icon = BitmapDescriptor.hueRed;
              break;
          }
          setState(() {
            _markers.add(
              Marker(
                icon: BitmapDescriptor.defaultMarkerWithHue(icon),
                markerId: MarkerId(markerModel.sId!),
                position: LatLng(double.parse(markerModel.lat!),
                    double.parse(markerModel.lng!)),
                infoWindow: InfoWindow(
                  title: markerModel.sId,
                  snippet: markerModel.status,
                ),
              ),
            );
          });
        });
      }
    } else {
      logger.e(baseResponse.message);
    }
  }

  @override
  void initState() {
    super.initState();
    _getMarkers(context);
    // socket.on('hehe', (data) {
    //   logger.i(data);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: _initialCameraPosition,
      onMapCreated: _onMapCreated,
      markers: _markers,
      circles: _circles,
    );
  }

  void _onMapCreated(GoogleMapController controller) {}
}
