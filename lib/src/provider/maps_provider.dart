import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
import 'package:tanah_longsor_app/src/service/socket_io.dart';

import '../model/base_response.dart';
import '../model/marker_model.dart';
import '../service/api.dart';

class MapsProvider extends ChangeNotifier {
  MapsProvider() {
    // socketIO.on('notif_to_phone', (data) {
    //   // logger.i(data);
    //   changeMarkerStyle(data['id']);
    // });
    getMarkers();
    // notifyListeners();
  }

  final socketIO = MySocketIO();
  final logger = Logger();

  final _initialCameraPosition = const CameraPosition(
    target: LatLng(-4.006971153905515, 119.63025053884449),
    zoom: 11,
  );

  get initialCameraPosition => _initialCameraPosition;

  final Set<Marker> _markers = HashSet<Marker>();
  final Set<Circle> _circles = HashSet<Circle>();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final List<MarkerModel> _markerModels = [];
  List<MarkerModel> get markerModels => _markerModels;

  Set<Marker> get markers => _markers;
  Set<Circle> get circles => _circles;

  void getMarkers() async {
    BaseResponse baseResponse = await ApiService.getAllMarker();
    logger.i(baseResponse.data);
    _markerModels.clear();
    _markers.clear();
    if (baseResponse.status) {
      // _markers
      //     .removeWhere((element) => element.markerId.value == '8C3C4CBD9E7C');
      baseResponse.data.forEach((element) {
        _markerModels.add(MarkerModel.fromJson(element));
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
          case "calibration":
            icon = BitmapDescriptor.hueBlue;
            break;
        }

        _markers.add(
          Marker(
            icon: BitmapDescriptor.defaultMarkerWithHue(icon),
            markerId: MarkerId(markerModel.sId!),
            position: LatLng(
                double.parse(markerModel.lat!), double.parse(markerModel.lng!)),
            infoWindow: InfoWindow(
              title: markerModel.sId,
              snippet: markerModel.status,
            ),
          ),
        );
      });
      _isLoading = true;
      logger.i(_markers);
    } else {
      logger.e(baseResponse.message);
      _isLoading = false;
    }
    // notifyListeners();merah hitam coklat ungu

    notifyListeners();
  }

  void changeMarkerStyle(
      String id, String status, String lat, String lng) async {
    logger.i("ini berlaku");
    late double icon;
    switch (status) {
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
    // search in _markers with markerId= '8C3C4CBD9E7C' and delete it
    _markers.removeWhere((element) => element.markerId.value == id);
    _markers.add(
      Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(icon),
        markerId: MarkerId(id),
        position: LatLng(double.parse(lat), double.parse(lng)),
        infoWindow: InfoWindow(
          title: id,
          snippet: status,
        ),
      ),
    );
    logger.i(_markers);
    notifyListeners();
  }

  void onMapCreated(GoogleMapController controller) {}
}
