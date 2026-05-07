class UserModel {
  final String uid;
  final String email;
  final String name;
  final String vehiclePlate;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    required this.vehiclePlate,
  });

  // Mengubah data dari Firestore (Map) ke Objek Dart
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      uid: id,
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      vehiclePlate: map['vehiclePlate'] ?? '',
    );
  }

  // Mengubah Objek Dart ke Map untuk disimpan di Firestore
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'vehiclePlate': vehiclePlate,
    };
  }
}