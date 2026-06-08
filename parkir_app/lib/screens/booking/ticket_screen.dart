import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
    final now = DateTime.now();

    String date =
        DateFormat('dd MMM yyyy').format(now);

    String time =
        DateFormat('HH:mm').format(now);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Text(
          "E-Ticket",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            /// SUCCESS ICON
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              "Booking Berhasil",
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              "Tunjukkan QR Code saat memasuki area parkir",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 25),

            /// TICKET CARD
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),

              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  children: [

                    /// MALL
                    _buildInfo(
                      "Mall",
                      mallName,
                      Icons.location_city,
                    ),

                    const Divider(height: 30),

                    /// SLOT
                    _buildInfo(
                      "Slot Parkir",
                      slotNumber,
                      Icons.local_parking,
                    ),

                    const Divider(height: 30),

                    /// TANGGAL
                    _buildInfo(
                      "Tanggal",
                      date,
                      Icons.calendar_month,
                    ),

                    const Divider(height: 30),

                    /// JAM
                    _buildInfo(
                      "Jam Masuk",
                      time,
                      Icons.access_time,
                    ),

                    const Divider(height: 30),

                    /// ID
                    _buildInfo(
                      "ID Tiket",
                      ticketId,
                      Icons.confirmation_number,
                    ),

                    const SizedBox(height: 25),

                    QrImageView(
                      data:
                          "$ticketId-$mallName-$slotNumber",
                      size: 220,
                    ),

                    const SizedBox(height: 15),

                    Text(
                      ticketId,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.home),
                label: const Text(
                  "Kembali ke Beranda",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  Navigator.popUntil(
                    context,
                    (route) => route.isFirst,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(
    String title,
    String value,
    IconData icon,
  ) {
    return Row(
      children: [
        CircleAvatar(
          backgroundColor:
              const Color(0xFF2563EB).withOpacity(0.1),
          child: Icon(
            icon,
            color: const Color(0xFF2563EB),
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),

              Text(
                value,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}