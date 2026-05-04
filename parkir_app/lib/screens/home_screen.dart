import 'package:flutter/material.dart';

import 'tambah_screen.dart';
import 'list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Smart Parkir"),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const TambahScreen(),
                  ),
                );
              },

              child:
              const Text("Tambah Data"),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const ListScreen(),
                  ),
                );
              },

              child:
              const Text("Lihat Data"),
            ),
          ],
        ),
      ),
    );
  }
}