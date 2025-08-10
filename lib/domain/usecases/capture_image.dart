import '../repositories/image_repository.dart';

class CaptureImage {
  final ImageRepository repository;

  CaptureImage(this.repository);

  Future<String> call() async {
    return await repository.captureImage();
  }
}