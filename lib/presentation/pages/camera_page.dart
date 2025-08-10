import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import '../controllers/image_controller.dart';
import '../widgets/camera_overlay.dart';
import 'gallery_page.dart';

class CameraPage extends StatelessWidget {
  final ImageController controller = Get.find<ImageController>();

  CameraPage({Key? key}) : super(key: key);

  void navigateToGallery() {
    Get.to(() => GalleryPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take ID Card Picture'),
        actions: [
          IconButton(
            icon: Icon(Icons.photo_library),
            onPressed: navigateToGallery,
          ),
        ],
      ),
      body: Obx(() {
        if (!controller.isCameraReady.value || controller.cameraController == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            // Camera Preview
            CameraPreview(controller.cameraController!),

            // Mask Overlay
            const CameraOverlay(),

            // Capture Button
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: FloatingActionButton(
                  backgroundColor: Colors.green,
                  onPressed: controller.captureImage,
                  child: Icon(Icons.camera_alt),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}