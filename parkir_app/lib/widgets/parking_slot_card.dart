import 'package:flutter/material.dart';
import '../models/parking_slot_model.dart';

class ParkingSlotCard extends StatelessWidget {
  final ParkingSlotModel slot;
  final VoidCallback onTap;

  const ParkingSlotCard({
    super.key,
    required this.slot,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: slot.isAvailable ? Colors.green[50] : Colors.red[50],
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                slot.isAvailable ? Icons.local_parking : Icons.directions_car,
                color: slot.isAvailable ? Colors.green : Colors.red,
                size: 28,
              ),
              const SizedBox(height: 4),
              Text(
                slot.slotName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              Text(
                slot.floor,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}