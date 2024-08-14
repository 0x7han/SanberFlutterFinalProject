import 'dart:async';

import 'package:sanber_flutter_final_project/model/cart.dart';
import 'package:sanber_flutter_final_project/services/temp_service.dart';

class CartRepository implements TempService<Cart> {
  final StreamController<List<Cart>> _streamController =
      StreamController<List<Cart>>.broadcast();

  @override
  List<Cart> datas = [];

  @override
  StreamController<List<Cart>> get streamController => _streamController;

  @override
  Future<void> reset() async {
    datas.clear();
    sink();
  }

  @override
  Future<void> sink() async {
    streamController.add(datas);
  }

  @override
  Future<void> dispose() async {
    streamController.close();
  }

  @override
  Stream<List<Cart>> get() {
    return streamController.stream;
  }

  @override
  Future<Cart> getById(String id) async {
    return datas.where((item) => item.productId == id).first;
  }

  @override
  Future<void> post(Cart model) async {
    datas.add(model);
    sink();
  }

  @override
  Future<void> patch(Cart model) async {
    final index = datas.indexWhere((item) => item.productId == model.productId);
    if (index != -1) {
      datas[index] = model;
      sink();
    }
  }

  @override
  Future<void> drop(Cart model) async {
    final index = datas.indexWhere((item) => item.productId == model.productId);
    if (index != -1) {
      datas.removeAt(index);
      sink();
    }
  }

  @override
  Future<int> dataCount() async {
    return datas.length;
  }
}
