import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/parking_slot_model.dart';
import '../../services/database_service.dart';
import '../../widgets/parking_slot_card.dart';

class ParkingDetailScreen extends StatelessWidget {
  final MallModel mall;
  const ParkingDetailScreen({super.key, required this.mall});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final DatabaseService dbService = DatabaseService();

    return Scaffold(
      appBar: AppBar(
        title: Text(mall.name),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Banner Ringkasan Detail Mall
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.blueAccent.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.business, color: Colors.blueAccent, size: 28),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        mall.name,
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  mall.address,
                  style: const TextStyle(color: Colors.black54, fontSize: 14),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Kapasitas Slot Real-Time:",
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                    ),
                    Text(
                      "${mall.availableSlots} / ${mall.totalSlots} Tersedia",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Judul Area Grid
          const Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0, bottom: 8.0),
            child: Text(
              "Denah Grid Slot Parkir",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          
          // Bagian Grid Layout Slot Parkir
          Expanded(
            child: StreamBuilder<List<ParkingSlotModel>>(
              stream: dbService.streamSlotsForMall(mall.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }
                
                final slots = snapshot.data ?? [];
                
                if (slots.isEmpty) {
                  return const Center(
                    child: Text(
                      "Tidak ada slot parkir yang diatur di mall ini.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, // Menggunakan skema 3 kolom agar layout grid parkir presisi
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.0,
                  ),
                  itemCount: slots.length,
                  itemBuilder: (context, index) {
                    final slot = slots[index];
                    return ParkingSlotCard(
                      slot: slot,
                      onTap: () {
                        if (!slot.isAvailable) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Slot ini sudah dipesan atau terisi!"),
                              backgroundColor: Colors.redAccent,
                            ),
                          );
                          return;
                        }

                        // Tampilkan Dialog Konfirmasi Booking
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            title: Text("Pesan Slot ${slot.slotName}?"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Lokasi: ${mall.name}"),
                                const SizedBox(height: 4),
                                Text("Sektor: ${slot.floor}"),
                                const SizedBox(height: 12),
                                const Text(
                                  "Apakah Anda yakin ingin memesan slot parkir ini?",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Batal"),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                onPressed: () async {
                                  Navigator.pop(context);
                                  if (user != null) {
                                    await dbService.bookSlot(mall.id, slot.id, user.uid);
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text("Berhasil memesan ${slot.slotName}!"),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: const Text("Ya, Pesan", style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}