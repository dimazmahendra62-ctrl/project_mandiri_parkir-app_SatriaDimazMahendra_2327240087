import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../models/parkir_model.dart';
import '../services/firestore_service.dart';

class TambahScreen extends StatefulWidget {
  const TambahScreen({super.key});

  @override
  State<TambahScreen> createState() =>
      _TambahScreenState();
}

class _TambahScreenState
    extends State<TambahScreen> {

  final lokasi =
  TextEditingController();

  final kapasitas =
  TextEditingController();

  final tersedia =
  TextEditingController();

  final service =
  FirestoreService();

  double latitude = 0.0;
  double longitude = 0.0;

  Future<void> getLocation() async {

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled =
    await Geolocator
        .isLocationServiceEnabled();

    if (!serviceEnabled) {
      return;
    }

    permission =
    await Geolocator.checkPermission();

    if (permission ==
        LocationPermission.denied) {

      permission =
      await Geolocator
          .requestPermission();
    }

    Position position =
    await Geolocator.getCurrentPosition(
      desiredAccuracy:
      LocationAccuracy.high,
    );

    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:
        const Text("Tambah Data"),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding:
          const EdgeInsets.all(20),

          child: Column(
            children: [

              TextField(
                controller: lokasi,
                decoration:
                const InputDecoration(
                  labelText: "Lokasi",
                ),
              ),

              TextField(
                controller: kapasitas,
                keyboardType:
                TextInputType.number,

                decoration:
                const InputDecoration(
                  labelText: "Kapasitas",
                ),
              ),

              TextField(
                controller: tersedia,
                keyboardType:
                TextInputType.number,

                decoration:
                const InputDecoration(
                  labelText:
                  "Slot Tersedia",
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {
                  await getLocation();
                },

                child: const Text(
                  "Ambil Latitude Longitude",
                ),
              ),

              const SizedBox(height: 20),

              Text("Latitude : $latitude"),
              Text("Longitude : $longitude"),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () async {

                  String status =
                  service.getStatus(
                    int.parse(
                        kapasitas.text),
                    int.parse(
                        tersedia.text),
                  );

                  ParkirModel data =
                  ParkirModel(
                    id: '',
                    lokasi: lokasi.text,
                    kapasitas:
                    int.parse(
                        kapasitas.text),
                    tersedia:
                    int.parse(
                        tersedia.text),
                    status: status,
                    latitude: latitude,
                    longitude: longitude,
                  );

                  await service
                      .tambahData(data);

                  ScaffoldMessenger.of(
                      context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Data berhasil disimpan"),
                    ),
                  );

                  Navigator.pop(context);
                },

                child:
                const Text("Simpan"),
              )
            ],
          ),
        ),
      ),
    );
  }
}