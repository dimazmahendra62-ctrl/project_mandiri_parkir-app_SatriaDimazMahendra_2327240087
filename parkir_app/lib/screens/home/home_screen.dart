import 'package:flutter/material.dart';

import '../../models/parking_slot_model.dart';
import '../../services/database_service.dart';

import '../booking/booking_screen.dart';
import '../favorite/favorite_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    ParkingMonitoringWidget(),
    FavoriteScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: const Color(0xFF2563EB),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: "Beranda",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: "Favorit",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: "Profil",
          ),
        ],
      ),
    );
  }
}

class ParkingMonitoringWidget extends StatefulWidget {
  const ParkingMonitoringWidget({super.key});

  @override
  State<ParkingMonitoringWidget> createState() =>
      _ParkingMonitoringWidgetState();
}

class _ParkingMonitoringWidgetState
    extends State<ParkingMonitoringWidget> {
  final DatabaseService _dbService = DatabaseService();

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Parking"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF2563EB),
                  Color(0xFF3B82F6),
                ],
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Temukan Slot Parkir",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Pantau ketersediaan parkir secara real-time",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // SEARCH
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Cari mall...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Expanded(
            child: StreamBuilder<List<MallModel>>(
              stream: _dbService.streamMalls(),
              builder: (context, snapshot) {
                List<MallModel> malls = snapshot.data ?? [];

                // Dummy data jika firestore kosong
                if (malls.isEmpty) {
                  malls = [
                    MallModel(
                      id: "1",
                      name: "PTC Mall",
                      address: "Palembang",
                      totalSlots: 1000,
                      availableSlots: 120,
                    ),
                    MallModel(
                      id: "2",
                      name: "Palembang Icon",
                      address: "Palembang",
                      totalSlots: 800,
                      availableSlots: 300,
                    ),
                    MallModel(
                      id: "3",
                      name: "PIM",
                      address: "Palembang",
                      totalSlots: 600,
                      availableSlots: 50,
                    ),
                  ];
                }

                final filtered = malls.where((mall) {
                  return mall.name
                      .toLowerCase()
                      .contains(searchQuery);
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text(
                      "Mall tidak ditemukan",
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final mall = filtered[index];

                    double ratio = mall.totalSlots > 0
                        ? mall.availableSlots / mall.totalSlots
                        : 0;

                    Color statusColor;
                    String statusText;

                    if (ratio <= 0.1) {
                      statusColor = Colors.red;
                      statusText = "Hampir Penuh";
                    } else if (ratio <= 0.3) {
                      statusColor = Colors.orange;
                      statusText = "Ramai";
                    } else {
                      statusColor = Colors.green;
                      statusText = "Tersedia";
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ParkingDetailScreen(mall: mall),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Row(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius:
                                      BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.local_parking,
                                  color: Color(0xFF2563EB),
                                  size: 36,
                                ),
                              ),

                              const SizedBox(width: 16),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      mall.name,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    const SizedBox(height: 4),

                                    Text(
                                      mall.address,
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    Row(
                                      children: [
                                        Container(
                                          padding:
                                              const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: statusColor
                                                .withOpacity(0.15),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            statusText,
                                            style: TextStyle(
                                              color: statusColor,
                                              fontWeight:
                                                  FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          "${mall.availableSlots}/${mall.totalSlots} Slot",
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ),
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