class Product {
  final String id;
  final String imagePath;
  final String name;
  final double price;
  final double? salePrice;
  final String details;

  Product({
    required this.id,
    required this.imagePath,
    required this.name,
    required this.price,
    this.salePrice,
    required this.details,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'name': name,
      'price': price,
      'salePrice': salePrice,
      'details': details,
    };
  }

  static Product fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      imagePath: map['imagePath'],
      name: map['name'],
      price: map['price'],
      salePrice: map['salePrice'],
      details: map['details'],
    );
  }
}
