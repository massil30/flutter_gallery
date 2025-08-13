class ImageEntity {
  final String path;
  final DateTime createdAt;
  final int? width;
  final int? height;

  ImageEntity({
    required this.path,
    required this.createdAt,
    this.width,
    this.height,
  });
}