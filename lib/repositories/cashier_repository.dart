import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sanber_flutter_final_project/helper/property_helper.dart';
import 'package:sanber_flutter_final_project/model/cashier.dart';
import 'package:sanber_flutter_final_project/services/firebase_service.dart';

class CashierRepository implements FirebaseService<Cashier> {
  final FirebaseFirestore _firestore;

  CashierRepository(
      {FirebaseFirestore? firebaseFirestore, FirebaseStorage? firebaseStorage})
      : _firestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  String get collectionName => "cashiers";

  @override
  String get storageRef => throw UnimplementedError();

  @override
  String get customId => PropertyHelper().generateId;

  @override
  Stream<List<Cashier>> get(
      {String sortColumn = 'date', bool descending = false}) {
    return _firestore
        .collection(collectionName)
        .orderBy(sortColumn, descending: descending)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Cashier.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  @override
  Future<Cashier> getById(String id) async {
    final docSnapshot =
        await _firestore.collection(collectionName).doc(id).get();

    return Cashier.fromMap(docSnapshot.data()!, docSnapshot.id);
  }

  @override
  Future<int> dataCount() async {
    final querySnapshot = await _firestore.collection(collectionName).get();
    return querySnapshot.size;
  }

  @override
  Future<List<Cashier>> getByQuery(String query) async {
    final result = await _firestore
        .collection(collectionName)
        .where('date', isGreaterThanOrEqualTo: query)
        .where('date', isLessThanOrEqualTo: '$query\uf8ff')
        .get();
    return result.docs
        .map((doc) => Cashier.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<Cashier> post(Cashier model) async {
    final String myId = customId;
    await _firestore
        .collection(collectionName)
        .doc(myId)
        .set(model.toMap());
    
    return getById(myId);
  }

  @override
  Future<Cashier> patch(Cashier model) async {
    await _firestore.collection(collectionName).doc(model.id).update(
          model.toMap(),
        );

    return model;
  }

  @override
  Future<Cashier> drop(Cashier model) async {
    await _firestore.collection(collectionName).doc(model.id).delete();

    return model;
  }

  @override
  Future<String> uploadStorage(String id, File file) async {
    throw UnimplementedError();
  }

  @override
  Future<void> dropStorage(String id) async {
    throw UnimplementedError();
  }
}
