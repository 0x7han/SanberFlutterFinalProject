import 'dart:io';

abstract class FirebaseService<T> {

  String get collectionName;
  String get storageRef;

  String get customId;

  Future<int> dataCount();
  Stream<List<T>> get();
  Future<T> getById(String id);
  Future<List<T>> getByQuery(String query);
  Future<T> post(T model);
  Future<T> patch(T model);
  Future<T> drop(T model);

  Future<String?> uploadStorage(String id, File file);
  Future<void> dropStorage(String id);
}