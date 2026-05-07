import 'package:flutter/material.dart';
import '../../services/database_service.dart';
import '../../models/parking_slot_model.dart';
import '../favorite/favorite_screen.dart';
import '../profile/profile_screen.dart';
import '../booking/booking_screen.dart'; // Mengarah ke ParkingDetailScreen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ParkingMonitoringWidget(), 
    const FavoriteScreen(),          
    const ProfileScreen(),           
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.local_parking), label: 'Beranda'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favorit'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }
}

class ParkingMonitoringWidget extends StatefulWidget {
  const ParkingMonitoringWidget({super.key});

  @override
  State<ParkingMonitoringWidget> createState() => _ParkingMonitoringWidgetState();
}

class _ParkingMonitoringWidgetState extends State<ParkingMonitoringWidget> {
  final DatabaseService _dbService = DatabaseService();
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cari Tempat Parkir", style: TextStyle(fontWeight: FontWeight.bold)),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Kolom Pencarian Mall
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
              decoration: InputDecoration(
                hintText: "Cari Mall (misal: PTC Mall)...",
                prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          
          // List Mall dari Firestore (dengan Dummy Fallback)
          Expanded(
            child: StreamBuilder<List<MallModel>>(
              stream: _dbService.streamMalls(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                // Ambil data dari Firestore, jika kosong pakai data dummy lokal untuk simulasi
                List<MallModel> malls = snapshot.data ?? [];
                
                if (malls.isEmpty) {
                  malls = [
                    MallModel(
                      id: 'ptc_mall_dummy',
                      name: 'PTC Mall',
                      address: 'Jl. R. Sukamto No.8A, Palembang',
                      totalSlots: 1000,
                      availableSlots: 10, // 10/1000 = 0.01 (Memicu status "Hampir Penuh" berwarna merah)
                    ),
                    MallModel(
                      id: 'palembang_icon_dummy',
                      name: 'Palembang Icon',
                      address: 'Jl. POM IX, Palembang',
                      totalSlots: 800,
                      availableSlots: 200, // 200/800 = 0.25 (Memicu status "Ramai" berwarna orange)
                    ),
                    MallModel(
                      id: 'palembang_indah_mall_dummy',
                      name: 'Palembang Indah Mall',
                      address: 'Jl. Letkol Iskandar No.18, Palembang',
                      totalSlots: 600,
                      availableSlots: 450, // 450/600 = 0.75 (Memicu status "Tersedia" berwarna hijau)
                    ),
                  ];
                }

                // Filter data berdasarkan input pencarian user secara realtime
                final filteredMalls = malls.where((mall) {
                  return mall.name.toLowerCase().contains(_searchQuery);
                }).toList();

                if (filteredMalls.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Text(
                        "Mall tidak ditemukan atau data kosong.",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredMalls.length,
                  itemBuilder: (context, index) {
                    final mall = filteredMalls[index];
                    
                    // Logika Penghitungan Status Ketersediaan Sesuai Kriteria Persentase
                    double ratio = mall.availableSlots / mall.totalSlots;
                    String statusText = "Tersedia";
                    Color statusColor = Colors.green;

                    if (ratio <= 0.1) {
                      statusText = "Hampir Penuh";
                      statusColor = Colors.red;
                    } else if (ratio <= 0.3) {
                      statusText = "Ramai";
                      statusColor = Colors.orange;
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: InkWell(
                        onTap: () {
                          // Membuka Halaman Detail Grid Slot Parkir
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ParkingDetailScreen(mall: mall),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              // Icon Gedung / Mall
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(Icons.business, size: 35, color: Colors.blueAccent),
                              ),
                              const SizedBox(width: 16),
                              
                              // Detail Informasi Mall (Nama & Alamat)
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      mall.name,
                                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      mall.address,
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    
                                    // Row Indikator Status & Angka Slot
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: statusColor.withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: Text(
                                            statusText,
                                            style: TextStyle(
                                              color: statusColor, 
                                              fontWeight: FontWeight.bold, 
                                              fontSize: 11,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "${mall.availableSlots}/${mall.totalSlots} Slot",
                                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
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