import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'local_database_helper.dart';
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Sign up with email and password
Future<User?> signUpWithEmailAndPassword(String email, String password, String username, String phoneNumber) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      // Save additional user data to Cloud Firestore
      await _firestore.collection('users').doc(user?.uid).set({
        'email': email,
        'username': username,
        'phoneNumber': phoneNumber,
      });

      return user;
    } catch (error) {
      print('Error during registration: $error');
      return null;
    }
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      print("Error in signInWithEmailAndPassword: $e");
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }


  Future<void> fetchAndStoreRideHistory(String uid) async {
    try {
      // Reference to the Firestore collection
      CollectionReference historyCollection =
          FirebaseFirestore.instance.collection('history');

      // Reference to the user's subcollection
      CollectionReference userRidesCollection =
          historyCollection.doc(uid).collection('user_rides');

      // Get documents from the user's subcollection
      QuerySnapshot rideDocs = await userRidesCollection.get();

      // Loop through the documents and store in local SQLite
      for (QueryDocumentSnapshot rideDoc in rideDocs.docs) {
        Map<String, dynamic> rideData = rideDoc.data() as Map<String, dynamic>;

        // Store rideData in your local SQLite database
        // Replace the following line with your actual implementation
        // await LocalDatabaseHelper.storeRideData(rideData);
      }
    } catch (error) {
      print('Error fetching and storing ride history: $error');
    }
  }
}
