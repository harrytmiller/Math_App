import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');



  Future<void> updateUserData({
    required String email,
    required String username,
    required int schoolYear,
    bool advancedMode = false,
  }) async {
    return await userCollection.doc(uid).set({
      'email': email,
      'username': username,
      'schoolYear': schoolYear,
      'advancedMode': advancedMode,
    }, SetOptions(merge: true));
  }



  Future<void> toggleAdvancedMode(bool mode) async {
    return await userCollection.doc(uid).update({
      'advancedMode': mode,
    });
  }



  Future<void> updateSchoolYear(int newSchoolYear) async {
    return await userCollection.doc(uid).update({
      'schoolYear': newSchoolYear,
    });
  }



  Future<void> updateUserProgress({
    int? correctCount,
    int? daysInRow,
    DateTime? lastResetTimestamp,
  }) async {
    Map<String, dynamic> data = {};
    if (correctCount != null) {
      data['correctCount'] = correctCount;
    }
    if (daysInRow != null) {
      data['daysInRow'] = daysInRow;

      DocumentSnapshot userDoc = await userCollection.doc(uid).get();
      if (userDoc.exists) {
        int highestDaysInARow = userDoc['highestDaysInARow'] ?? 0;

        if (daysInRow > highestDaysInARow) {
          data['highestDaysInARow'] = daysInRow;
        }
      } else {
        data['highestDaysInARow'] = daysInRow;
      }
    }
    if (lastResetTimestamp != null) {
      data['lastResetTimestamp'] = lastResetTimestamp;
    }

    return await userCollection.doc(uid).update(data);
  }


  

  Future<void> resetCorrectCount() async {
    return await userCollection.doc(uid).update({
      'correctCount': 0,
      'lastResetTimestamp': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot> getUserData() async {
    return await userCollection.doc(uid).get();
  }

  Stream<DocumentSnapshot> get userData {
    return userCollection.doc(uid).snapshots();
  }
} 