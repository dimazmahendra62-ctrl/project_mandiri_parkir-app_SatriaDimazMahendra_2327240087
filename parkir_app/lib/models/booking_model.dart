import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String id;
  final String userId;
  final String mallId;
  final String mallName;
  final String slotId;
  final String slotName;
  final String vehiclePlate;
  final String status;
  final DateTime bookingTime;

  BookingModel({
    required this.id,
    required this.userId,
    required this.mallId,
    required this.mallName,
    required this.slotId,
    required this.slotName,
    required this.vehiclePlate,
    required this.status,
    required this.bookingTime,
  });

  factory BookingModel.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return BookingModel(
      id: id,
      userId: map['userId'] ?? '',
      mallId: map['mallId'] ?? '',
      mallName: map['mallName'] ?? '',
      slotId: map['slotId'] ?? '',
      slotName: map['slotName'] ?? '',
      vehiclePlate: map['vehiclePlate'] ?? '',
      status: map['status'] ?? 'Active',
      bookingTime:
          (map['bookingTime'] as Timestamp?)?.toDate() ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'mallId': mallId,
      'mallName': mallName,
      'slotId': slotId,
      'slotName': slotName,
      'vehiclePlate': vehiclePlate,
      'status': status,
      'bookingTime': bookingTime,
    };
  }
}