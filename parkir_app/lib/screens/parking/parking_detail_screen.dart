import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/parking_slot_model.dart';
import '../../services/database_service.dart';
import '../../widgets/parking_slot_card.dart';

class ParkingDetailScreen extends StatelessWidget {
  final MallModel mall;

  const ParkingDetailScreen({
    super.key,
    required this.mall,
  });

  @override
  Widget build(BuildContext context) {
    final DatabaseService dbService = DatabaseService();
    final User? user = FirebaseAuth.instance.currentUser;

    double occupancy =
        ((mall.totalSlots - mall.availableSlots) /
                mall.totalSlots)
            .clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),

      body: Column(
        children: [

          // HEADER PREMIUM
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 55,
              left: 20,
              right: 20,
              bottom: 25,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xff2563EB),
                  Color(0xff1E40AF),
                ],
              ),
            ),
            child: Column(
              children: [

                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                      ),
                    ),

                    Expanded(
                      child: Text(
                        mall.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(width: 48),
                  ],
                ),

                const SizedBox(height: 10),

                Text(
                  mall.address,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 25),

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [

                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Ketersediaan Slot",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),

                          Text(
                            "${mall.availableSlots}/${mall.totalSlots}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: occupancy,
                          minHeight: 10,
                          backgroundColor:
                              Colors.white24,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [

                Expanded(
                  child: _buildInfoCard(
                    "Tersedia",
                    "${mall.availableSlots}",
                    Colors.green,
                    Icons.check_circle,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _buildInfoCard(
                    "Terisi",
                    "${mall.totalSlots - mall.availableSlots}",
                    Colors.red,
                    Icons.car_rental,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Pilih Slot Parkir",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: StreamBuilder<List<ParkingSlotModel>>(
              stream:
                  dbService.streamSlotsForMall(mall.id),
              builder: (context, snapshot) {

                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                    ),
                  );
                }

                final slots =
                    snapshot.data ?? [];

                if (slots.isEmpty) {
                  return const Center(
                    child: Text(
                      "Belum ada data slot parkir",
                    ),
                  );
                }

                return GridView.builder(
                  padding:
                      const EdgeInsets.all(20),
                  itemCount: slots.length,

                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.9,
                  ),

                  itemBuilder: (context, index) {

                    final slot = slots[index];

                    return ParkingSlotCard(
                      slot: slot,
                      onTap: () {

                        if (!slot.isAvailable) {

                          ScaffoldMessenger.of(context)
                              .showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Slot sudah terisi"),
                              backgroundColor:
                                  Colors.red,
                            ),
                          );

                          return;
                        }

                        _showBookingDialog(
                          context,
                          user,
                          dbService,
                          mall,
                          slot,
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

  static void _showBookingDialog(
    BuildContext context,
    User? user,
    DatabaseService dbService,
    MallModel mall,
    ParkingSlotModel slot,
  ) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),

          title: const Text(
            "Konfirmasi Booking",
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              const Icon(
                Icons.local_parking,
                size: 60,
                color: Colors.blue,
              ),

              const SizedBox(height: 15),

              Text(
                slot.slotName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                mall.name,
              ),
            ],
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Batal"),
            ),

            ElevatedButton(
              onPressed: () async {

                Navigator.pop(context);

                if (user != null) {

                  await dbService.bookSlot(
                    mall.id,
                    slot.id,
                    user.uid,
                  );

                  if (context.mounted) {

                    ScaffoldMessenger.of(context)
                        .showSnackBar(
                      SnackBar(
                        content: Text(
                          "Slot ${slot.slotName} berhasil dipesan",
                        ),
                        backgroundColor:
                            Colors.green,
                      ),
                    );
                  }
                }
              },
              child: const Text("Pesan"),
            ),
          ],
        );
      },
    );
  }

  static Widget _buildInfoCard(
    String title,
    String value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        children: [

          Icon(
            icon,
            color: color,
            size: 35,
          ),

          const SizedBox(height: 10),

          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(title),
        ],
      ),
    );
  }
}