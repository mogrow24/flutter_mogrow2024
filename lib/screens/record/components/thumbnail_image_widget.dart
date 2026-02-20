import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class ThumbnailImageWidget extends StatefulWidget {
  final AssetEntity asset;
  final VoidCallback onRemove;
  final int index;

  const ThumbnailImageWidget({
    super.key,
    required this.asset,
    required this.onRemove,
    required this.index,
  });

  @override
  State<ThumbnailImageWidget> createState() => _ThumbnailImageWidgetState();
}

class _ThumbnailImageWidgetState extends State<ThumbnailImageWidget> {
  Uint8List? _thumbnail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadThumbnail();
  }

  Future<void> _loadThumbnail() async {
    try {
      final thumbnail = await widget.asset.thumbnailDataWithSize(
        ThumbnailSize(400, 400), // 더 높은 해상도
      );
      if (mounted) {
        setState(() {
          _thumbnail = thumbnail;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Color(0xFFE2E2EA),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF101828).withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 2.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _thumbnail != null
                    ? Image.memory(
                        _thumbnail!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        gaplessPlayback: true,
                      )
                    : Center(child: Icon(Icons.error)),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: GestureDetector(
              onTap: widget.onRemove,
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFFFFFFFF).withOpacity(0.7),
                  shape: BoxShape.circle,
                ),
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.close,
                  color: Color(0xFF667086),
                  size: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
