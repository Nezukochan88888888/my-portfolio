import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GalleryPage extends StatelessWidget {
  const GalleryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      'assets/images/placeholder_1.svg',
      'assets/images/placeholder_2.svg',
      'assets/images/placeholder_3.svg',
      'assets/images/placeholder_2.svg',
      'assets/images/placeholder_3.svg',
      'assets/images/placeholder_1.svg',
    ];

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: images.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            // Placeholder for viewing image in full screen
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Image ${index + 1} tapped!')),
            );
          },
          child: SvgPicture.asset(
            images[index],
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }
}