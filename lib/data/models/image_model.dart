import '../../domain/entities/image_entity.dart';
import 'dart:io';
import 'package:flutter/painting.dart';

class ImageModel extends ImageEntity {
  ImageModel({
    required String path,
    required DateTime createdAt,
    int? width,
    int? height,
  }) : super(path: path, createdAt: createdAt, );

  factory ImageModel.fromFile(File file) {
    final fileName = file.path.split('/').last;
    final timestamp =
        int.tryParse(fileName.split('_').last.split('.').first) ??
        DateTime.now().millisecondsSinceEpoch;

    // We'll get the actual dimensions when displaying the image
    return ImageModel(
      path: file.path,
      createdAt: DateTime.fromMillisecondsSinceEpoch(timestamp),
    );
  }

  File toFile() => File(path);
}
