import '../../domain/entities/image_entity.dart';
import 'dart:io';
import 'package:flutter/painting.dart';

class ImageModel extends ImageEntity {
  ImageModel({
    required String path,
    required DateTime createdAt,
    int? width,
    int? height,
  }) : super(path: path, createdAt: createdAt);

  // Get Path and Create we get Dimensions when we want to display
  factory ImageModel.fromFile(File file) {
    final fileName = file.path.split('/').last;
    final timestamp =
        int.tryParse(fileName.split('_').last.split('.').first) ??
        DateTime.now().millisecondsSinceEpoch;

    return ImageModel(
      path: file.path,
      createdAt: DateTime.fromMillisecondsSinceEpoch(timestamp),
    );
  }

  File toFile() => File(path);
}
