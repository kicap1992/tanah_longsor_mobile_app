import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tanah_longsor_app/src/provider/maps_provider.dart';

class ListAlatPage extends StatefulWidget {
  const ListAlatPage({Key? key}) : super(key: key);

  @override
  State<ListAlatPage> createState() => _ListAlatPageState();
}

class _ListAlatPageState extends State<ListAlatPage> {
  late MapsProvider mapsProvider;

  @override
  void initState() {
    super.initState();
    mapsProvider = Provider.of<MapsProvider>(context, listen: false);
    mapsProvider.getMarkers();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          const Align(
            alignment: Alignment.center,
            child: Text(
              'List Alat',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Text('List Alat'),
          if (mapsProvider.isLoading == false) const Text("Error Loading"),
          if (mapsProvider.isLoading == true)
            if (mapsProvider.markerModels.isEmpty)
              const Text('Tidak ada alat yang tersedia'),
          if (mapsProvider.isLoading == true)
            if (mapsProvider.markerModels.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: mapsProvider.markerModels.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      child: ListTile(
                        title: Text(
                          "ID  : ${mapsProvider.markerModels[index].sId ?? ''}",
                        ),
                        subtitle: Text(
                          "Status : ${mapsProvider.markerModels[index].status ?? ''}",
                        ),
                        onTap: () {},
                      ),
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }
}
