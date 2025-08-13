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
      appBar: AppBar(
        title: Text('Gallery'),
        actions: [
          Obx(
            () => controller.images.isNotEmpty
                ? IconButton(
                    icon: Icon(
                      controller.isSelectionMode.value
                          ? Icons.cancel
                          : Icons.select_all,
                    ),
                    onPressed: controller.toggleSelectionMode,
                  )
                : SizedBox.shrink(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.images.isEmpty) {
          return Center(child: Text('No images found'));
        }
        return ImageGrid(images: controller.images, controller: controller);
      }),
    );
  }
}
