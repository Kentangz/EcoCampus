import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SmartImage extends StatelessWidget {
  final String pathOrUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const SmartImage(
    this.pathOrUrl, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget;

    if (pathOrUrl.isEmpty) {
      imageWidget = _buildPlaceholder(Icons.image_not_supported);
    } else if (pathOrUrl.startsWith('http')) {
      imageWidget = CachedNetworkImage(
        imageUrl: pathOrUrl,
        width: width,
        height: height,
        fit: fit,
        placeholder: (context, url) => _buildLoading(),
        errorWidget: (context, url, error) =>
            _buildPlaceholder(Icons.broken_image),
      );
    } else {
      File file = File(pathOrUrl);
      if (file.existsSync()) {
        imageWidget = Image.file(file, width: width, height: height, fit: fit);
      } else {
        imageWidget = _buildWaitingSync();
      }
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }
    return imageWidget;
  }

  Widget _buildPlaceholder(IconData icon) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Icon(icon, color: Colors.grey),
    );
  }

  Widget _buildLoading() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  Widget _buildWaitingSync() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.cloud_off, color: Colors.grey),
          const SizedBox(height: 4),
          const Text(
            "Menunggu Sync",
            style: TextStyle(fontSize: 10, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
