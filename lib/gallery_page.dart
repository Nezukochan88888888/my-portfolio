import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/image_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({super.key});

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  late Future<List<String>> _imageUrlsFuture;
  // Cloud name / tag are optional now — images come from ImageService config
  final String _cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  final String _tagName = dotenv.env['CLOUDINARY_TAG_NAME'] ?? '';

  @override
  void initState() {
    super.initState();

    // Use the ImageService config that was loaded in main.dart.
    _imageUrlsFuture = _loadFromImageService();
  }

  Future<List<String>> _loadFromImageService() async {
    // ImageService.instance.loadConfig() was awaited in main.dart, but call again to be safe.
    await ImageService.instance.loadConfig();

    final config = ImageService.instance.rawConfig;
    final dynamic galleryVal = config['gallery'];

    final List<String> urls = [];
    if (galleryVal is String && galleryVal.isNotEmpty) {
      urls.add(galleryVal);
    } else if (galleryVal is List) {
      for (final e in galleryVal) {
        if (e is String && e.isNotEmpty) urls.add(e);
      }
    }

    // If no 'gallery' key, fallback to all known images
    if (urls.isEmpty) {
      urls.addAll(ImageService.instance.getAllImageUrls());
    }

    return urls;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: _imageUrlsFuture,
      builder: (context, snapshot) {
        // Show a loading spinner while waiting
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // Show an error message if something went wrong
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        // Show a message if no images were found
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'No images found. Make sure you have uploaded images to Cloudinary and tagged them correctly.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          );
        }

        // If data is loaded, build the grid
        final imageUrls = snapshot.data!;
        return GridView.builder(
          padding: const EdgeInsets.all(10.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 columns
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Placeholder for viewing image in full screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Image ${index + 1} tapped!')),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imageUrls[index],
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, _, __) =>
                      const Center(child: Icon(Icons.broken_image, size: 48)),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
