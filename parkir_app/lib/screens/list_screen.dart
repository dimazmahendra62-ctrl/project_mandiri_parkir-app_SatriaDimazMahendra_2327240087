import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListScreen extends StatelessWidget {
  const ListScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title:
        const Text("Data Parkir"),
      ),

      body:
      StreamBuilder<QuerySnapshot>(

        stream:
        FirebaseFirestore.instance
            .collection('parkir')
            .snapshots(),

        builder:
            (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {

            return const Center(
              child:
              CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.docs.isEmpty) {

            return const Center(
              child:
              Text("Belum ada data"),
            );
          }

          var data =
          snapshot.data!.docs;

          return ListView.builder(

            itemCount: data.length,

            itemBuilder:
                (context, index) {

              var item = data[index];

              return Card(
                child: ListTile(

                  title: Text(
                    item['lokasi']
                        .toString(),
                  ),

                  subtitle: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,

                    children: [

                      Text(
                        item['status']
                            .toString(),
                      ),

                      Text(
                        "Lat : ${item['latitude']}",
                      ),

                      Text(
                        "Long : ${item['longitude']}",
                      ),
                    ],
                  ),

                  trailing: Text(
                    "${item['tersedia']}/${item['kapasitas']}",
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}