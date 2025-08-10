import '../entities/image_entity.dart';
import '../repositories/image_repository.dart';

class GetImages {
  final ImageRepository repository;

  GetImages(this.repository);

  Future<List<ImageEntity>> call() async {
    return await repository.getImages();
  }
}