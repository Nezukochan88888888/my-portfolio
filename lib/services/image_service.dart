import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Simple ImageService: loads a JSON map of keys -> (string | [string,...])
/// Try remote JSON URL first (dotenv: IMAGES_CONFIG_URL), otherwise loads
/// local asset assets/config/images.json.
///
/// It now transforms Cloudinary URLs to use the local backend proxy.
///
/// Example JSON shape:
/// {
///   "heroBanner": "https://res.cloudinary.com/your_cloud/image/upload/v.../hero.jpg",
///   "profilePhoto": "https://res.cloudinary.com/your_cloud/image/upload/v.../me.jpg",
///   "gallery": [ "https://...", "https://..." ]
/// }
class ImageService {
  ImageService._internal();
  static final ImageService instance = ImageService._internal();

  Map<String, dynamic> _config = {};
  bool _loaded = false;

  // Transforms a Cloudinary URL into a URL pointing to our backend service.
  String _transformUrl(String originalUrl) {
    // This should match the running backend server address.
    const String backendBaseUrl = 'http://localhost:3000/image';

    try {
      final uri = Uri.parse(originalUrl);
      final pathSegments = uri.pathSegments;

      // Find the 'upload' segment, as the public ID comes after it (and after any transformations).
      final uploadSegmentIndex = pathSegments.lastIndexOf('upload');
      if (uploadSegmentIndex == -1) {
        return originalUrl; // Not a valid Cloudinary URL for our purpose.
      }

      // Look for a version segment (e.g., "v123456") after 'upload'.
      int publicIdStartIndex = uploadSegmentIndex + 1;
      if (pathSegments.length > publicIdStartIndex) {
        final potentialVersionSegment = pathSegments[publicIdStartIndex];
        if (potentialVersionSegment.startsWith('v') &&
            int.tryParse(potentialVersionSegment.substring(1)) != null) {
          // If it's a version segment, the public ID starts after it.
          publicIdStartIndex++;
        }
      }

      // If there are no segments after 'upload' (and optional version), something is wrong.
      if (publicIdStartIndex >= pathSegments.length) {
        return originalUrl;
      }

      // The public_id is all segments after the transformations/version.
      final publicIdPath = pathSegments.sublist(publicIdStartIndex).join('/');

      // Remove the file extension.
      final lastDot = publicIdPath.lastIndexOf('.');
      final publicId = (lastDot != -1)
          ? publicIdPath.substring(0, lastDot)
          : publicIdPath;

      if (publicId.isEmpty) return originalUrl;

      return '$backendBaseUrl/$publicId';
    } catch (e) {
      // Fallback to original URL on any parsing error.
      return originalUrl;
    }
  }

  /// Loads config. Safe to call multiple times.
  Future<void> loadConfig() async {
    if (_loaded) return;
    // First, try remote URL specified in .env
    final String? remoteUrl = dotenv.env['IMAGES_CONFIG_URL']?.trim();
    if (remoteUrl != null &&
        remoteUrl.isNotEmpty &&
        (remoteUrl.startsWith('http'))) {
      try {
        final uri = Uri.parse(remoteUrl);
        final resp = await http.get(uri).timeout(const Duration(seconds: 8));
        if (resp.statusCode == 200) {
          final parsed = json.decode(resp.body);
          if (parsed is Map<String, dynamic>) {
            _config = parsed;
            _loaded = true;
            return;
          }
        }
      } catch (_) {
        // ignore and fall back to asset
      }
    }

    // Fallback to local asset
    try {
      final content = await rootBundle.loadString('assets/config/images.json');
      final parsed = json.decode(content);
      if (parsed is Map<String, dynamic>) {
        _config = parsed;
      } else {
        _config = {};
      }
    } catch (e) {
      _config = {};
      // in production you may want to rethrow or log
    }
    _loaded = true;
  }

  /// Get image URL by key. If the value is an array, returns element at index (default 0).
  /// Returns null if not found. The URL is transformed to use the backend proxy.
  String? getImage(String key, {int index = 0}) {
    final val = _config[key];
    if (val == null) return null;
    if (val is String) return _transformUrl(val);
    if (val is List && val.isNotEmpty) {
      final i = index < val.length ? index : 0;
      final entry = val[i];
      if (entry is String) return _transformUrl(entry);
    }
    return null;
  }

  /// Return all image URLs (flattened), transformed for the backend proxy.
  /// Useful for preloading.
  List<String> getAllImageUrls() {
    final List<String> urls = [];
    _config.forEach((_, v) {
      if (v is String) urls.add(_transformUrl(v));
      if (v is List) {
        for (final e in v) {
          if (e is String) urls.add(_transformUrl(e));
        }
      }
    });
    return urls;
  }

  /// Preload all images into the image cache. Provide a BuildContext.
  /// Images will be fetched through the backend proxy.
  Future<void> preloadImages(BuildContext context) async {
    final urls = getAllImageUrls();
    for (final url in urls) {
      try {
        // Use a standard NetworkImage, which will now point to our backend
        await precacheImage(NetworkImage(url), context);
      } catch (e) {
        debugPrint('Failed to preload image $url: $e');
        // ignore individual preload failures
      }
    }
  }

  /// For debugging / admin: get raw config map
  Map<String, dynamic> get rawConfig => Map.unmodifiable(_config);
}
