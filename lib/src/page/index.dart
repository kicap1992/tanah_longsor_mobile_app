// ignore_for_file: unnecessary_const

import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import '../provider/maps_provider.dart';
import '../service/notification_api.dart';
import '../service/socket_io.dart';
import 'list.dart';
import 'maps2.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({Key? key}) : super(key: key);

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  // final logger = Logger();
  int currentIndex = 0;
  final socketIO = MySocketIO();
  final logger = Logger();
  @override
  void initState() {
    super.initState();
    // context.read<MapsProvider>().getMarkers();
    socketIO.on('notif_to_phone', (data) {
      logger.i(data);
      context.read<MapsProvider>().changeMarkerStyle(
          data['id'], data['status'], data['lat'], data['lng']);

      if (data['status'] != 'Normal') {
        NotificationApi.showNotification(
          id: 1,
          title: 'Info',
          body: data['message'],
          payload: "Info Kemungkinan Bencana Tanah Longsor",
        );
      }
    });

    socketIO.on('reload_calibation', (data) {
      logger.i(data);
      context.watch<MapsProvider>().getMarkers();

      // if (data['status'] != 'Normal') {
      NotificationApi.showNotification(
        id: 2,
        title: 'Info',
        body: "Alat Baru Berhasil Di Calibrasi",
        payload: "Alat Baru Berhasil Di Calibrasi",
      );
      // }
    });
  }

  @override
  void dispose() {
    super.dispose();
    socketIO.disconnect();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: myWidget(context),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 234, 230, 230),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            label: 'List Lokasi',
          ),
        ],
        currentIndex: currentIndex,
        selectedItemColor: Colors.blue,
        onTap: (int index) {
          // logger.i('index: $index');
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }

  myWidget(BuildContext context) {
    switch (currentIndex) {
      case 0:
        // return const MapPage();
        return const Map2Page();
      case 1:
        return const ListAlatPage();
    }
  }
}
