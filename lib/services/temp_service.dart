import 'dart:async';

abstract class TempService<T> {

  List<T> get datas;
  StreamController<List<T>> get streamController;

  Future<void> reset();
  Future<void> sink();
  Future<void> dispose();
  Future<int> dataCount();
  Stream<List<T>> get();
  Future<T> getById(String id);
  Future<void> post(T model);
  Future<void> patch(T model);
  Future<void> drop(T model);

}