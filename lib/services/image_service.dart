import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// Simple ImageService: loads a JSON map of keys -> (string | [string,...])
/// Try remote JSON URL first (dotenv: IMAGES_CONFIG_URL), otherwise loads
/// local asset assets/config/images.json.
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
  /// Returns null if not found.
  String? getImage(String key, {int index = 0}) {
    final val = _config[key];
    if (val == null) return null;
    if (val is String) return val;
    if (val is List && val.isNotEmpty) {
      final i = index < val.length ? index : 0;
      final entry = val[i];
      if (entry is String) return entry;
    }
    return null;
  }

  /// Return all image URLs (flattened) — useful for preloading.
  List<String> getAllImageUrls() {
    final List<String> urls = [];
    _config.forEach((_, v) {
      if (v is String) urls.add(v);
      if (v is List) {
        for (final e in v) {
          if (e is String) urls.add(e);
        }
      }
    });
    return urls;
  }

  /// Preload all images into the image cache. Provide a BuildContext.
  Future<void> preloadImages(BuildContext context) async {
    final urls = getAllImageUrls();
    for (final url in urls) {
      try {
        await precacheImage(NetworkImage(url), context);
      } catch (_) {
        // ignore individual preload failures
      }
    }
  }

  /// For debugging / admin: get raw config map
  Map<String, dynamic> get rawConfig => Map.unmodifiable(_config);
}
