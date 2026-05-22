import 'dart:io';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path_provider/path_provider.dart';

class CacheManagerHelper {
  static Future<List<Directory>> _getCacheDirectories() async {
    final dirs = <Directory>[];

    try {
      dirs.add(await getTemporaryDirectory());
    } catch (_) {}

    try {
      dirs.add(await getApplicationCacheDirectory());
    } catch (_) {}

    return dirs;
  }

  static Future<double> getCacheSizeInMB() async {
    int totalBytes = 0;
    final dirs = await _getCacheDirectories();

    for (final dir in dirs) {
      if (await dir.exists()) {
        await for (final entity
            in dir.list(recursive: true, followLinks: false)) {
          if (entity is File) {
            try {
              totalBytes += await entity.length();
            } catch (_) {}
          }
        }
      }
    }

    return totalBytes / (1024 * 1024);
  }

  static Future<void> clearCache(double maxCacheSizeMB) async {
    final cacheSize = await getCacheSizeInMB();
    if (cacheSize >= maxCacheSizeMB) {
      await DefaultCacheManager().emptyCache();

      final dirs = await _getCacheDirectories();
      for (final dir in dirs) {
        if (await dir.exists()) {
          await for (final entity in dir.list(recursive: false)) {
            try {
              if (entity is File) {
                await entity.delete();
              } else if (entity is Directory) {
                await entity.delete(recursive: true);
              }
            } catch (_) {}
          }
        }
      }
    }
  }
}
