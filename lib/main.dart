import 'package:flutter/material.dart';
import 'package:flutter_gallery/homepage.dart';
import 'package:flutter_gallery/presentation/pages/car_images.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'data/datasources/local_image_datasource.dart';
import 'data/repositories/image_repository_impl.dart';
import 'domain/usecases/capture_image.dart';
import 'domain/usecases/get_images.dart';
import 'presentation/controllers/image_controller.dart';
import 'presentation/pages/camera_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'ID Card Gallery',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: FutureBuilder(
        future: _initializeController(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CarPectures();
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }

  Future<void> _initializeController() async {
    // Initialize camera
    final cameras = await availableCameras();
    final cameraController = CameraController(
      cameras[0],
      ResolutionPreset.high,
    );
    await cameraController.initialize();

    // Setup dependencies
    final dataSource = LocalImageDataSource();
    final repository = ImageRepositoryImpl(
      dataSource: dataSource,
      cameraController: cameraController,
    );

    // Setup use cases
    final getImages = GetImages(repository);
    final captureImage = CaptureImage(repository);

    // Register controller
    Get.put(
      ImageController(
        getImagesUseCase: getImages,
        captureImageUseCase: captureImage,
      ),
    );
  }
}
