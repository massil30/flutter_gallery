import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gallery/data/repositories/image_repository_impl.dart';
import 'package:get/get.dart';
import '../../domain/entities/image_entity.dart';
import '../../domain/usecases/capture_image.dart';
import '../../domain/usecases/get_images.dart';
import '../../domain/usecases/delete_images.dart';

class ImageController extends GetxController {
  // Use Cases
  final GetImages getImagesUseCase;
  final CaptureImage captureImageUseCase;
  final DeleteImages deleteImagesUseCase;

  //State
  final images = <ImageEntity>[].obs;
  final isCameraReady = false.obs;
  final selectedImages = <String>[].obs;
  final isSelectionMode = false.obs;
  final capturedImagePath = RxnString();
  final isReviewMode = false.obs;

  // Camera
  CameraController? cameraController;
  List<CameraDescription>? cameras;

  ImageController({
    required this.getImagesUseCase,
    required this.captureImageUseCase,
    required this.deleteImagesUseCase,
  });
  // Handle Camera LifeCycle
  // Oninit
  @override
  void onInit() {
    super.onInit();
    initCamera();
  }

  //onClose
  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }

  //Lunch Camera Function
  Future<void> initCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(cameras![0], ResolutionPreset.high);
    await cameraController!.initialize();
    isCameraReady.value = true;
  }

  //Load Images
  Future<void> loadImages() async {
    final imageEntities = await getImagesUseCase();
    images.value = imageEntities;
  }

  Future<String> takePicture() async {
    final path = await captureImageUseCase();
    capturedImagePath.value = path;
    isReviewMode.value = true;
    return path;
  }

  Future<void> validateImage() async {
    // Image is already saved, just need to update the list
    await loadImages();
    Get.defaultDialog(
      title: "Succès",
      middleText: 'Pecture officialy Saved',
      titleStyle: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      middleTextStyle: TextStyle(fontSize: 16),
      backgroundColor: Colors.white,
      radius: 12,
      confirm: ElevatedButton(
        onPressed: () {
          Get.back(); // close dialog
        },
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        child: Text("OK", style: TextStyle(color: Colors.white)),
      ),
    );
    // Reset review mode
    isReviewMode.value = false;
    capturedImagePath.value = null;
  }

  void retakeImage() {
    // Discard the current image and go back to camera
    if (capturedImagePath.value != null) {
      final file = File(capturedImagePath.value!);
      if (file.existsSync()) {
        file.deleteSync();
      }
    }
    isReviewMode.value = false;
    capturedImagePath.value = null;
  }

  File getFileFromEntity(ImageEntity entity) {
    return File(entity.path);
  }

  // Get image dimensions
  Future<Size> getImageDimensions(ImageEntity entity) async {
    final file = getFileFromEntity(entity);
    final image = await decodeImageFromList(file.readAsBytesSync());
    return Size(image.width.toDouble(), image.height.toDouble());
  }

  // Toggle selection mode
  void toggleSelectionMode() {
    isSelectionMode.value = !isSelectionMode.value;
    if (!isSelectionMode.value) {
      selectedImages.clear();
    }
  }

  // Toggle image selection
  void toggleImageSelection(String path) {
    if (selectedImages.contains(path)) {
      selectedImages.remove(path);
    } else {
      selectedImages.add(path);
    }
  }

  // Delete selected images
  Future<void> deleteSelectedImages(List<String> paths) async {
    try {
      // Call the DeleteImages use case
      await deleteImagesUseCase.delete(paths);
      //After deleting images Load them again to not remove the previous once
      await loadImages();
      //Clear the previous list
      selectedImages.clear();
      if (images.isEmpty) {
        isSelectionMode.value = false;
      }
    } catch (e) {
      // Handle errors if needed
      print("Error deleting images: $e");
    }
  }
}
