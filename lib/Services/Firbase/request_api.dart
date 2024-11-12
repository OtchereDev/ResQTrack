import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:resq_track/Core/app_constants.dart';

class RequestApi {


  Future<void> updateRequestStatus(
      {required String requestId, required String status}) {
    return FirebaseFirestore.instance
        .collection(requestCollection)
        .doc(requestId)
        .update({'status': status});
  }

Stream<dynamic> filterEmergencyById(String emergencyId, String userName) {
  CollectionReference emergencies =
      FirebaseFirestore.instance.collection(activeEmergency);

  // Return a stream that listens to real-time updates
  return emergencies
      .where('emergency_id', isEqualTo: emergencyId)
      .where('user_id', isEqualTo: userName)
      .snapshots()
      .map((querySnapshot) {
    if (querySnapshot.docs.isNotEmpty) {
      // If there are documents, log and return the first one
      var data = querySnapshot.docs.first.data(); // Get the first document's data
      debugPrint('Emergency Data: $data'); // Log the data
      return data;
    } else {
      debugPrint('No emergencies found with the given ID.');
      return null; // Handle the case where no documents are found
    }
  });
}



Stream<List<Map<String, dynamic>>> getResponderActiveEmergency(String status, String userID) {
    CollectionReference emergencies = FirebaseFirestore.instance.collection(activeEmergency);

    // Create two queries for different statuses
    var query1 = emergencies
        .where('status', isEqualTo: "CONNECTING")
        .where('responder_id', isEqualTo: userID);

    var query2 = emergencies
        .where('status', isEqualTo: "ON-ROUTE")
        .where('responder_id', isEqualTo: userID);

    // Listen to both queries and merge their snapshots
    return Rx.combineLatest2(
      query1.snapshots(),
      query2.snapshots(),
      (QuerySnapshot querySnapshot1, QuerySnapshot querySnapshot2) {
        List<Map<String, dynamic>> results = [];

        // Process results from the first query
        for (var doc in querySnapshot1.docs) {
          results.add(doc.data() as Map<String, dynamic>);
        }

        // Process results from the second query
        for (var doc in querySnapshot2.docs) {
          results.add(doc.data() as Map<String, dynamic>);
        }

        return results;
      },
    );
  }





 Stream<dynamic> getResponderLocation(String responderId) {
  CollectionReference respondersCollection =
      FirebaseFirestore.instance.collection('responders');  // Correct reference
  return respondersCollection
      .where('userId', isEqualTo: responderId)  // Query by userId field
      
      .snapshots()
      .map((querySnapshot) {
    var data;
    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((doc) {
        // Safe access to document data
        data = doc.data();

        // Check if required fields exist before accessing them
        if (data != null) {
          debugPrint('Responder Email: ${data['email'] ?? 'N/A'}');
          debugPrint('Location Name: ${data['locationName'] ?? 'N/A'}');
          debugPrint('Latitude: ${data['latitude'] ?? 'N/A'}');
          debugPrint('Longitude: ${data['longitude'] ?? 'N/A'}');
          debugPrint('Responder Name: ${data['name'] ?? 'N/A'}');
          debugPrint('Responder Type: ${data['type'] ?? 'N/A'}');
        } else {
          debugPrint('Document data is null.');
        }
      });
    } else {
      debugPrint('No Responder found with the given ID: $responderId');
    }
    
    // Return the first document's data, or null if none found
    return data;
  });
}



 Stream<dynamic> getReporterlocation(String userId) {
    // debugPrint("-------------------------RESPONDER-------$responderId-----------Respond");

  CollectionReference respondersCollection =
      FirebaseFirestore.instance.collection('Users');  // Correct reference
  return respondersCollection
      .where('userID', isEqualTo: userId)  // Query by userId field
      // .where("userType", isEqualTo: "")
      .snapshots()
      .map((querySnapshot) {
    var data;


    // Check if any documents were found
    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.forEach((doc) {
        // Safe access to document data
        data = doc.data();

        // Check if required fields exist before accessing them
        if (data != null) {
          debugPrint('Responder Email: ${data['email'] ?? 'N/A'}');
          debugPrint('Location Name: ${data['locationName'] ?? 'N/A'}');
          debugPrint('Latitude: ${data['latitude'] ?? 'N/A'}');
          debugPrint('Longitude: ${data['longitude'] ?? 'N/A'}');
          debugPrint('Responder Name: ${data['name'] ?? 'N/A'}');
          debugPrint('Responder Type: ${data['type'] ?? 'N/A'}');
        } else {
          debugPrint('Document data is null.');
        }
      });
    } else {
      debugPrint('No Responder found with the given ID: $userId');
    }
    
    // Return the first document's data, or null if none found
    return data;
  });
}

  Stream<dynamic> listenForIncomingRequest(String driverId) {
    return FirebaseFirestore.instance
        .collection(callsCollection)
        .doc(driverId)
        .snapshots()
        .map((snapshot) {
      if (snapshot.exists) {
        var data = snapshot.data();
        if (data!['status'] == "CALLED" || data['status'] == "ACTIVE") {
          return (data);
        }
      }
      return null;
    });
  }
  // Future<DocumentSnapshot<Map<String, dynamic>>> checkUserExistInFirebase(
  //     {required String uId}) {
  //   return FirebaseFirestore.instance.collection(userCollection).doc(uId).get();
  // }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>> getUsersRealTime() {
    return FirebaseFirestore.instance
        .collection(userCollection)
        .where('uId', isNotEqualTo: "")
        .snapshots()
        .listen((event) {});
  }
}
