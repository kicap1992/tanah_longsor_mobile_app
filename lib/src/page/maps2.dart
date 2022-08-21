import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tanah_longsor_app/src/provider/maps_provider.dart';

class Map2Page extends StatelessWidget {
  const Map2Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition:
          context.watch<MapsProvider>().initialCameraPosition,
      onMapCreated: context.watch<MapsProvider>().onMapCreated,
      markers: context.watch<MapsProvider>().markers,
      circles: context.watch<MapsProvider>().circles,
    );
  }
}
