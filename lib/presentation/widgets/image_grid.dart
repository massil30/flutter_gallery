import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting
import '../../domain/entities/image_entity.dart';
import '../controllers/image_controller.dart';

class ImageGrid extends StatelessWidget {
  final List<ImageEntity> images;
  final ImageController controller;

  const ImageGrid({
    Key? key,
    required this.images,
    required this.controller,
  }) : super(key: key);

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
            return InkWell(
              onTap: () {
                Get.dialog(
                  Dialog(
                    child: InteractiveViewer(
                      child: Image.file(controller.getFileFromEntity(imagesForDate[index])),
                    ),
                  ),
                );
              },
              child: Image.file(
                controller.getFileFromEntity(imagesForDate[index]),
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      );
    });
    
    // Return a ListView containing all date groups
    return ListView(
      children: dateGroups,
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
