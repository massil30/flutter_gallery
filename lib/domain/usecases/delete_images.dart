import '../repositories/image_repository.dart';

class DeleteImages {
  final ImageRepository repository;

  DeleteImages(this.repository);

  Future<void> delete(List<String> paths) async {
    return await repository.deleteImages(paths);
  }
}
