import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanber_flutter_final_project/model/cart.dart';

class Cashier {
  final String id;
  final Timestamp date;
  final String payment;
  final List<Cart> carts;

  Cashier({
    this.id = '',
    required this.date,
    required this.payment,
    required this.carts,
  });

  factory Cashier.fromMap(Map<String, dynamic> data, String documentId) {
    return Cashier(
      id: documentId,
      date: data['date'],
      payment: data['payment'] ?? '',
      carts: (data['carts'] as List).map((item) => Cart.fromMap(item)).toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'payment': payment,
      'carts': carts.map((cart) => cart.toMap()).toList()
    };
  }
}
