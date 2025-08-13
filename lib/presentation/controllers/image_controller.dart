import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gallery/data/repositories/image_repository_impl.dart';
import 'package:get/get.dart';
import '../../domain/entities/image_entity.dart';
import '../../domain/usecases/capture_image.dart';
import '../../domain/usecases/get_images.dart';

class ImageController extends GetxController {
  final GetImages getImagesUseCase;
  final CaptureImage captureImageUseCase;

  final images = <ImageEntity>[].obs;
  final isCameraReady = false.obs;
  final selectedImages = <String>[].obs;
  final isSelectionMode = false.obs;

  CameraController? cameraController;
  List<CameraDescription>? cameras;

  ImageController({
    required this.getImagesUseCase,
    required this.captureImageUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    initCamera();
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    cameraController = CameraController(cameras![0], ResolutionPreset.high);
    await cameraController!.initialize();
    isCameraReady.value = true;
  }

  Future<void> loadImages() async {
    final imageEntities = await getImagesUseCase();
    images.value = imageEntities;
  }

  Future<void> captureImage() async {
    await captureImageUseCase();
    await loadImages();
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
  Future<void> deleteSelectedImages() async {
    if (selectedImages.isEmpty) return;

    await Get.find<ImageRepositoryImpl>().deleteImages(selectedImages.toList());
    await loadImages();
    selectedImages.clear();
    if (images.isEmpty) {
      isSelectionMode.value = false;
    }
  }
}
