class MallModel {
  final String id;
  final String name;          
  final String address;       
  final int totalSlots;       
  final int availableSlots;   

  MallModel({
    required this.id,
    required this.name,
    required this.address,
    required this.totalSlots,
    required this.availableSlots,
  });

  factory MallModel.fromMap(Map<String, dynamic> map, String id) {
    return MallModel(
      id: id,
      name: map['name'] ?? '',
      address: map['address'] ?? '',
      totalSlots: map['totalSlots'] ?? 0,
      availableSlots: map['availableSlots'] ?? 0,
    );
  }
}

class ParkingSlotModel {
  final String id;
  final String slotName;     
  final bool isAvailable;
  final String floor;        

  ParkingSlotModel({
    required this.id,
    required this.slotName,
    required this.isAvailable,
    required this.floor,
  });

  factory ParkingSlotModel.fromMap(Map<String, dynamic> map, String id) {
    return ParkingSlotModel(
      id: id,
      slotName: map['slotName'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      floor: map['floor'] ?? 'Lantai G',
    );
  }
}