import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/image_controller.dart';
import '../widgets/image_grid.dart';

class GalleryPage extends StatelessWidget {
  final ImageController controller = Get.find<ImageController>();

  GalleryPage({Key? key}) : super(key: key) {
    controller.loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stored Images')),
      body: Obx(() {
        if (controller.images.isEmpty) {
          return Center(child: Text('No images found'));
        }
        return ImageGrid(
          images: controller.images,
          controller: controller,
        );
      }),
    );
  }
}