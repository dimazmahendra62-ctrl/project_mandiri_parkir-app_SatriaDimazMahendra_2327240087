import 'package:firebase_auth/firebase_auth.dart'; // <--- Perubahan di sini
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream status login (untuk memantau apakah user sedang login/logout)
  Stream<User?> get userStream => _auth.authStateChanges();

  // Register Baru
  Future<User?> registerWithEmail(String email, String password, String name, String vehiclePlate) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;

      if (user != null) {
        // Simpan data tambahan ke Firestore
        await _db.collection('users').doc(user.uid).set({
          'email': email,
          'name': name,
          'vehiclePlate': vehiclePlate,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return user;
    } catch (e) {
      print("Error Register: ${e.toString()}");
      rethrow;
    }
  }

  // Login
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("Error Login: ${e.toString()}");
      rethrow;
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}