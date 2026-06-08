import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/parking_slot_model.dart';

class DatabaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ==========================
  // STREAM DAFTAR MALL
  // ==========================
  Stream<List<MallModel>> streamMalls() {
    return _db.collection('malls').snapshots().map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            return MallModel.fromMap(
              doc.data(),
              doc.id,
            );
          },
        ).toList();
      },
    );
  }

  // ==========================
  // STREAM SLOT PARKIR
  // ==========================
  Stream<List<ParkingSlotModel>> streamSlotsForMall(
    String mallId,
  ) {
    return _db
        .collection('malls')
        .doc(mallId)
        .collection('slots')
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map(
          (doc) {
            return ParkingSlotModel.fromMap(
              doc.data(),
              doc.id,
            );
          },
        ).toList();
      },
    );
  }

  // ==========================
  // BOOK SLOT
  // ==========================
  Future<void> bookSlot(
    String mallId,
    String slotId,
    String userId,
  ) async {
    WriteBatch batch = _db.batch();

    DocumentReference slotRef = _db
        .collection('malls')
        .doc(mallId)
        .collection('slots')
        .doc(slotId);

    DocumentReference bookingRef =
        _db.collection('bookings').doc();

    DocumentReference mallRef =
        _db.collection('malls').doc(mallId);

    batch.update(
      slotRef,
      {
        'isAvailable': false,
      },
    );

    batch.set(
      bookingRef,
      {
        'userId': userId,
        'mallId': mallId,
        'slotId': slotId,
        'bookingTime':
            FieldValue.serverTimestamp(),
        'status': 'Active',
      },
    );

    batch.update(
      mallRef,
      {
        'availableSlots':
            FieldValue.increment(-1),
      },
    );

    await batch.commit();
  }
}