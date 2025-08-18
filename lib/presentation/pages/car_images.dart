import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import '../controllers/image_controller.dart';
import '../widgets/overlays/camera_overlay.dart';
import 'gallery_page.dart';

class CarPectures extends StatelessWidget {
  final ImageController controller = Get.find<ImageController>();

  CarPectures({Key? key}) : super(key: key);

  void navigateToGallery() {
    Get.to(() => GalleryPage());
  }

  final List<Map<String, String>> carOptions = [
    {'label': 'Arrière', 'image': 'assets/car.png'},
    {'label': 'Gauche', 'image': 'assets/car.png'},
    {'label': 'Droite', 'image': 'assets/car.png'},
    {'label': 'Avant', 'image': 'assets/car.png'},
  ];

  // Track selected index
  final RxInt selectedIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Car Picture'),
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
            Positioned(
              left: 0,
              right: 0,
              bottom: MediaQuery.of(context).size.height * 0.1,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(carOptions.length, (index) {
                    final option = carOptions[index];
                    return GestureDetector(
                      onTap: () {
                        selectedIndex.value = index; // update selection
                      },
                      child: Obx(
                        () => buildCarOption(
                          option['label']!,
                          option['image']!,
                          context,
                          isSelected: selectedIndex.value == index,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            // Capture Button
            Positioned(
              bottom: 15,
              left: 0,
              right: 0,
              child: Center(
                child: FloatingActionButton(
                  backgroundColor: Colors.green,
                  onPressed: controller.takePicture,
                  child: Icon(Icons.camera_alt, color: Colors.white),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget buildCarOption(
    String label,
    String imagePath,
    BuildContext context, {
    bool isSelected = false,
  }) {
    return Container(
      margin: EdgeInsets.all(8),
      width: MediaQuery.of(context).size.height * 0.17,
      height: MediaQuery.of(context).size.height * 0.2,
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected
              ? Colors.green
              : const Color.fromARGB(255, 219, 221, 216),
          width: 3, // thicker border when selected
        ),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      padding: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, width: 40, height: 40, fit: BoxFit.contain),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.green : Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
