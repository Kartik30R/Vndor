class ProductEntity {
  final String id;
  final String name;
  final double price;
  final int stock;
  final String category;
  final String imageUrl;
  final String vendorId;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
    required this.category,
    required this.imageUrl,
    required this.vendorId,
  });
}
