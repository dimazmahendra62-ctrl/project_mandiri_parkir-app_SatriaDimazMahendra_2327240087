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

  void _saveProfile() async {
    if (user == null) return;
    setState(() => _isSaving = true);

    try {
      await FirebaseFirestore.instance.collection('users').doc(user!.uid).update({
        'name': _nameController.text.trim(),
        'vehiclePlate': _plateController.text.trim().toUpperCase(),
      });
      setState(() => _isEditing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profil & Kendaraan berhasil diperbarui!")),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memperbarui: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil Pengguna"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authService.signOut(),
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text("Pengguna tidak ditemukan"))
          : StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance.collection('users').doc(user!.uid).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text("Gagal mengambil data profil"));
                }

                final userData = snapshot.data!.data() as Map<String, dynamic>;
                if (!_isEditing) {
                  _nameController.text = userData['name'] ?? '';
                  _plateController.text = userData['vehiclePlate'] ?? '';
                }

                final email = userData['email'] ?? 'Tidak ada email';

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blueAccent,
                        child: Icon(Icons.person, size: 50, color: Colors.white),
                      ),
                      const SizedBox(height: 24),
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.email, color: Colors.blueAccent),
                                title: const Text("Email"),
                                subtitle: Text(email),
                              ),
                              const Divider(),
                              
                              // Mode Edit atau Mode Tampil biasa
                              _isEditing
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                                      child: Column(
                                        children: [
                                          TextField(
                                            controller: _nameController,
                                            decoration: const InputDecoration(labelText: "Nama Lengkap"),
                                          ),
                                          const SizedBox(height: 8),
                                          TextField(
                                            controller: _plateController,
                                            decoration: const InputDecoration(labelText: "Plat Nomor Kendaraan"),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        ListTile(
                                          leading: const Icon(Icons.badge, color: Colors.blueAccent),
                                          title: const Text("Nama Lengkap"),
                                          subtitle: Text(_nameController.text, style: const TextStyle(fontWeight: FontWeight.bold)),
                                        ),
                                        const Divider(),
                                        ListTile(
                                          leading: const Icon(Icons.directions_car, color: Colors.blueAccent),
                                          title: const Text("Plat Nomor Kendaraan"),
                                          subtitle: _plateController.text.isEmpty
                                              ? const Text("Belum mendaftarkan kendaraan", style: TextStyle(color: Colors.red))
                                              : Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black12,
                                                    borderRadius: BorderRadius.circular(4),
                                                  ),
                                                  child: Text(
                                                    _plateController.text,
                                                    style: const TextStyle(
                                                      fontFamily: 'monospace',
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _isSaving
                          ? const CircularProgressIndicator()
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_isEditing) ...[
                                  ElevatedButton(
                                    onPressed: _saveProfile,
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                    child: const Text("Simpan", style: TextStyle(color: Colors.white)),
                                  ),
                                  const SizedBox(width: 16),
                                  OutlinedButton(
                                    onPressed: () => setState(() => _isEditing = false),
                                    child: const Text("Batal"),
                                  ),
                                ] else
                                  ElevatedButton.icon(
                                    onPressed: () => setState(() => _isEditing = true),
                                    icon: const Icon(Icons.edit, color: Colors.white),
                                    label: const Text("Kelola Data Kendaraan", style: TextStyle(color: Colors.white)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blueAccent,
                                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    ),
                                  ),
                              ],
                            ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}