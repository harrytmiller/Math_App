import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart'; 



class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _userFromFirebaseUser(User? user) {
    return user;
  }

  Stream<User?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  User? get currentUser {
    return _auth.currentUser;
  }



  Future<String?> getCurrentUserId() async {
    try {
      User? user = _auth.currentUser;
      return user?.uid;
    } catch (e) {
      return null;
    }
  }



  Future<User?> signInWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      return null;
    }
  }



  Future<User?> registerWithEmail(String email, String password, String username, int schoolYear) async {
    try {
      bool isUnique = await isEmailUnique(email);
      if (!isUnique) {
        return null;
      }

      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      if (user != null) {
        await DatabaseService(uid: user.uid).updateUserData(
          email: email,
          username: username,
          schoolYear: schoolYear,
        );
      }

      return _userFromFirebaseUser(user);
    } catch (e) {
      return null;
    }
  }


  
  Future<bool> isUsernameUnique(String username) async {
    try {
      final result = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isEqualTo: username)
          .get();
      return result.docs.isEmpty;
    } catch (e) {
      return false;
    }
  }



  Future<bool> isEmailUnique(String email) async {
    try {
      final result = await _auth.fetchSignInMethodsForEmail(email);
      return result.isEmpty;
    } catch (e) {
      return false;
    }
  }



  Future<bool> changePassword(String currentPassword, String newPassword) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) return false;

      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);

      await user.updatePassword(newPassword);
      return true;
    } catch (e) {
      return false;
    }
  }



  Future<void> signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {}
  }



  Future<bool> updateUserInformation(String username, int schoolYear) async {
    try {
      User? user = _auth.currentUser;
      if (user == null || user.email == null) {
        return false;
      }

      await DatabaseService(uid: user.uid).updateUserData(
        email: user.email!,
        username: username,
        schoolYear: schoolYear,
      );
      return true;
    } catch (e) {
      return false;
    }
  }



  Future<void> updateUserProgress({
    int? correctCount,
    int? daysInRow,
    DateTime? lastResetTimestamp,
  }) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return;
      }

      await DatabaseService(uid: user.uid).updateUserProgress(
        correctCount: correctCount,
        daysInRow: daysInRow,
        lastResetTimestamp: lastResetTimestamp,
      );
    } catch (e) {}
  }



  Future<void> updateHighestDaysInARow(int currentDaysInRow) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return;
      }

      DocumentSnapshot userDoc = await DatabaseService(uid: user.uid).getUserData();
      int highestDaysInARow = userDoc['highestDaysInARow'] ?? 0;

      if (currentDaysInRow > highestDaysInARow) {
        await DatabaseService(uid: user.uid).updateUserProgress(
          daysInRow: currentDaysInRow,
        );
      }
    } catch (e) {}
  }



  Future<void> resetUserProgress() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return;
      }

      await DatabaseService(uid: user.uid).resetCorrectCount();
    } catch (e) {}
  }

  

  Future<void> toggleAdvancedMode(bool mode) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        return;
      }

      await DatabaseService(uid: user.uid).toggleAdvancedMode(mode);
    } catch (e) {}
  }
}