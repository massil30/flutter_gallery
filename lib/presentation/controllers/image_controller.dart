import 'dart:io';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import '../../domain/entities/image_entity.dart';
import '../../domain/usecases/capture_image.dart';
import '../../domain/usecases/get_images.dart';

class ImageController extends GetxController {
  final GetImages getImagesUseCase;
  final CaptureImage captureImageUseCase;
  
  final images = <ImageEntity>[].obs;
  final isCameraReady = false.obs;
  
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
}