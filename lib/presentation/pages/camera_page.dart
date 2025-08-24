import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import '../controllers/image_controller.dart';
import '../widgets/overlays/cart_overlay.dart';
import 'gallery_page.dart';

class CameraPage extends StatelessWidget {
  final Widget widget;
  final ImageController controller = Get.find<ImageController>();

  CameraPage({Key? key, required this.widget}) : super(key: key);

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
        if (!controller.isCameraReady.value ||
            controller.cameraController == null) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show image review screen if in review mode
        if (controller.isReviewMode.value &&
            controller.capturedImagePath.value != null) {
          return _buildImageReviewScreen(context);
        }

        // Show camera preview if not in review mode
        return Stack(
          children: [
            // Camera Preview
            CameraPreview(controller.cameraController!),

            // Mask Overlay
            widget,

            // Capture Button
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Center(
                child: FloatingActionButton(
                  backgroundColor: Colors.green,
                  onPressed: controller.takePicture,
                  child: Icon(Icons.camera_alt),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildImageReviewScreen(BuildContext context) {
    final imagePath = controller.capturedImagePath.value!;
    final imageFile = File(imagePath);

    return Column(
      children: [
        // Image with zoom capability
        Expanded(
          child: InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.file(imageFile, fit: BoxFit.contain),
          ),
        ),

        // Buttons row
        Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Retake button (white border with green color)
              ElevatedButton(
                onPressed: controller.retakeImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green,
                  side: BorderSide(color: Colors.green, width: 2),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text('Reprendre', style: TextStyle(fontSize: 16)),
              ),

              // Validate button (green with white text)
              ElevatedButton(
                onPressed: controller.validateImage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: Text('Valider', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
