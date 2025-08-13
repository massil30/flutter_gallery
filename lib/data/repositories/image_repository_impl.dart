import '../../domain/entities/image_entity.dart';
import '../../domain/repositories/image_repository.dart';
import '../datasources/local_image_datasource.dart';
import 'package:camera/camera.dart';

class ImageRepositoryImpl implements ImageRepository {
  final LocalImageDataSource dataSource;
  final CameraController cameraController;

  ImageRepositoryImpl({
    required this.dataSource,
    required this.cameraController,
  });

  @override
  Future<List<ImageEntity>> getImages() async {
    return await dataSource.getImages();
  }

  @override
  Future<String> captureImage() async {
    return await dataSource.captureImage(cameraController);
  }

  @override
  Future<void> deleteImages(List<String> paths) async {
    await dataSource.deleteImages(paths);
  }
}