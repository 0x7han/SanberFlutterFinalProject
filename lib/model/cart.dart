class Cart {
  final String productId;
  int qty;
   int total;

  Cart({
    required this.productId,
    required this.qty,
    required this.total,
  });

  factory Cart.fromMap(Map<String, dynamic> data) {
    return Cart(
      productId: data['productId'],
      qty: data['qty'],
      total: data['total'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'qty': qty,
      'total': total,
    };
  }
}
