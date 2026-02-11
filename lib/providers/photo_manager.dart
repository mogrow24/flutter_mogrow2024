import 'package:flutter/foundation.dart';
import 'package:mogrow/database/database.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoManagerProvider extends ChangeNotifier {
  final Database database;
  late List<AssetEntity> _assets = []; // 사진첩에서 불러온 이미지들
  late bool _isLoading = true; // 로딩 상태 관리
  late List<bool> _selectedList; // 각 이미지의 선택 상태를 저장하는 리스트
  late final List<AssetEntity> _selectedImageList = [];
  late bool _isSelected;

  List<AssetEntity> get assets => _assets;
  List<AssetEntity> get selectedImageList => _selectedImageList;
  bool get isLoading => _isLoading;
  List<bool> get selectedList => _selectedList;
  bool get isSelected => _isSelected;

  // 생성자 함수
  PhotoManagerProvider(this.database);

  // 권한 확인
  Future<void> checkPermission() async {
    await PhotoManager.requestPermissionExtend().then((ps) {
      if (ps.isAuth) {
        //권한이 승인되었으면 getAlbum 실행
        getAlbums();
      } else {
        //권한이 없으면 설정을 열음.
        PhotoManager.openSetting();
      }
    });
  }

  ///* 앨범 데이터 가져오는 함수
  Future<void> getAlbums() async {
    final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
      type: RequestType.image,
    );

    if (albums.isNotEmpty) {
      AssetPathEntity targetAlbum = albums.first;
      for (final album in albums) {
        if (album.name.isEmpty || album.name.toLowerCase().contains('recent')) {
          targetAlbum = album;
          break;
        }
      }

      // 전체 사진 가져오기
      final allAssets = await targetAlbum.getAssetListRange(
        start: 0,
        end: await targetAlbum.assetCountAsync,
      );

      // 최신순 정렬
      allAssets.sort((a, b) {
        final aTime = a.modifiedDateTime ?? a.createDateTime ?? DateTime(1900);
        final bTime = b.modifiedDateTime ?? b.createDateTime ?? DateTime(1900);
        return bTime.compareTo(aTime);
      });

      // 상위 12개만 가져오기
      _assets = allAssets.take(12).toList();
    } else {
      _assets = [];
    }

    print(_assets);

    _isLoading = false;
    _selectedList = List.filled(assets.length, false);

    notifyListeners();
  }

  void toggleSelection(int index) {
    _selectedList[index] = !_selectedList[index];
    final asset = _assets[index];

    _isSelected = selectedImageList.contains(asset);

    if (_selectedList[index]) {
      _selectedImageList.add(asset);
    } else {
      _selectedImageList.remove(asset);
    }
    notifyListeners();
  }

  void removeSelectedImage(int index) {
    print(index);
    final target = _selectedImageList[index];

    // selectedImageList에서 제거
    _selectedImageList.removeAt(index);

    // assets에서의 인덱스 찾아서 selectedList 값도 false로 변경
    final assetIndex = _assets.indexOf(target);
    if (assetIndex != -1 && assetIndex < _selectedList.length) {
      _selectedList[assetIndex] = false;
    }

    notifyListeners();
  }

  // 수정화면 -> 초기에 이미지 리스트를 담아주기 위한 함수
  void setSelectedImageList(List<RecordsImage> list) async {
    print("수정화면 진입!!!!!!!!!");
    print(list);

    for (var item in list) {
      final asset = await AssetEntity.fromId(item.assetEntityId);
      print(asset);

      if (asset != null) {
        _selectedImageList.add(asset);
      }
    }
    print(selectedImageList);
    notifyListeners();
  }

  // 선택한 사진 리스트에 추가하기
  void addSelectedAssets(List<AssetEntity> assets) {
    for (final asset in assets) {
      if (!_selectedImageList.contains(asset)) {
        _selectedImageList.add(asset);
      }
    }
    notifyListeners();
  }

  void clearData() {
    _assets.clear();
    _selectedImageList.clear();
    _selectedList = [];
    _isLoading = true;
    notifyListeners();
  }

  @override
  void dispose() {
    // clearData();
    super.dispose();
  }
}
