import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


Future<Map<String, dynamic>> getUserData(String userId) async {
  try {
    DocumentSnapshot userSnapshot =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (userSnapshot.exists) {
      // User data exists, return it as a map
      Map<String, dynamic> userData = userSnapshot.data() as Map<String, dynamic>;
      return userData;
    } else {
      // User data not found
      return {};
    }
  } catch (e) {
    print('Error retrieving user data: $e');
    return {};
  }
}