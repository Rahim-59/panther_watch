import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up with email and password
  static Future<User?> signUp(String email, String password, String username, LatLng location) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      // Save additional user information in Firestore
      await _firestore.collection('users').doc(user!.uid).set({
        'username': username,
        'email': email,
        'type': 'user',
        'latitude': location.latitude,
        'longitude': location.longitude,
      });
      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Login with email and password
  static Future<User?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      throw Exception(e);
    }
  }

  // Check if user is logged in
  static User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Get user details
  static Future<Map<String, dynamic>?> getUserDetails() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
        return doc.data() as Map<String, dynamic>?;
      }
    } catch (e) {
      throw Exception(e);
    }
    return null;
  }

  // Logout
  static Future<void> logout() async {
    await _auth.signOut();
  }
}
