import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository(
      {FirebaseAuth? firebaseAuth,
      FirebaseFirestore? firestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<User?> signInWithEmailPassword(
      String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;

    return user;
  }

  Future<User?> signUpWithEmailPassword(
      String email, String password, String fullname, String noHp) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'fullname': fullname,
      'email': email,
      'password': password,
      'noHp': noHp,
    });

    return userCredential.user;
  }

  Future<Map<String, dynamic>?> getUserInfo(
      String uid) async {

    DocumentSnapshot<Map<String, dynamic>> userInfoSnapshot =
        await _firestore.collection('users').doc(uid).get();

    Map<String, dynamic>? userInfo = userInfoSnapshot.data();

    return {
      'uid': uid,
      'fullname': userInfo!['fullname'],
      'email': userInfo['email'],
      'password': userInfo['password'],
      'noHp': userInfo['noHp'],
    };
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Stream<User?> get user => _firebaseAuth.authStateChanges();
}
