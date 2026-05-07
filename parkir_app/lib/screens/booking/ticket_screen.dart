import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart'; // Pustaka untuk QR Code asli
import 'package:google_fonts/google_fonts.dart'; // Untuk tipografi premium
import 'package:intl/intl.dart'; // Untuk format tanggal yang rapi

class TicketScreen extends StatelessWidget {
  final String mallName;
  final String slotNumber;
  final String ticketId;

  const TicketScreen({
    super.key,
    required this.mallName,
    required this.slotNumber,
    required this.ticketId,
  });

  @override
  Widget build(BuildContext context) {
    // Format tanggal saat ini (contoh: 07 Mei 2026)
    String formattedDate = DateFormat('dd MMM yyyy').format(DateTime.now());
    String formattedTime = DateFormat('HH:mm').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: Text("E-Tiket Parkir", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30.0),
          child: Column(
            children: [
              // KARTU TIKET UTAMA
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    // BAGIAN ATAS TIKET
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.check_circle_rounded, color: Colors.green, size: 48),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Booking Berhasil!",
                            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Silakan scan kode di bawah saat tiba",
                            style: GoogleFonts.poppins(color: Colors.grey, fontSize: 13),
                          ),
                        ],
                      ),
                    ),

                    // GARIS PEMISAH (EFEK SOBEKAN TIKET)
                    Row(
                      children: [
                        const SizedBox(width: -10, child: CircleAvatar(radius: 10, backgroundColor: Color(0xFFF0F4F8))),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                return Flex(
                                  direction: Axis.horizontal,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: List.generate(
                                    (constraints.constrainWidth() / 10).floor(),
                                    (index) => const SizedBox(width: 5, height: 1, child: DecoratedBox(decoration: BoxDecoration(color: Colors.grey))),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: -10, child: CircleAvatar(radius: 10, backgroundColor: Color(0xFFF0F4F8))),
                      ],
                    ),

                    // BAGIAN DETAIL INFO
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          _buildTicketRow("Lokasi Mall", mallName),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(child: _buildTicketRow("Slot Parkir", slotNumber)),
                              Expanded(child: _buildTicketRow("ID Tiket", ticketId)),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(child: _buildTicketRow("Tanggal", formattedDate)),
                              Expanded(child: _buildTicketRow("Jam Masuk", formattedTime)),
                            ],
                          ),
                          const SizedBox(height: 30),

                          // QR CODE GENERATOR (MENGGUNAKAN DATA ASLI)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey[200]!),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: QrImageView(
                              data: "ID:$ticketId|Mall:$mallName|Slot:$slotNumber",
                              version: QrVersions.auto,
                              size: 180.0,
                              gapless: false,
                              embeddedImage: const NetworkImage('https://cdn-icons-png.flaticon.com/512/2991/2991201.png'), // Opsional: Logo parkir kecil di tengah QR
                              embeddedImageStyle: const QrEmbeddedImageStyle(size: Size(30, 30)),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            ticketId,
                            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey, letterSpacing: 2),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // TOMBOL AKSI
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
                icon: const Icon(Icons.home_rounded),
                label: const Text("Selesai & Kembali"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  // Tambahkan fungsi download/share tiket jika perlu nanti
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Tiket telah disimpan di riwayat pesanan.")),
                  );
                },
                child: Text(
                  "Unduh Bukti Reservasi",
                  style: GoogleFonts.poppins(color: Colors.blueAccent, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTicketRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.poppins(color: Colors.grey, fontSize: 11)),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}