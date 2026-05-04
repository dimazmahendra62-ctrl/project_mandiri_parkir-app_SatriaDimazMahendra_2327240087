import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/parkir_model.dart';

class FirestoreService {

  final CollectionReference parkir =
      FirebaseFirestore.instance.collection('parkir');

  String getStatus(int kapasitas, int tersedia) {

    if (tersedia == 0) {
      return "Penuh";
    } else if (tersedia <= kapasitas * 0.2) {
      return "Hampir Penuh";
    } else {
      return "Tersedia";
    }
  }

  Future<void> tambahData(ParkirModel data) async {
    await parkir.add(data.toMap());
  }

  Stream<QuerySnapshot> getData() {
    return parkir.snapshots();
  }
}