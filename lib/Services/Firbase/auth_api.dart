import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resq_track/Core/app_constants.dart';
import 'package:resq_track/Model/Request/emergency_firebase_body.dart';

class AuthApi {
  Future<void> createUser({required UserFirebaseRequest user}) {
    return FirebaseFirestore.instance
        .collection(userCollection)
        .doc(user.userId)
        .set(user.toJson());
  }

  Future<void> updateUserLocation(
      String userId, GeoPoint newLocation, String locationName) async {
    // Reference to the Firestore collection
    try {
      // Reference to the Firestore collection
      CollectionReference responders =
          FirebaseFirestore.instance.collection('responders');

      // Query for the document with the matching userId
      QuerySnapshot querySnapshot =
          await responders.where('userId', isEqualTo: userId).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the document ID of the first match
        String docId = querySnapshot.docs.first.id;

        // Update the responder's location
        await responders.doc(docId).update({
          'latitude': newLocation.latitude,
          'longitude': newLocation.longitude,
          'locationName': locationName
        });
        print('Responder$locationName location updated successfully. ${newLocation.latitude} ---- ${newLocation.longitude}');
      } else {
        print('Responder with userId $userId not found.');
      }
    } catch (e) {
      print('Error updating responder location: $e');
    }
  }

  // Update the responder's location

  Future<DocumentSnapshot<Map<String, dynamic>>> checkUserExistInFirebase(
      {required String uId}) {
    return FirebaseFirestore.instance.collection(userCollection).doc(uId).get();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserData(
      {required String uId}) {
    return FirebaseFirestore.instance.collection(userCollection).doc(uId).get();
  }
}
