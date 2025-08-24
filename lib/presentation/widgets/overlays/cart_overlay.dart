import 'package:flutter/material.dart';

// Carte Identité + Permis de conduire Overlay
class CartOverlay extends StatelessWidget {
  const CartOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
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
                  border: Border.all(
                    color: const Color.fromARGB(255, 199, 243, 201),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
