import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

class TakeIDCardPicture extends StatefulWidget {
  @override
  _TakeIDCardPictureState createState() => _TakeIDCardPictureState();
}

class _TakeIDCardPictureState extends State<TakeIDCardPicture> {
  CameraController? controller;
  List<CameraDescription>? cameras;
  bool isCameraReady = false;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    controller = CameraController(cameras![0], ResolutionPreset.high);
    await controller!.initialize();
    setState(() {
      isCameraReady = true;
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<String> _getAppDocumentsPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<void> captureImage() async {
    final dirPath = await _getAppDocumentsPath();
    final fileName = 'idcard_${DateTime.now().millisecondsSinceEpoch}.png';
    final path = join(dirPath, fileName);

    await controller!.takePicture().then((XFile file) async {
      await File(file.path).copy(path);
      print("Image saved at: $path");
    });
  }

  void navigateToGallery() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => StoredImagesScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!isCameraReady || controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

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
      body: Stack(
        children: [
          // === CAMERA PREVIEW ===
          CameraPreview(controller!),

          // === MASK OVERLAY WITH TRANSPARENT RECTANGLE ===
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  // Top
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: (constraints.maxHeight - 200) / 2,
                    child: Container(color: Colors.black.withOpacity(0.6)),
                  ),
                  // Bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: (constraints.maxHeight - 200) / 2,
                    child: Container(color: Colors.black.withOpacity(0.6)),
                  ),
                  // Left
                  Positioned(
                    top: (constraints.maxHeight - 200) / 2,
                    left: 0,
                    width: (constraints.maxWidth - 300) / 2,
                    height: 200,
                    child: Container(color: Colors.black.withOpacity(0.6)),
                  ),
                  // Right
                  Positioned(
                    top: (constraints.maxHeight - 200) / 2,
                    right: 0,
                    width: (constraints.maxWidth - 300) / 2,
                    height: 200,
                    child: Container(color: Colors.black.withOpacity(0.6)),
                  ),
                  // Border Rectangle
                  Positioned(
                    top: (constraints.maxHeight - 200) / 2,
                    left: (constraints.maxWidth - 300) / 2,
                    child: Container(
                      width: 300,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.green, width: 3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // === CAPTURE BUTTON ===
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton(
                backgroundColor: Colors.green,
                onPressed: captureImage,
                child: Icon(Icons.camera_alt),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StoredImagesScreen extends StatefulWidget {
  @override
  _StoredImagesScreenState createState() => _StoredImagesScreenState();
}

class _StoredImagesScreenState extends State<StoredImagesScreen> {
  List<File> images = [];

  Future<void> loadImages() async {
    final dir = await getApplicationDocumentsDirectory();
    final files = Directory(dir.path)
        .listSync()
        .where((f) => f.path.endsWith('.png'))
        .map((f) => File(f.path))
        .toList();
    setState(() {
      images = files.reversed.toList(); // newest first
    });
  }

  @override
  void initState() {
    super.initState();
    loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stored Images')),
      body: images.isEmpty
          ? Center(child: Text('No images found'))
          : GridView.builder(
              padding: EdgeInsets.all(8),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: images.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    Get.dialog(
                      Dialog(
                        child: InteractiveViewer(
                          child: Image.file(images[index]),
                        ),
                      ),
                    );
                  },
                  child: Image.file(images[index], fit: BoxFit.cover),
                );
              },
            ),
    );
  }
}
