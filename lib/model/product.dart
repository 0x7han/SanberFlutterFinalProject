class Product {
  final String id;
  final String nama;
  final String satuan;
  final int harga;
  int stok;
  String imgSrc;
  final String description;

  Product({
    this.id = '',
    required this.nama,
    required this.satuan,
    required this.harga,
    required this.stok,
    required this.imgSrc,
    required this.description,
  });

  factory Product.fromMap(Map<String, dynamic> data, String documentId) {
    return Product(
      id: documentId,
      nama: data['nama'] ?? '',
      satuan: data['satuan'] ?? '',
      harga: data['harga'] ?? 0,
      stok: data['stok'] ?? 0,
      imgSrc: data['imgSrc'] ?? '',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nama': nama,
      'satuan': satuan,
      'harga': harga,
      'stok': stok,
      'imgSrc': imgSrc,
      'description': description,
    };
  }
}
