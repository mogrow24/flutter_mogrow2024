import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class ThumbnailWidget extends StatefulWidget {
  final AssetEntity asset;

  const ThumbnailWidget({super.key, required this.asset});

  @override
  State<ThumbnailWidget> createState() => _ThumbnailWidgetState();
}

class _ThumbnailWidgetState extends State<ThumbnailWidget> {
  Uint8List? _thumbnail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  Future<void> _loadThumbnail() async {
    final thumbnail = await widget.asset.thumbnailData;
    if (mounted) {
      setState(() {
        _thumbnail = thumbnail;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_thumbnail == null) {
      return Center(child: Icon(Icons.error));
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.memory(
        _thumbnail!,
        fit: BoxFit.fill,
        gaplessPlayback: true,
      ),
    );
  }
}
