import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/image_entity.dart';
import '../controllers/image_controller.dart';

class ImageGrid extends StatelessWidget {
  final List<ImageEntity> images;
  final ImageController controller;

  const ImageGrid({Key? key, required this.images, required this.controller})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Group images by date
    final groupedImages = _groupImagesByDate(images);

    // Create a list of widgets for each date group
    final List<Widget> dateGroups = [];

    groupedImages.forEach((date, imagesForDate) {
      // Add date header
      dateGroups.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            date,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      );

      // Add grid for this date group
      dateGroups.add(
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(8),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: imagesForDate.length,
          itemBuilder: (context, index) {
            final image = imagesForDate[index];
            return FutureBuilder<Size>(
              future: controller.getImageDimensions(image),
              builder: (context, snapshot) {
                final resolution = snapshot.hasData
                    ? "${snapshot.data!.width.toInt()} × ${snapshot.data!.height.toInt()}"
                    : "Loading...";

                return Obx(
                  () => Stack(
                    children: [
                      InkWell(
                        onTap: () {
                          if (controller.isSelectionMode.value) {
                            controller.toggleImageSelection(image.path);
                          } else {
                            Get.dialog(
                              Dialog(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    InteractiveViewer(
                                      child: Image.file(
                                        controller.getFileFromEntity(image),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Taken: ${DateFormat('MMM d, yyyy HH:mm').format(image.createdAt)}\n" +
                                            "Resolution: $resolution",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                        onLongPress: () {
                          if (!controller.isSelectionMode.value) {
                            controller.toggleSelectionMode();
                            controller.toggleImageSelection(image.path);
                          }
                        },
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(
                              controller.getFileFromEntity(image),
                              fit: BoxFit.cover,
                            ),
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                color: Colors.black54,
                                padding: EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 8,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      DateFormat(
                                        'HH:mm',
                                      ).format(image.createdAt),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                      resolution,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (controller.isSelectionMode.value)
                        Positioned(
                          top: 8,
                          right: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color:
                                  controller.selectedImages.contains(image.path)
                                  ? Colors.blue
                                  : Colors.white54,
                              shape: BoxShape.circle,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.check,
                                size: 20,
                                color:
                                    controller.selectedImages.contains(
                                      image.path,
                                    )
                                    ? Colors.white
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      );
    });

    // Return a stack with the ListView and a delete button if in selection mode
    return Obx(
      () => Stack(
        children: [
          ListView(children: dateGroups),
          if (controller.isSelectionMode.value &&
              controller.selectedImages.isNotEmpty)
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                child: Icon(Icons.delete),
                onPressed: () {
                  Get.dialog(
                    AlertDialog(
                      title: Text('Delete Images'),
                      content: Text(
                        'Are you sure you want to delete ${controller.selectedImages.length} selected images?',
                      ),
                      actions: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () => Get.back(),
                        ),
                        TextButton(
                          child: Text('Delete'),
                          onPressed: () {
                            Get.back();
                            controller.deleteSelectedImages();
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  // Helper method to group images by date
  Map<String, List<ImageEntity>> _groupImagesByDate(List<ImageEntity> images) {
    final Map<String, List<ImageEntity>> grouped = {};

    for (var image in images) {
      // Format the date as a string (e.g., "January 1, 2023")
      final dateStr = DateFormat.yMMMMd().format(image.createdAt);

      // Add the image to its date group
      if (!grouped.containsKey(dateStr)) {
        grouped[dateStr] = [];
      }
      grouped[dateStr]!.add(image);
    }

    // Sort the dates in descending order (newest first)
    final sortedKeys = grouped.keys.toList()
      ..sort((a, b) {
        // Parse the formatted dates back to DateTime for comparison
        final dateA = DateFormat.yMMMMd().parse(a);
        final dateB = DateFormat.yMMMMd().parse(b);
        return dateB.compareTo(dateA); // Descending order
      });

    // Create a new map with sorted keys
    final sortedGrouped = <String, List<ImageEntity>>{};
    for (var key in sortedKeys) {
      sortedGrouped[key] = grouped[key]!;
    }

    return sortedGrouped;
  }
}
