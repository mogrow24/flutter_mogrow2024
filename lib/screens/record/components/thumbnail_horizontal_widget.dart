import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class ThumbnailHorizontalWidget extends StatefulWidget {
  final AssetEntity asset;
  final VoidCallback onRemove;

  const ThumbnailHorizontalWidget({
    super.key,
    required this.asset,
    required this.onRemove,
  });

  @override
  State<ThumbnailHorizontalWidget> createState() =>
      _ThumbnailHorizontalWidgetState();
}

class _ThumbnailHorizontalWidgetState extends State<ThumbnailHorizontalWidget> {
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
        ThumbnailSize(600, 600), // 더 높은 해상도
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
      width: 160,
      height: 160,
      margin: EdgeInsets.symmetric(horizontal: 1),
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
                  color: Color(0xFFFFFFFF).withOpacity(0.6),
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
