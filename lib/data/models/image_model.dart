import '../../domain/entities/image_entity.dart';
import 'dart:io';

class ImageModel extends ImageEntity {
  ImageModel({
    required String path,
    required DateTime createdAt,
  }) : super(path: path, createdAt: createdAt);

  factory ImageModel.fromFile(File file) {
    final fileName = file.path.split('/').last;
    final timestamp = int.tryParse(fileName.split('_').last.split('.').first) ?? 
                     DateTime.now().millisecondsSinceEpoch;
    return ImageModel(
      path: file.path,
      createdAt: DateTime.fromMillisecondsSinceEpoch(timestamp),
    );
  }

  File toFile() => File(path);
}