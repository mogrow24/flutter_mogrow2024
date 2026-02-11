import 'package:flutter/material.dart';
import 'package:mogrow/database/database.dart';

class MultiImagePicker extends ChangeNotifier {
  final Database database;
  // List<Asset> _selectedImages = [];

  MultiImagePicker(this.database);

  // List<Asset> get selectedImages => _selectedImages;

  // void setSelectedImages(List<Asset> images) {
  //   _selectedImages = images;
  //   notifyListeners();
  // }

  // void addImage(Asset image) {
  //   _selectedImages.add(image);
  //   notifyListeners();
  // }

  // void removeImage(Asset image) {
  //   _selectedImages.remove(image);
  //   notifyListeners();
  // }
}
