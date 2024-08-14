import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sanber_flutter_final_project/helper/property_helper.dart';
import 'package:sanber_flutter_final_project/model/product.dart';
import 'package:sanber_flutter_final_project/services/firebase_service.dart';

class ProductRepository implements FirebaseService<Product> {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ProductRepository(
      {FirebaseFirestore? firebaseFirestore, FirebaseStorage? firebaseStorage})
      : _firestore = firebaseFirestore ?? FirebaseFirestore.instance,
        _storage = firebaseStorage ?? FirebaseStorage.instance;

  @override
  String get collectionName => "products";

  @override
  String get storageRef => "images/$collectionName/";

  @override
  String get customId => PropertyHelper().generateId;

  @override
  Stream<List<Product>> get(
      {String sortColumn = 'nama', bool descending = false}) {
    return _firestore
        .collection(collectionName)
        .orderBy(sortColumn, descending: descending)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Product.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  
  @override
Future<Product> getById(String id) async {
  final docSnapshot = await _firestore.collection(collectionName).doc(id).get();
  
  return Product.fromMap(docSnapshot.data()!, docSnapshot.id);
}

  @override
  Future<int> dataCount() async {
    final querySnapshot = await _firestore.collection(collectionName).get();
    return querySnapshot.size;
  }

  @override
  Future<List<Product>> getByQuery(String query) async {
    final result = await _firestore
        .collection(collectionName)
        .where('nama', isGreaterThanOrEqualTo: query)
        .where('nama', isLessThanOrEqualTo: '$query\uf8ff')
        .get();
    return result.docs
        .map((doc) => Product.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<Product> post(Product model) async {
    model.imgSrc = await uploadStorage(customId, File(model.imgSrc));
    await _firestore
        .collection(collectionName)
        .doc(customId)
        .set(model.toMap());
      return model;
  }

  @override
  Future<Product> patch(Product model) async {
    if (!model.imgSrc.contains('firebase')) {
      model.imgSrc = await uploadStorage(model.id, File(model.imgSrc));
    }

    await _firestore.collection(collectionName).doc(model.id).update(
          model.toMap(),
        );

        return model;
  }

  @override
  Future<Product> drop(Product model) async {
    await _firestore.collection(collectionName).doc(model.id).delete();
    return model;
  }

  @override
  Future<String> uploadStorage(String id, File file) async {
    TaskSnapshot snapshot = await _storage.ref('$storageRef$id').putFile(file);
    return await snapshot.ref.getDownloadURL();
  }

  @override
  Future<void> dropStorage(String id) async {
    await _storage.ref('$storageRef$id').delete();
  }
}
