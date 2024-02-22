import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> moveRideToFirestoreHistory(String userId, String rideId, Map<String, dynamic> rideData) async {
  try {
    // Access Firestore collection and document references
    CollectionReference historyCollection = FirebaseFirestore.instance.collection('history');
    DocumentReference userHistoryDocument = historyCollection.doc(userId);
    CollectionReference userRidesCollection = userHistoryDocument.collection('user_rides');
print("myRide is being uploaded to history");
    // Add ride data to user history in Firestore
    await userRidesCollection.doc(rideId).set(rideData);
  } catch (e) {
    print('Error moving ride to Firestore history: $e');
  }
}

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