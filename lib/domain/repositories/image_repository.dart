import '../entities/image_entity.dart';

abstract class ImageRepository {
  Future<List<ImageEntity>> getImages();
  Future<String> captureImage();
  Future<void> deleteImages(List<String> paths);
}