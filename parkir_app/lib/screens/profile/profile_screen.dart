import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../services/auth_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final user = FirebaseAuth.instance.currentUser;
  final AuthService authService = AuthService();

  final _nameController = TextEditingController();
  final _plateController = TextEditingController();

  bool _isEditing = false;
  bool _isSaving = false;

  Future<void> _saveProfile() async {
    if (user == null) return;

    setState(() {
      _isSaving = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        'name': _nameController.text.trim(),
        'vehiclePlate': _plateController.text.trim().toUpperCase(),
      });

      setState(() {
        _isEditing = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profil berhasil diperbarui"),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error : $e")),
      );
    }

    if (mounted) {
      setState(() {
        _isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text("User tidak ditemukan"),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(
              child: Text("Data profil tidak ditemukan"),
            );
          }

          final data =
              snapshot.data!.data() as Map<String, dynamic>;

          if (!_isEditing) {
            _nameController.text = data['name'] ?? '';
            _plateController.text = data['vehiclePlate'] ?? '';
          }

          String name = data['name'] ?? '-';
          String email = data['email'] ?? '-';
          String plate = data['vehiclePlate'] ?? '';

          return SingleChildScrollView(
            child: Column(
              children: [

                // HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(
                    top: 60,
                    bottom: 35,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF2563EB),
                        Color(0xFF1E40AF),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(35),
                      bottomRight: Radius.circular(35),
                    ),
                  ),
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          size: 60,
                          color: Colors.blue.shade700,
                        ),
                      ),

                      const SizedBox(height: 15),

                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        email,
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [

                      // STATISTIK
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatCard(
                              "Akun",
                              "Aktif",
                              Icons.verified_user,
                              Colors.green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatCard(
                              "Kendaraan",
                              plate.isEmpty ? "0" : "1",
                              Icons.directions_car,
                              Colors.orange,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // DATA USER
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [

                              _buildInfoTile(
                                Icons.email,
                                "Email",
                                email,
                              ),

                              const Divider(),

                              _isEditing
                                  ? Column(
                                      children: [

                                        TextField(
                                          controller:
                                              _nameController,
                                          decoration:
                                              const InputDecoration(
                                            labelText:
                                                "Nama Lengkap",
                                            prefixIcon:
                                                Icon(Icons.person),
                                          ),
                                        ),

                                        const SizedBox(height: 15),

                                        TextField(
                                          controller:
                                              _plateController,
                                          decoration:
                                              const InputDecoration(
                                            labelText:
                                                "Plat Kendaraan",
                                            prefixIcon:
                                                Icon(Icons.car_rental),
                                          ),
                                        ),
                                      ],
                                    )
                                  : Column(
                                      children: [

                                        _buildInfoTile(
                                          Icons.person,
                                          "Nama Lengkap",
                                          name,
                                        ),

                                        const Divider(),

                                        _buildInfoTile(
                                          Icons.directions_car,
                                          "Plat Kendaraan",
                                          plate.isEmpty
                                              ? "Belum Terdaftar"
                                              : plate,
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      _isSaving
                          ? const CircularProgressIndicator()
                          : _isEditing
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed:
                                            _saveProfile,
                                        style:
                                            ElevatedButton
                                                .styleFrom(
                                          backgroundColor:
                                              Colors.green,
                                          padding:
                                              const EdgeInsets
                                                  .all(15),
                                        ),
                                        child: const Text(
                                          "Simpan",
                                          style: TextStyle(
                                            color:
                                                Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child:
                                          OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            _isEditing =
                                                false;
                                          });
                                        },
                                        child:
                                            const Text("Batal"),
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      "Edit Profil",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    style:
                                        ElevatedButton
                                            .styleFrom(
                                      backgroundColor:
                                          Colors.blue,
                                      padding:
                                          const EdgeInsets
                                              .all(15),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isEditing = true;
                                      });
                                    },
                                  ),
                                ),

                      const SizedBox(height: 15),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding:
                                const EdgeInsets.all(15),
                          ),
                          onPressed: () {
                            authService.signOut();
                          },
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoTile(
      IconData icon,
      String title,
      String value,
      ) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.blue,
      ),
      title: Text(title),
      subtitle: Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildStatCard(
      String title,
      String value,
      IconData icon,
      Color color,
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
            blurRadius: 8,
          )
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 30,
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(title),
        ],
      ),
    );
  }
}