class WatchModel {
  String id;
  String name;
  String brand;
  double price;
  String imageUrl;
  String description;
  bool inStock;

  WatchModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.inStock,
  });

  // Firebase se data lene ke liye
  factory WatchModel.fromMap(Map<String, dynamic> data, String docId) {
    return WatchModel(
      id: docId,
      name: data['name'] ?? '',
      brand: data['brand'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
      description: data['description'] ?? '',
      inStock: data['inStock'] ?? true,
    );
  }
}
