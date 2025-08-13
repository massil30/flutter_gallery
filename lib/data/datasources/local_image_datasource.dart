import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import '../models/image_model.dart';

class LocalImageDataSource {
  Future<List<ImageModel>> getImages() async {
    final dir = await getApplicationDocumentsDirectory();
    final files = Directory(dir.path)
        .listSync()
        .where((f) => f.path.endsWith('.png'))
        .map((f) => File(f.path))
        .toList();

    return files.map((file) => ImageModel.fromFile(file)).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt)); // newest first
  }

  Future<String> captureImage(CameraController controller) async {
    final dirPath = await _getAppDocumentsPath();
    final fileName = 'idcard_${DateTime.now().millisecondsSinceEpoch}.png';
    final path = join(dirPath, fileName);

    final XFile image = await controller.takePicture();
    await File(image.path).copy(path);
    print("Image saved at: $path");
    return path;
  }

  Future<void> deleteImages(List<String> paths) async {
    for (final path in paths) {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
      }
    }
  }

  Future<String> _getAppDocumentsPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
}
