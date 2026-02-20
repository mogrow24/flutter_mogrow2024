import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mogrow/providers/photo_manager.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class AlbumSelectView extends StatefulWidget {
  const AlbumSelectView({super.key});

  @override
  State<AlbumSelectView> createState() => _AlbumSelectViewState();
}

class _AlbumSelectViewState extends State<AlbumSelectView> {
  List<AssetEntity> _allAssets = [];
  List<bool> _selected = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  bool _hasMore = true;

  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;
  final int _pageSize = 100;
  late AssetPathEntity _album;

  @override
  void initState() {
    super.initState();
    _initAlbum();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  //* 사진 정렬 함수 (최신순)
  void _sortAssetsByDate(List<AssetEntity> assets) {
    assets.sort((a, b) {
      final aTime = a.modifiedDateTime ?? a.createDateTime ?? DateTime(1900);
      final bTime = b.modifiedDateTime ?? b.createDateTime ?? DateTime(1900);
      return bTime.compareTo(aTime); // 최신순 (내림차순)
    });
  }

  Future<void> _initAlbum() async {
    try {
      final albums =
          await PhotoManager.getAssetPathList(type: RequestType.image);
      if (albums.isEmpty) {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final provider =
          Provider.of<PhotoManagerProvider>(context, listen: false);
      _album = albums.first;
      final assets =
          await _album.getAssetListPaged(page: _currentPage, size: _pageSize);

      // 첫번째 페이지 정렬
      _sortAssetsByDate(assets);

      setState(() {
        _allAssets = assets;
        _selected = assets.map((asset) {
          return provider.selectedImageList.contains(asset);
        }).toList();
        _isLoading = false;
      });
    } catch (e) {
      print("앨범 초기화 에러: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreAssets() async {
    if (_isLoadingMore || !_hasMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final newAssets = await _album.getAssetListPaged(
        page: ++_currentPage,
        size: _pageSize,
      );

      if (newAssets.isEmpty) {
        _hasMore = false;
      } else {
        final provider =
            Provider.of<PhotoManagerProvider>(context, listen: false);

        _sortAssetsByDate(newAssets);

        setState(() {
          _allAssets.addAll(newAssets);
          _selected.addAll(
            newAssets.map((asset) {
              return provider.selectedImageList.contains(asset);
            }).toList(),
          );
        });
      }
    } catch (e) {
      print("에러 발생: $e");
    } finally {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      // 끝에서 300px 남았을 때 다음 로드
      _loadMoreAssets();
    }
  }

  void _onConfirmSelection() {
    final selectedAssets = <AssetEntity>[];
    for (int i = 0; i < _allAssets.length; i++) {
      if (_selected[i]) selectedAssets.add(_allAssets[i]);
    }

    // Provider에 저장
    final provider = Provider.of<PhotoManagerProvider>(context, listen: false);
    provider.addSelectedAssets(selectedAssets);

    Navigator.pop(context); // 돌아가기
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Color(0xffF6F6F8),
        ),
        height: MediaQuery.of(context).size.height * 0.7, // 높이 조절 가능
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "사진 선택",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF14161A),
                  ),
                ),
                TextButton(
                  onPressed: _onConfirmSelection,
                  child: Text(
                    "완료",
                    style: TextStyle(
                      color: Color(0xFF5C42FF),
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 8),
            Expanded(
              child: _isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: Color(0xFF5C42FF),
                          ),
                          SizedBox(height: 16),
                          Text(
                            "사진을 불러오는 중...",
                            style: TextStyle(
                              color: Color(0xFF667086),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  : _allAssets.isEmpty
                      ? Center(
                          child: Text(
                            "사진이 없습니다",
                            style: TextStyle(
                              color: Color(0xFF667086),
                              fontSize: 14,
                            ),
                          ),
                        )
                      : GridView.builder(
                          controller: _scrollController,
                          itemCount:
                              _allAssets.length + (_isLoadingMore ? 1 : 0),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                          ),
                          itemBuilder: (context, index) {
                            if (index >= _allAssets.length) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF5C42FF),
                                ),
                              );
                            }

                            return FutureBuilder<Uint8List?>(
                              future: _allAssets[index].thumbnailDataWithSize(
                                  ThumbnailSize(200, 200)),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Container(
                                    color: Colors.grey.shade200,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Color(0xFF5C42FF),
                                      ),
                                    ),
                                  );
                                }
                                return GestureDetector(
                                  onTap: () {
                                    if (index < _selected.length) {
                                      setState(() {
                                        _selected[index] = !_selected[index];
                                      });
                                    }
                                  },
                                  child: Stack(
                                    children: [
                                      Positioned.fill(
                                        child: Image.memory(
                                          snapshot.data!,
                                          fit: BoxFit.cover,
                                          gaplessPlayback: true,
                                        ),
                                      ),
                                      if (_selected[index])
                                        Positioned(
                                          top: 2,
                                          right: 2,
                                          child: Container(
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: Color(0xFF5C42FF),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.check,
                                              size: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
